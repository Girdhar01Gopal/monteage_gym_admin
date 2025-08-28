import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/admin_qr_payment_controller.dart';
import '../utils/constants/color_constants.dart'; // adjust import to your path

class AdminQrPaymentScreen extends StatelessWidget {
  AdminQrPaymentScreen({super.key});

  final AdminQrPaymentController controller =
  Get.put(AdminQrPaymentController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Receive Payment via QR", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.APP_Color_Indigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 380;
          final pad = isNarrow ? 16.0 : 18.0;
          final qrSize = isNarrow ? 200.0 : 240.0;

          final gapNameToQr = isNarrow ? 8.0 : 10.0;
          final gapQrToAmount = isNarrow ? 8.0 : 10.0;
          final gapBetweenButtons = isNarrow ? 8.0 : 10.0;
          final gapHistoryToPdf = isNarrow ? 8.0 : 10.0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(pad),
            child: Obx(() {
              final memberName = controller.memberName.value;
              final amount = controller.amountDue.value;

              final upiUrl =
                  'upi://pay?pa=${controller.upiId}&pn=${controller.upiName}&am=${amount.toStringAsFixed(2)}&cu=INR';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Member Name
                  Text(
                    memberName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: isNarrow ? 20 : 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: gapNameToQr),

                  // QR Code (encodes the UPI URL)
                  QrImageView(
                    data: upiUrl,
                    size: qrSize,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: gapQrToAmount),

                  // Amount
                  Text(
                    controller.formatAmount(amount),
                    style: TextStyle(fontSize: isNarrow ? 22 : 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),

                  // UPI ID
                  Text(
                    "UPI ID: ${controller.upiId}",
                    style: TextStyle(fontSize: isNarrow ? 13 : 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),

                  // Open in UPI App
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new, color: Colors.white),
                      label: const Text("Open in UPI App", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: isNarrow ? 10 : 12),
                      ),
                      onPressed: () async {
                        final ok = await controller.openInUpiApp();
                        if (!ok) {
                          Get.snackbar("Error", "No UPI app found or cannot open.");
                        }
                      },
                    ),
                  ),

                  SizedBox(height: gapBetweenButtons),

                  // View Payment History
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.history, color: Colors.white),
                      label:
                      const Text("View Payment History", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: isNarrow ? 10 : 12),
                      ),
                      onPressed: () => _showPaymentHistoryDialog(context),
                    ),
                  ),

                  SizedBox(height: gapHistoryToPdf),

                  // PDF export buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildPdfButton("10 Days History PDF",
                              () => _generatePdf(context, days: 10), compact: isNarrow),
                      const SizedBox(height: 8),
                      _buildPdfButton("1 Month History PDF",
                              () => _generatePdf(context, days: 30), compact: isNarrow),
                      const SizedBox(height: 8),
                      _buildPdfButton("3 Months History PDF",
                              () => _generatePdf(context, days: 90), compact: isNarrow),
                    ],
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
  }

  // ----------- UI helpers -----------

  Widget _buildPdfButton(String title, VoidCallback onPressed, {bool compact = false}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.black, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(vertical: compact ? 10 : 12),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  void _showPaymentHistoryDialog(BuildContext context) {
    final c = controller;
    Get.dialog(
      AlertDialog(
        title: const Text("Payment History"),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() {
            final items = c.paymentHistory.take(20).toList();
            return SingleChildScrollView(
              child: Column(
                children: items.map((entry) {
                  final isCredit = (entry['type'] == 'Credit');
                  final date = entry['date'] as DateTime;
                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    title: Text("${entry['name']} (${entry['phone']})"),
                    subtitle: Text(
                      "${c.formatAmount(entry['amount'])} • ${entry['type']} • ${c.formatDate(date)}",
                      style: TextStyle(color: isCredit ? Colors.green : Colors.red),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
        ],
      ),
    );
  }

  // ----------- PDF generation -----------

  Future<void> _generatePdf(BuildContext context, {required int days}) async {
    try {
      final pdf = pw.Document();
      final c = controller;
      final filtered = c.getFilteredHistory(days);

      // Totals
      final totalCredit = filtered
          .where((e) => e['type'] == 'Credit')
          .fold<num>(0, (sum, e) => sum + (e['amount'] as num));
      final totalDebit = filtered
          .where((e) => e['type'] == 'Debit')
          .fold<num>(0, (sum, e) => sum + (e['amount'] as num));
      final net = totalCredit - totalDebit;

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Text("Payment History (Last $days Days)",
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text("Member: ${c.memberName.value}"),
            pw.Text("Generated: ${DateTime.now()}"),
            pw.SizedBox(height: 12),

            // Summary
            pw.Row(children: [
              pw.Expanded(child: pw.Text("Total Credit: ${c.formatAmount(totalCredit)}")),
              pw.Expanded(child: pw.Text("Total Debit: ${c.formatAmount(totalDebit)}")),
              pw.Expanded(child: pw.Text("Net: ${c.formatAmount(net)}")),
            ]),
            pw.SizedBox(height: 10),

            // Table
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              columnWidths: const {
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(3),
                2: pw.FlexColumnWidth(2),
                3: pw.FlexColumnWidth(2),
                4: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColorGrey700),
                  children: [
                    _cell("Name", bold: true, white: true),
                    _cell("Phone", bold: true, white: true),
                    _cell("Amount", bold: true, white: true),
                    _cell("Type", bold: true, white: true),
                    _cell("Date", bold: true, white: true),
                  ],
                ),
                ...filtered.map((e) {
                  final dt = e['date'] as DateTime;
                  return pw.TableRow(children: [
                    _cell(e['name']),
                    _cell(e['phone']),
                    _cell(c.formatAmount(e['amount'])),
                    _cell(e['type']),
                    _cell(c.formatDate(dt)),
                  ]);
                }).toList(),
              ],
            ),
          ],
        ),
      );

      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    } catch (e) {
      Get.snackbar("PDF Error", "Failed to generate PDF: $e");
    }
  }
}

// Small helper for table cell styling in PDF
pw.Widget _cell(String text, {bool bold = false, bool white = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: white ? PdfColorWhite : PdfColorBlack,
      ),
    ),
  );
}

// Simple colors for header row
const PdfColor PdfColorWhite = PdfColor(1, 1, 1);
const PdfColor PdfColorBlack = PdfColor(0, 0, 0);
const PdfColor PdfColorGrey700 = PdfColor(0.3, 0.3, 0.3);
