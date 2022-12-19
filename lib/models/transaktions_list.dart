class TransaktionList {
  final String transactionId;
  final String transactionDate;
  final String transactionSeller;
  final String transactionProduct;
  final int transactionNumber;
  final int transactionPrice;
  final String transactionStatus;
  final int transactionBenefit;

  TransaktionList(
      {required this.transactionId,
      required this.transactionDate,
      required this.transactionSeller,
      required this.transactionProduct,
      required this.transactionNumber,
      required this.transactionPrice,
      required this.transactionStatus,
      required this.transactionBenefit});

  factory TransaktionList.fromJson(Map<String, dynamic> json) {
    return TransaktionList(
      transactionId: json['id'],
      transactionDate: json['date'],
      transactionSeller: json['seller'],
      transactionProduct: json['product'],
      transactionNumber: json['number'],
      transactionPrice: json['price'],
      transactionStatus: json['status'],
      transactionBenefit: json['benefit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': transactionId,
      'date': transactionDate,
      'seller': transactionSeller,
      'product': transactionProduct,
      'number': transactionNumber,
      'price': transactionPrice,
      'status': transactionStatus,
      'benefit': transactionBenefit,
    };
  }


}
