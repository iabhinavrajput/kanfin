import 'package:flutter/material.dart';

class LoanApplication {
  final String id;
  final String loanType;
  final String status; // submitted, under_review, approved, disbursed, rejected
  final DateTime submissionDate;
  final String applicantName;
  final String email;
  final String mobile;
  final String address;
  final Map<String, dynamic> loanDetails; // vendor, vehicle, item details
  final Map<String, dynamic> references;
  final Map<String, dynamic> documents;
  final DateTime? reviewDate;
  final DateTime? approvalDate;
  final double? loanAmount;
  final double? interestRate;

  LoanApplication({
    required this.id,
    required this.loanType,
    required this.status,
    required this.submissionDate,
    required this.applicantName,
    required this.email,
    required this.mobile,
    required this.address,
    required this.loanDetails,
    required this.references,
    required this.documents,
    this.reviewDate,
    this.approvalDate,
    this.loanAmount,
    this.interestRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loanType': loanType,
      'status': status,
      'submissionDate': submissionDate.toIso8601String(),
      'applicantName': applicantName,
      'email': email,
      'mobile': mobile,
      'address': address,
      'loanDetails': loanDetails,
      'references': references,
      'documents': documents,
      'reviewDate': reviewDate?.toIso8601String(),
      'approvalDate': approvalDate?.toIso8601String(),
      'loanAmount': loanAmount,
      'interestRate': interestRate,
    };
  }

  factory LoanApplication.fromJson(Map<String, dynamic> json) {
    return LoanApplication(
      id: json['id'],
      loanType: json['loanType'],
      status: json['status'],
      submissionDate: DateTime.parse(json['submissionDate']),
      applicantName: json['applicantName'],
      email: json['email'],
      mobile: json['mobile'],
      address: json['address'],
      loanDetails: json['loanDetails'],
      references: json['references'],
      documents: json['documents'],
      reviewDate: json['reviewDate'] != null
          ? DateTime.parse(json['reviewDate'])
          : null,
      approvalDate: json['approvalDate'] != null
          ? DateTime.parse(json['approvalDate'])
          : null,
      loanAmount: json['loanAmount']?.toDouble(),
      interestRate: json['interestRate']?.toDouble(),
    );
  }

  LoanApplication copyWith({
    String? status,
    DateTime? reviewDate,
    DateTime? approvalDate,
    double? loanAmount,
    double? interestRate,
  }) {
    return LoanApplication(
      id: id,
      loanType: loanType,
      status: status ?? this.status,
      submissionDate: submissionDate,
      applicantName: applicantName,
      email: email,
      mobile: mobile,
      address: address,
      loanDetails: loanDetails,
      references: references,
      documents: documents,
      reviewDate: reviewDate ?? this.reviewDate,
      approvalDate: approvalDate ?? this.approvalDate,
      loanAmount: loanAmount ?? this.loanAmount,
      interestRate: interestRate ?? this.interestRate,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case 'submitted':
        return 'Submitted';
      case 'under_review':
        return 'Under Review';
      case 'approved':
        return 'Approved';
      case 'disbursed':
        return 'Disbursed';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'submitted':
        return Colors.blue;
      case 'under_review':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'disbursed':
        return Colors.teal;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 'submitted':
        return Icons.send;
      case 'under_review':
        return Icons.hourglass_empty;
      case 'approved':
        return Icons.check_circle;
      case 'disbursed':
        return Icons.account_balance_wallet;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}
