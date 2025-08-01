import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminReportsController extends GetxController {
  final users = <UserReport>[].obs;
  final selectedUserType = 'All'.obs;
  final searchText = ''.obs;
  final searchController = TextEditingController();

  List<UserReport> get filteredUsers {
    return users.where((u) {
      final inType = selectedUserType.value == 'All' || u.type == selectedUserType.value;
      final query = searchText.value.toLowerCase();
      final matchesSearch = u.name.toLowerCase().contains(query) || u.type.toLowerCase().contains(query);
      return inType && matchesSearch;
    }).toList();
  }

  void setUserType(String? t) => selectedUserType.value = t ?? 'All';
  void updateSearch(String query) => searchText.value = query;

  @override
  void onInit() {
    super.onInit();
    _loadSampleUsers();
  }

  void _loadSampleUsers() {
    users.addAll([
      UserReport(
        id: 'U001',
        name: 'Amit Sharma',
        type: 'Member',
        email: 'amit@example.com',
        phone: '9876543210',
        address: 'Delhi, India',
        fatherName: 'Rajesh Sharma',
        plan: 'Gold Plan',
        totalPayment: 12000,
        duePayment: 2000,
        discount: 1000,
      ),
      UserReport(
        id: 'U002',
        name: 'Priya Verma',
        type: 'Trainer',
        email: 'priya@example.com',
        phone: '9012345678',
        address: 'Mumbai, India',
        fatherName: 'Suresh Verma',
        plan: 'Platinum Plan',
        totalPayment: 18000,
        duePayment: 1500,
        discount: 2000,
      ),
    ]);
  }

  void exportUserReportPDF(UserReport u) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (ctx) => pw.Column(children: [
        pw.Text('Report for ${u.name}', style: pw.TextStyle(fontSize: 22)),
        pw.SizedBox(height: 10),
        pw.Text('User Type: ${u.type}'),
        pw.Text('Email: ${u.email}'),
        pw.Text('Phone: ${u.phone}'),
        pw.Text('Address: ${u.address}'),
        pw.Text('Father Name: ${u.fatherName}'),
        pw.Text('Plan: ${u.plan}'),
        pw.Text('Total Payment: ₹${u.totalPayment}'),
        pw.Text('Due Payment: ₹${u.duePayment}'),
        pw.Text('Discount: ₹${u.discount}'),
      ]),
    ));

    await Printing.sharePdf(bytes: await pdf.save(), filename: '${u.id}_report.pdf');
  }
}

class UserReport {
  final String id, name, type, email, phone, address, fatherName, plan;
  final double totalPayment, duePayment, discount;

  UserReport({
    required this.id,
    required this.name,
    required this.type,
    required this.email,
    required this.phone,
    required this.address,
    required this.fatherName,
    required this.plan,
    required this.totalPayment,
    required this.duePayment,
    required this.discount,
  });
}
