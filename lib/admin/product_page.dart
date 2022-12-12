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
    productId.clear();
    productName.clear();
    productDescription.clear();
    productPrice.clear();
    productCategoryId.clear();
    productBenefit.clear();
    productStock.clear();
    productStatus.clear();
    productDate.clear();
    productSellerId.clear();
    productNumber.clear();

    var catId = widget.category_id;
    print(catId);
    final response = await http.get(
      Uri.parse(
          'https://golalang-online-sklad-production.up.railway.app/getProductsByCategory?categoryId=$catId'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data.length);
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
            elevation: 0.4,
            actionsIconTheme: const IconThemeData(color: Colors.black),
            iconTheme: const IconThemeData(color: Colors.black),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.category_name,
                    style: const TextStyle(fontSize: 20, color: Colors.black)),
                const Expanded(
                  child: SizedBox(),
                ),
                SizedBox(
                  height: 30,
                  width: MediaQuery.of(context).size.width / 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 221, 221, 221),
                      border: Border.all(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          width: 1),
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
                  width: MediaQuery.of(context).size.width / 50,
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
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () {
                      //read product
                    },
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.35),
                                  //color: Color.fromARGB(255, 221, 221, 221),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height / 50),
                                //product qo`shish
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 50,
                                    ),
                                    const Text(
                                      'Yangi mahsulot',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    IconButton(onPressed:
                                        () {},
                                        icon: const Icon(Icons.add_circle_outline_outlined,color: Colors.deepPurpleAccent,size: 30,)),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 35,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height / 50),
                              ],
                            ),
                          ),
                          for (var i = 0; i < productId.length; i++)
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.35),
                                    //color: Color.fromARGB(255, 221, 221, 221),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height / 50),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width:
                                          MediaQuery.of(context).size.width * 0.01),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: SvgPicture.asset(
                                          'assets/productIcon.svg',
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                          MediaQuery.of(context).size.width * 0.01),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              productName[i],
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${productPrice[i]} so\'m',
                                              style: const TextStyle(
                                                  fontSize: 16,fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              productDescription[i],
                                              style: const TextStyle(
                                                  fontSize: 14, color: Colors.grey,fontWeight: FontWeight.bold),
                                            ),

                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: SvgPicture.asset(
                                          'assets/editIcon.svg',
                                          height: 25,
                                          width: 25,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.005,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: SvgPicture.asset(
                                          'assets/deleteIcon.svg',
                                          height: 25,
                                          width: 25,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width / 40,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height / 50),
                                ],
                              ),
                            ),
                        ],
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
