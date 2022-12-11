import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  var category_id;
  var category_name;

  ProductPage({super.key, this.category_id, this.category_name});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  var productId = [];
  var productName = [];
  var productDescription = [];
  var productPrice = [];
  var productCategoryId = [];
  var productBenefit = [];
  var productStock = [];
  var productStatus = [];
  var productDate = [];
  var productSellerId = [];
  var productNumber = [];

  Future<void> _getProductsByCategory() async {
    var catId = widget.category_id;
    print(catId);
    final response = await http.get(
      Uri.parse(
          'https://golalang-online-sklad-production.up.railway.app/getProductsByCategory?categoryId=$catId'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var i = 0; i < data.length; i++) {
        setState(() {
          productId.add(data['data'][i]['product_id']);
          productName.add(data['data'][i]['product_name']);
          productDescription.add(data['data'][i]['product_desc']);
          productPrice.add(data['data'][i]['product_price']);
          productCategoryId.add(data['data'][i]['product_cat_id']);
          productBenefit.add(data['data'][i]['product_benefit']);
          productStock.add(data['data'][i]['product_stock']);
          productStatus.add(data['data'][i]['product_status']);
          productDate.add(data['data'][i]['product_date']);
          productSellerId.add(data['data'][i]['product_seller']);
          productNumber.add(data['data'][i]['product_number']);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(milliseconds: 1700),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void initState() {
    _getProductsByCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (productId.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), // here the desired height
          child: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.category_name),
                const Expanded(child:SizedBox(),),
                SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width/4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 221, 221, 221),
                      border: Border.all(
                          color: const Color.fromARGB(255, 221, 221, 221), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextField(
                      cursorColor: Colors.deepPurpleAccent,
                      textAlign: TextAlign.justify,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'Qidirish',
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width/50,
                ),
                IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.white,
                  color: Colors.white,
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/userIcon.svg',
                    height: 25,
                    width: 25,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: productName.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(productName[index]),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
