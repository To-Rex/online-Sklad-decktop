class ProductList {
  final String productId;
  final String productName;
  final String productDescription;
  final String productCatId;
  final int productPrice;
  final int productBenefit;
  final String productStock;
  final String productStatus;
  final String productDate;
  final String productSeller;
  final int productNumber;

  //Class 'ProductList' has no instance getter 'product_name' with matching arguments
  ProductList(
      {required this.productId,
      required this.productName,
      required this.productDescription,
      required this.productCatId,
      required this.productPrice,
      required this.productBenefit,
      required this.productStock,
      required this.productStatus,
      required this.productDate,
      required this.productSeller,
      required this.productNumber});

  factory ProductList.fromJson(Map<String, dynamic> json) {
    return ProductList(
      productId: json['product_id'],
      productName: json['product_name'],
      productDescription: json['product_description'],
      productCatId: json['product_cat_id'],
      productPrice: json['product_price'],
      productBenefit: json['product_benefit'],
      productStock: json['product_stock'],
      productStatus: json['product_status'],
      productDate: json['product_date'],
      productSeller: json['product_seller'],
      productNumber: json['product_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_description': productDescription,
      'product_cat_id': productCatId,
      'product_price': productPrice,
      'product_benefit': productBenefit,
      'product_stock': productStock,
      'product_status': productStatus,
      'product_date': productDate,
      'product_seller': productSeller,
      'product_number': productNumber,
    };
  }


}