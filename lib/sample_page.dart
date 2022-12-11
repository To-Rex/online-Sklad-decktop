import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage>
    with SingleTickerProviderStateMixin {
  late final _categoryNameController = TextEditingController();
  var category_name = [];
  var category_id = [];

  var userName = '';
  var userId = '';
  var userSurname = '';
  var userPhone = '';
  var userRole = '';
  var userStatus = '';
  var userBlocked = false;
  var userNames = '';

  Future<void> _getAllCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('userid') ?? '';
    prefs.getString('name') ?? '';
    prefs.getString('surname') ?? '';
    prefs.getString('phone') ?? '';
    prefs.getString('username') ?? '';
    prefs.getString('role') ?? '';
    prefs.getString('userstatus') ?? '';
    prefs.getString('registerdate') ?? '';
    prefs.getBool('blocked') ?? false;
    userName = prefs.getString('name') ?? '';
    userId = prefs.getString('userid') ?? '';
    userSurname = prefs.getString('surname') ?? '';
    userPhone = prefs.getString('phone') ?? '';
    userRole = prefs.getString('role') ?? '';
    userStatus = prefs.getString('userstatus') ?? '';
    userBlocked = prefs.getBool('blocked') ?? false;
    userNames = prefs.getString('username') ?? '';

    final response = await http.get(Uri.parse(
        'https://golalang-online-sklad-production.up.railway.app/getAllCategory'));
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        for (var i = 0; i < data['data'].length; i++) {
          category_name.add(data['data'][i]['category_name']);
          category_id.add(data['data'][i]['category_id']);
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
      setState(() {});
    }
  }

  Future<void> _addCategory() async {
    final response = await http.post(
        Uri.parse(
            'https://golalang-online-sklad-production.up.railway.app/addCategory'),
        body: jsonEncode(<String, String>{
          'category_name': _categoryNameController.text,
          'category_icon': 'null',
        }));
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bo\'lim muvaffaqiyatli qo\'shildi'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 1700),
            behavior: SnackBarBehavior.floating,
          ),
        );
        category_name.clear();
        category_id.clear();
        _categoryNameController.clear();
        _getAllCategory();
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
      setState(() {});
    }
  }
  //https://golalang-online-sklad-production.up.railway.app/deleteCategory?categoryId=3eW1hacUxP8yyODQfYHwXi96Y1Cp7p3g
  Future<void> _deleteCategory(String id) async {
    final response = await http.delete(Uri.parse(
        'https://golalang-online-sklad-production.up.railway.app/deleteCategory?categoryId=$id'));
    print(response.body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bo\'lim muvaffaqiyatli o\'chirildi'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 1700),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
        category_name.clear();
        category_id.clear();
        _getAllCategory();
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
      setState(() {});
    }
  }


  Future<void> _showDialogAddCategory() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bo`lim qo`shish'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 221, 221, 221),
                      border: Border.all(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      cursorColor: Colors.deepPurpleAccent,
                      controller: _categoryNameController,
                      textAlign: TextAlign.left,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'bo`lim nomi',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('bekor qilish'),
              onPressed: () {
                Navigator.of(context).pop();
                _categoryNameController.clear();
              },
            ),
            TextButton(
              child: const Text('Qo`shish'),
              onPressed: () {
                if (_categoryNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bo`lim nomini kiriting'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      duration: Duration(milliseconds: 1700),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  _addCategory();
                  Navigator.of(context).pop();
                  _categoryNameController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteCategoryDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(category_name[index]),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Bo`limni o`chirmoqchimisiz?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('bekor qilish'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('O`chirish'),
              onPressed: () {
                _deleteCategory(category_id[index]);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getAllCategory();
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (category_name.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (category_name.isNotEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Row(
                  children: [
                    const Text(
                      'Hello, ',
                    ),
                    SizedBox(
                      //width: MediaQuery.of(context).size.width/5.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 221, 221, 221),
                          border: Border.all(
                              color: const Color.fromARGB(255, 221, 221, 221),
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$userName      ',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: const Color.fromRGBO(217, 217, 217, 100),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/userIcon.svg',
                    height: 25,
                    width: 25,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Expanded(
              child: GridView.builder(
                itemCount: category_name.length,
                padding: const EdgeInsets.all(70),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      //_showCategoryDialog(index);
                    },
                    child: Card(
                      elevation: 0.01,
                      color: const Color.fromRGBO(217, 217, 217, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const Expanded(child: SizedBox()),
                              IconButton(
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor:
                                    const Color.fromRGBO(217, 217, 217, 100),
                                onPressed: () {
                                  _showDeleteCategoryDialog(index);
                                },
                                icon: SvgPicture.asset(
                                  'assets/deleteIcon.svg',
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          Text(
                            category_name[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: const Color.fromRGBO(217, 217, 217, 100),
                  onPressed: () {
                    category_name.clear();
                    category_id.clear();
                    _getAllCategory();
                  },
                  icon: const Icon(
                    Icons.refresh,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(217, 217, 217, 100),
          onPressed: () {
            // Add your onPressed code here!
            _showDialogAddCategory();
          },
          child: const Icon(Icons.add, color: Colors.black),
        ),
      );
    } else {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
            elevation: 3,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
