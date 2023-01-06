import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:online_sklad/admin/tarnsaktion_page.dart';
import 'package:online_sklad/admin/user_page.dart';
import 'package:online_sklad/models/product_list.dart';
import 'package:online_sklad/user/tarnsaktion_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPageUser extends StatefulWidget {
  var category_id;
  var category_name;

  ProductPageUser({super.key, this.category_id, this.category_name});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPageUser>
    with SingleTickerProviderStateMixin {
  late final _productNameController = TextEditingController();
  late final _productDescriptionController = TextEditingController();
  late final _productPriceController = TextEditingController();
  late final _productBenefitController = TextEditingController();
  late final _productStockController = TextEditingController();
  late final _productNumberController = TextEditingController();
  late final _productNumbersController = TextEditingController();

  final _productList = [];
  var products = [];

  var userName = '';
  var userId = '';
  var userSurname = '';
  var userPhone = '';
  var userRole = '';
  var userStatus = '';
  var userBlocked = false;
  var userNames = '';
  var minWeight = '';
  var maxWeight = '';
  var minHeight = '';
  var maxHeight = '';
  var _isLoad = true;

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('name') ?? '';
    userId = prefs.getString('userid') ?? '';
    userSurname = prefs.getString('surname') ?? '';
    userPhone = prefs.getString('phone') ?? '';
    userRole = prefs.getString('role') ?? '';
    userStatus = prefs.getString('userstatus') ?? '';
    userBlocked = prefs.getBool('blocked') ?? false;
    userNames = prefs.getString('username') ?? '';
  }

  Future<void> _getProductsByCategory() async {
    var catId = widget.category_id;
    final response = await http.get(
      Uri.parse(
          'https://golalang-online-sklad-production.up.railway.app/getProductsByCategory?categoryId=$catId'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _productList.clear();
      if (data['status'] == 'success' && data['data'] == null) {
        _isLoad = false;
        setState(() {});
        return;
      }
      for (var i = 0; i < data['data'].length; i++) {
        _isLoad = false;
        _productList.add(ProductList(
          productId: data['data'][i]['product_id'],
          productName: data['data'][i]['product_name'],
          productDescription: data['data'][i]['product_desc'],
          productPrice: data['data'][i]['product_price'],
          productCatId: data['data'][i]['product_cat_id'],
          productBenefit: data['data'][i]['product_benefit'],
          productStock: data['data'][i]['product_stock'],
          productStatus: data['data'][i]['product_status'],
          productDate: data['data'][i]['product_date'],
          productSeller: data['data'][i]['product_seller'],
          productNumber: data['data'][i]['product_number'],
        ));
        products = _productList;
        setState(() {});
      }
    } else {
      _isLoad = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Internet ulanish yo\'q yoki serverda xatolik'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(milliseconds: 1700),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _sellProduct(String productId) async {
    checkInternetConnection().then((value) {
      if (!value) {
        _isLoad = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Internetga ulanish yo\'q!'),
          backgroundColor: Colors.red,
        ));
        return;
      }
    });
    var number = int.parse(_productNumbersController.text);
    final response = await http.post(
      Uri.parse('https://golalang-online-sklad-production.up.railway.app/productSell?productId=$productId&userId=$userId&number=$number'),
      body: {
        'addition_price': _productPriceController.text,
      },
    );
    if (response.statusCode == 200) {
      _productNumbersController.clear();
      _productPriceController.clear();
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mahsulot sotildi'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 1700),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
        _getProductsByCategory();
      } else {
        _isLoad = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mahsulot sotilmadi. Mahsulot yetarli emas'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 3000),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showProductDialog(String id, int productNumber) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Mahsulotni sotish'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 221, 221, 221),
                      border: Border.all(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      cursorColor: Colors.deepPurpleAccent,
                      controller: _productPriceController,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      keyboardAppearance: Brightness.light,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'Ustama haq',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          border: Border.all(
                              color: const Color.fromARGB(255, 221, 221, 221),
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (_productNumbersController.text.isEmpty) {
                              _productNumbersController.text = '0';
                              return;
                            }
                            if (int.parse(_productNumbersController.text) <
                                0) {
                              _productNumbersController.text = '0';
                              return;
                            }
                            if (int.parse(_productNumbersController.text) ==
                                0) {
                              return;
                            }
                            _productNumbersController.text =
                                (int.parse(_productNumbersController.text) - 1)
                                    .toString();
                            setState(() {});
                          },
                          icon: SvgPicture.asset(
                            'assets/minusIcon.svg',
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          border: Border.all(
                              color: const Color.fromARGB(255, 221, 221, 221),
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: TextField(
                            cursorColor: Colors.deepPurpleAccent,
                            controller: _productNumbersController,
                            textAlign: TextAlign.center,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: const InputDecoration(
                              contentPadding:
                              EdgeInsets.only(left: 10, right: 10),
                              border: InputBorder.none,
                              hintText: 'Mahsulot miqdori',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          border: Border.all(
                              color: const Color.fromARGB(255, 221, 221, 221),
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (_productNumbersController.text.isEmpty) {
                              _productNumbersController.text = '0';
                            }
                            if (int.parse(_productNumbersController.text) <
                                0) {
                              _productNumbersController.text = '0';
                            }
                            _productNumbersController.text =
                                (int.parse(_productNumbersController.text) + 1)
                                    .toString();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _productNumbersController.clear();
                  _productPriceController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Bekor qilish'),
              ),
              TextButton(
                onPressed: () {
                  if (_productNumbersController.text.isEmpty||
                      _productNumbersController.text == ''|| _productNumbersController.text == '0') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mahsulot sonini kiriting!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    if (int.parse(_productNumbersController.text) > productNumber) {
                      _isLoad = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mahsulot soni yetarli emas!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    _isLoad = true;
                    setState(() {});
                    _sellProduct(id);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Sotish'),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    _getUser();
    _getProductsByCategory();
    super.initState();
    checkInternetConnection().then((value) {
      if (!value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Internetga ulanish yo\'q!'),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _productPriceController.dispose();
    _productBenefitController.dispose();
    _productStockController.dispose();
    _productNumberController.dispose();
    _productNumbersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: TextField(
                    cursorColor: Colors.deepPurpleAccent,
                    textAlign: TextAlign.justify,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() {
                        _searchProduct(value);
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: InputBorder.none,
                      hintText: 'Qidirish',
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.deepPurpleAccent,
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransaktionsPageUser(),
                    ),
                  );
                },
                icon: SvgPicture.asset(
                  'assets/userStatic.svg',
                  height: 25,
                  width: 25,
                  color: Colors.deepPurpleAccent,
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
                for (var i = 0; i < products.length; i++)
                  GestureDetector(
                    onTap: () {
                      _showProductDialog(
                          products[i].productId, products[i].productNumber);
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
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: SvgPicture.asset(
                                      'assets/productIcon.svg',
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          products[i].productName,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${products[i].productPrice + products[i].productBenefit} so\'m',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          products[i].productDescription,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 221, 221, 221),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 221, 221, 221),
                                          width: 5),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                        '  ${products[i].productNumber}  Dona  '),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.009,
                                  ),
                                  // IconButton(
                                  //     onPressed: () {
                                  //       _productPriceController.text = products[i].productPrice.toString();
                                  //       _productBenefitController.text = products[i].productBenefit.toString();
                                  //       _showDialogSellProduct(products[i].productId,products[i].productName);
                                  //     },
                                  //     icon: const Icon(
                                  //       Icons.sell_outlined,
                                  //       color: Colors.deepPurpleAccent,
                                  //       size: 30,
                                  //     )),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.005,
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                            ],
                          ),
                        ),
                        if (_productList.isEmpty)
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
                                    height: MediaQuery.of(context).size.height /
                                        50),
                                const Center(
                                  child: Text(
                                    'Hozircha mahsulot yo`q',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        50),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              IconButton(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: const Color.fromRGBO(217, 217, 217, 100),
                onPressed: () {
                  _productList.clear();
                  products.clear();
                  setState(() {
                    _isLoad = true;
                  });
                  _getProductsByCategory();
                },
                icon: const Icon(
                  Icons.refresh,
                  size: 30,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Text("Jami: ${_productList.length}",
                  style: const TextStyle(fontSize: 20, color: Colors.black)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              if (_isLoad)
                const CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
        ],
      ),
    );
  }

  void _searchProduct(String value) {
    if (value.isEmpty) {
      setState(() {
        products = _productList;
      });
    } else {
      //search name price
      setState(() {
        products = _productList
            .where((element) =>
                element.productName
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                element.productPrice
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase()))
            .toList();
      });
    }
  }
}
