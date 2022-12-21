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
  var minWeight = '';
  var maxWeight = '';
  var minHeight = '';
  var maxHeight = '';

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
      for (var i = 0; i < data['data'].length; i++) {
        transaktionList.add(TransaktionList(
            transactionId: data['data'][i]['transactionId'],
            transactionDate: data['data'][i]['transactionDate'],
            transactionSeller: data['data'][i]['transactionSeller'],
            transactionProduct: data['data'][i]['transactionProduct'],
            transactionNumber: data['data'][i]['transactionNumber'],
            transactionPrice: data['data'][i]['transactionPrice'],
            transactionStatus: data['data'][i]['transactionStatus'],
            transactionBenefit: data['data'][i]['transactionBenefit'],
        ));
      }
    }else{
      SnackBar snackBar = const SnackBar(content: Text('Internet bilan aloqa yo\'q'));
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
              //iconbutton
              SizedBox(
                height: 30,
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 4,
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 50,
              ),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.05,
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
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.8,
                            MediaQuery
                                .of(context)
                                .size
                                .height * 0.1, 0, 0),
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
        children: const [
          Text(''),
          //floating button default
        ],
      ),
    );
  }
}

mixin Menu {
  String get name;
}