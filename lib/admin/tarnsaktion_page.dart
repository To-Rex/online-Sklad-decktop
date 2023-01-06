import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:http/http.dart' as http;
import 'package:online_sklad/models/transaktions_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransaktionsPage extends StatefulWidget {
  const TransaktionsPage({super.key});

  @override
  _TransktionPageState createState() => _TransktionPageState();
}

class _TransktionPageState extends State<TransaktionsPage>
    with SingleTickerProviderStateMixin {
  var userName = '';
  var userId = '';
  var userSurname = '';
  var userPhone = '';
  var userRole = '';
  var userStatus = '';
  var userBlocked = false;
  var userNames = '';

  var benefit = 0;
  var price = 0;

  var _selectedMenu = 1;
  var transaktionList = [];
  var listTransaktion = [];

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

  Future<void> getSellTransaction() async {
    final response = await http.get(Uri.parse(
        'https://golalang-online-sklad-production.up.railway.app/getSellTransaction?months=${_selectedMenu}'));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 ||
        response.statusCode == 201 && data['status'] == 'success') {
      print(data);
      benefit = data['benefit'];
      price = data['price'];
      for (var i = 0; i < data['data'].length; i++) {
        transaktionList.add(TransaktionList(
          transactionId: data['data'][i]['transaction_id'],
          transactionDate: data['data'][i]['transaction_date'],
          transactionSeller: data['data'][i]['transaction_seller'],
          transactionProductName: data['data'][i]['transaction_product_name'],
          transactionProduct: data['data'][i]['transaction_product'],
          transactionNumber: data['data'][i]['transaction_number'],
          transactionPrice: data['data'][i]['transaction_price'],
          transactionStatus: data['data'][i]['transaction_status'],
          transactionBenefit: data['data'][i]['transaction_benefit'],
        ));
      }
      setState(() {
        listTransaktion = transaktionList;
      });
    } else {
      SnackBar snackBar =
          const SnackBar(content: Text('Internet bilan aloqa yo\'q'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    _getUser();
    getSellTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.4,
          actionsIconTheme: const IconThemeData(color: Colors.black),
          iconTheme: const IconThemeData(color: Colors.black),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: SizedBox(),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  IconButton(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.white,
                    color: Colors.white,
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/sendIcon.svg',
                      height: 22,
                      width: 22,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  Text(
                    //price.toString(),
                    '${price.toString()} so\'m',
                    style: const TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  IconButton(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.white,
                    color: Colors.white,
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/getIcon.svg',
                      height: 22,
                      width: 22,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    '$benefit so\'m',
                    style: const TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
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
                        _searchTransaktion(value);
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 221, 221, 221),
                    border: Border.all(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.white,
                    color: Colors.white,
                    onPressed: () {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                            MediaQuery.of(context).size.width * 0.8,
                            MediaQuery.of(context).size.height * 0.1,
                            0,
                            0),
                        items: [
                          const PopupMenuItem(
                            value: '1',
                            child: Text('1 oylik'),
                          ),
                          const PopupMenuItem(
                            value: '2',
                            child: Text('2 oylik'),
                          ),
                          const PopupMenuItem(
                            value: '3',
                            child: Text('3 oylik'),
                          ),
                        ],
                      ).then((value) {
                        setState(() {
                          _selectedMenu = int.parse(value.toString());
                          print(_selectedMenu);
                        });
                      });
                    },
                    icon: SvgPicture.asset(
                      'assets/sort.svg',
                      color: Colors.deepPurpleAccent,
                      height: 60,
                      width: 60,
                    ),
                  ),
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
                for (var i = 0; i < listTransaktion.length; i++)
                  GestureDetector(
                    onTap: () {},
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
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  if (listTransaktion[i].transactionStatus ==
                                      'added')
                                    SvgPicture.asset(
                                      'assets/sendIcon.svg',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.05,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  if (listTransaktion[i].transactionStatus ==
                                      'sold')
                                    SvgPicture.asset(
                                      'assets/getIcon.svg',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      color: Colors.red,
                                    ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        listTransaktion[i]
                                            .transactionProductName,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 221, 221, 221),
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 221, 221, 221),
                                              width: 5),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          '  ${listTransaktion[i].transactionNumber} Dona  ',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      if (listTransaktion[i]
                                              .transactionStatus ==
                                          'added')
                                        Text(
                                          '${listTransaktion[i].transactionPrice + listTransaktion[i].transactionBenefit} so\'m',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      if (listTransaktion[i]
                                              .transactionStatus ==
                                          'sold')
                                        Text(
                                          '${listTransaktion[i].transactionPrice + listTransaktion[i].transactionBenefit} so\'m',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  //tan narxi
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tan narx: ${listTransaktion[i].transactionPrice} so\'m',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width * 0.05,
                                        height: MediaQuery.of(context).size.height * 0.01,
                                      ),
                                      Text(
                                        'Foyda: ${listTransaktion[i].transactionBenefit} so\'m',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),

                                  Text(
                                    listTransaktion[i].transactionDate,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
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

  void _searchTransaktion(String value) {
    if (value.isEmpty) {
      setState(() {
        listTransaktion = transaktionList;
      });
    } else {
      setState(() {
        listTransaktion = transaktionList
            .where((element) =>
                element.transactionProductName
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                element.transactionDate
                    .toLowerCase()
                    .contains(value.toLowerCase()))
            .toList();
      });
    }
  }
}

mixin Menu {
  String get name;
}
