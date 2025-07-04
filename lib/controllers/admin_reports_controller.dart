import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminReportsController extends GetxController {
  final users = <UserReport>[].obs;
  final selectedUserType = 'All'.obs;
  final Rx<DateTimeRange?> dateRange = Rx<DateTimeRange?>(null);
  final searchText = ''.obs;
  final searchController = TextEditingController();

  String get dateRangeStr => dateRange.value == null
      ? ''
      : '${DateFormat.yMd().format(dateRange.value!.start)} - ${DateFormat.yMd().format(dateRange.value!.end)}';

  List<UserReport> get filteredUsers {
    return users.where((u) {
      final inType = selectedUserType.value == 'All' || u.type == selectedUserType.value;
      final inDate = dateRange.value == null ||
          (!u.activity.lastSession.isBefore(dateRange.value!.start) &&
              !u.activity.lastSession.isAfter(dateRange.value!.end));
      final query = searchText.value.toLowerCase();
      final matchesSearch = u.name.toLowerCase().contains(query) || u.type.toLowerCase().contains(query);
      return inType && inDate && matchesSearch;
    }).toList();
  }

  void setUserType(String? t) => selectedUserType.value = t ?? 'All';

  void setDateRange(DateTimeRange dr) => dateRange.value = dr;

  void updateSearch(String query) => searchText.value = query;

  @override
  void onInit() {
    super.onInit();
    _loadSampleUsers();
  }

  void _loadSampleUsers() {
    users.addAll([
      UserReport('U001', 'Amit Sharma', 'Member',
        UserActivity(20, 35, 88, DateTime.now().subtract(Duration(days: 2))),
        UserFinancial(15000.0, 5000.0),
        UserFeePayment(10000.0, 2000.0),
      ),
      UserReport('U002', 'Priya Verma', 'Trainer',
        UserActivity(18, 29, 75, DateTime.now().subtract(Duration(days: 5))),
        UserFinancial(18000.0, 3000.0),
        UserFeePayment(15000.0, 1000.0),
      ),
    ]
    );

  }

  void exportUserReportPDF(UserReport u) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (ctx) => pw.Column(children: [
        pw.Text('Report for ${u.name}', style: pw.TextStyle(fontSize: 22)),
        pw.SizedBox(height: 10),
        pw.Text('User Type: ${u.type}'),
        pw.Text('Sessions: ${u.activity.sessions}'),
        pw.Text('Activity Score: ${u.activity.activityScore}%'),
        pw.Text('Last Session: ${DateFormat.yMMMd().format(u.activity.lastSession)}'),
        pw.SizedBox(height: 10),
        pw.Text('Revenue: ₹${u.financial.revenue}'),
        pw.Text('Expenses: ₹${u.financial.expenses}'),
        pw.Text('Fee Paid: ₹${u.feePayment.paid}'),
        pw.Text('Fee Due: ₹${u.feePayment.due}'),
      ]),
    ));

    await Printing.sharePdf(bytes: await pdf.save(), filename: '${u.id}_report.pdf');
  }
}


class UserReport {
  final String id, name, type;
  final UserActivity activity;
  final UserFinancial financial;
  final UserFeePayment feePayment;

  UserReport(this.id, this.name, this.type, this.activity, this.financial, this.feePayment);
}

class UserActivity {
  final int logins, sessions, activityScore;
  final DateTime lastSession;

  UserActivity(this.logins, this.sessions, this.activityScore, this.lastSession);
}

class UserFinancial {
  final double revenue, expenses;

  UserFinancial(this.revenue, this.expenses);
}

class UserFeePayment {
  final double paid, due;

  UserFeePayment(this.paid, this.due);
}
