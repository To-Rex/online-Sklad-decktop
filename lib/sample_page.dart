import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:online_sklad/admin/product_page.dart';
import 'package:online_sklad/admin/user_page.dart';
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
  var minWeight = '';
  var maxWeight = '';
  var minHeight = '';
  var maxHeight = '';
  var isLoading = true;

  Future<void> _getAllCategory() async {
    isLoading = true;
    setState(() {});
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
    if (response.statusCode == 200) {
      category_name.clear();
      category_id.clear();
      _categoryNameController.clear();
      final data = jsonDecode(response.body);
      if (data['data'] == null) {
        isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bo\'limlar mavjud emas'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
            action: SnackBarAction(
              label: 'Tushunarli',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              disabledTextColor: Colors.white,
              textColor: Colors.white,
            ),
          ),
        );
        return;
      }

      if (data['status'] == 'success') {
        isLoading = false;
        for (var i = 0; i < data['data'].length; i++) {
          category_name.add(data['data'][i]['category_name']);
          category_id.add(data['data'][i]['category_id']);
        }
      } else {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Internet bilan bog\'lanishni tekshiring'),
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
    if (response.statusCode == 200) {
      isLoading = false;
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bo\'lim muvaffaqiyatli qo\'shildi'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 1700),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _getAllCategory();
      } else {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nimadir xatolik ketdi'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 1700),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      setState(() {});
    } else {
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Internet bilan bog\'lanishni tekshiring'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(milliseconds: 1700),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _deleteCategory(String id) async {
    final response = await http.delete(Uri.parse(
        'https://golalang-online-sklad-production.up.railway.app/deleteCategory?categoryId=$id'));
    if (response.statusCode == 200) {
      isLoading = false;
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
        _getAllCategory();
      } else {
        isLoading = false;
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
                  isLoading = true;
                  setState(() {});
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
                isLoading = true;
                setState(() {});
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50), // here the desired height
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.4,
          automaticallyImplyLeading: false,
          actionsIconTheme: const IconThemeData(color: Colors.black),
          iconTheme: const IconThemeData(color: Colors.black),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Bo`limlar",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              const Expanded(
                child: SizedBox(),
              ),
              Text("Salom, $userName",
                  style: const TextStyle(fontSize: 18, color: Colors.black)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.009,
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
                      builder: (context) => const UserPage(),
                    ),
                  );
                },
                icon: SvgPicture.asset(
                  'assets/userIcon.svg',
                  height: 30,
                  width: 30,
                  color: Colors.deepPurpleAccent,
                  //color: Colors.black,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.005,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (category_name.isNotEmpty)
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(
                            category_id: category_id[index],
                            category_name: category_name[index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
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
                                  color: Colors.deepPurpleAccent,
                                  width:
                                      MediaQuery.of(context).size.width * 0.025,
                                  height: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                              ),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          AutoSizeText(
                            category_name[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.015,
                              fontWeight: FontWeight.bold,
                            ),
                            minFontSize: 10,
                            maxFontSize: 20,
                            maxLines: 2,
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
          if (category_name.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "Bo`limlar mavjud emas",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                  isLoading = true;
                  setState(() {});
                  _getAllCategory();
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
              Text("Jami: ${category_name.length}",
                  style: const TextStyle(fontSize: 20, color: Colors.black)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              if (isLoading)
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.deepPurpleAccent,
                    ),
                  ),
                )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          _showDialogAddCategory();
        },
        child: const Icon(Icons.add, color: Colors.deepPurpleAccent),
      ),
    );
  }
}
