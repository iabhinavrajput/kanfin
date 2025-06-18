class LoanTypesRequest {
  final String loanType;

  LoanTypesRequest({
    required this.loanType,
  });

  Map<String, dynamic> toJson() {
    return {
      'loanType': loanType,
    };
  }
}

class LoanTypesResponse {
  final bool success;
  final List<LoanTypeData> data;

  LoanTypesResponse({
    required this.success,
    required this.data,
  });

  factory LoanTypesResponse.fromJson(Map<String, dynamic> json) {
    return LoanTypesResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => LoanTypeData.fromJson(item))
              .toList()
          : [],
    );
  }
}

class LoanTypeData {
  final int id;
  final String loanType;

  LoanTypeData({
    required this.id,
    required this.loanType,
  });

  factory LoanTypeData.fromJson(Map<String, dynamic> json) {
    return LoanTypeData(
      id: json['id'] ?? 0,
      loanType: json['loan_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loan_type': loanType,
    };
  }

  // Helper methods to get display information
  String get displayName {
    switch (loanType.toLowerCase()) {
      case 'ev':
        return 'Electric Vehicle Loan';
      case 'gold':
        return 'Gold Loan';
      default:
        return loanType;
    }
  }

  String get subtitle {
    switch (loanType.toLowerCase()) {
      case 'ev':
        return 'Finance your eco-friendly ride';
      case 'gold':
        return 'Quick approval against gold collateral';
      default:
        return 'Loan facility';
    }
  }

  String get description {
    switch (loanType.toLowerCase()) {
      case 'ev':
        return 'Special rates for electric vehicles with extended tenure options';
      case 'gold':
        return 'Get instant loans against your gold jewelry with minimal documentation';
      default:
        return 'Flexible loan options for your needs';
    }
  }

  List<String> get features {
    switch (loanType.toLowerCase()) {
      case 'ev':
        return [
          'Special EV loan rates',
          'Up to 90% financing',
          'Extended loan tenure',
          'Green incentives available'
        ];
      case 'gold':
        return [
          'Quick approval in 30 minutes',
          'Up to 75% of gold value',
          'Flexible repayment options',
          'Minimal documentation'
        ];
      default:
        return ['Competitive rates', 'Easy approval', 'Flexible terms'];
    }
  }

  String get iconName {
    switch (loanType.toLowerCase()) {
      case 'ev':
        return 'electric_car';
      case 'gold':
        return 'diamond';
      default:
        return 'account_balance';
    }
  }

  String get routeName {
    switch (loanType.toLowerCase()) {
      case 'ev':
        return 'VENDOR_SELECTION';
      case 'gold':
        return 'VENDOR_SELECTION';
      default:
        return 'VENDOR_SELECTION';
    }
  }
}
