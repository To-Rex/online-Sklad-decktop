class TransaktionList {
  final String transactionId;
  final String transactionDate;
  final String transactionSeller;
  final String transactionProductName;
  final String transactionProduct;
  final int transactionNumber;
  final int transactionPrice;
  final String transactionStatus;
  final int transactionBenefit;

  TransaktionList(
      {required this.transactionId,
      required this.transactionDate,
      required this.transactionSeller,
      required this.transactionProductName,
      required this.transactionProduct,
      required this.transactionNumber,
      required this.transactionPrice,
      required this.transactionStatus,
      required this.transactionBenefit});

  factory TransaktionList.fromJson(Map<String, dynamic> json) {
    return TransaktionList(
      transactionId: json['transaction_id'],
      transactionDate: json['transaction_date'],
      transactionSeller: json['transaction_seller'],
      transactionProductName: json['transaction_product_name'],
      transactionProduct: json['transaction_product'],
      transactionNumber: json['transaction_number'],
      transactionPrice: json['transaction_price'],
      transactionStatus: json['transaction_status'],
      transactionBenefit: json['transaction_benefit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'transaction_date': transactionDate,
      'transaction_seller': transactionSeller,
      'transaction_product_name': transactionProductName,
      'transaction_product': transactionProduct,
      'transaction_number': transactionNumber,
      'transaction_price': transactionPrice,
      'transaction_status': transactionStatus,
      'transaction_benefit': transactionBenefit,
    };
  }

  @override
  String toString() {
    return 'TransaktionList{transactionId: $transactionId, transactionDate: $transactionDate, transactionSeller: $transactionSeller, transactionProductName: $transactionProductName, transactionProduct: $transactionProduct, transactionNumber: $transactionNumber, transactionPrice: $transactionPrice, transactionStatus: $transactionStatus, transactionBenefit: $transactionBenefit}';
  }
}
