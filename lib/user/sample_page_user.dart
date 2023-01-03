import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:online_sklad/admin/product_page.dart';
import 'package:online_sklad/admin/tarnsaktion_page.dart';
import 'package:online_sklad/admin/user_page.dart';
import 'package:online_sklad/user/product_page.dart';
import 'package:online_sklad/user/user_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SamplePageUser extends StatefulWidget {
  const SamplePageUser({super.key});

  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePageUser>
    with SingleTickerProviderStateMixin {
  late final _categoryNameController = TextEditingController();
  var category_name = [];
  var category_id = [];

  var isLoading = false;

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
        category_name.clear();
        category_id.clear();
        isLoading = false;
        for (var i = 0; i < data['data'].length; i++) {
          category_name.add(data['data'][i]['category_name']);
          category_id.add(data['data'][i]['category_id']);
        }
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
                        builder: (context) => const TransaktionsPage(),
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    'assets/userStatic.svg',
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
                            builder: (context) => ProductPageUser(
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: const Color.fromRGBO(217, 217, 217, 100),
                  onPressed: () {
                    isLoading = true;
                    setState(() {
                    });
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
                  const CircularProgressIndicator(
                    color: Colors.deepPurpleAccent,
                  ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
          ],
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
