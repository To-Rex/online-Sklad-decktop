import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:online_sklad/admin/tarnsaktion_page.dart';

import 'package:online_sklad/models/user_list.dart';import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {

  late final _userNameController = TextEditingController();
  late final _nameController = TextEditingController();
  late final _surNameController = TextEditingController();
  late final _phoneController = TextEditingController();
  late final _passwordController = TextEditingController();


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

  var userList = [];
  var users = [];



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

  Future<void> _getUsers() async {
    var url = Uri.parse('https://golalang-online-sklad-production.up.railway.app/getAllUser');
    var response = await http.get(url);
    final data = jsonDecode(response.body);
    if (data['status'] == 'success' && data['message'] == null) {
      print('data is null');
      return;
    }

    if (data['status'] == 'success' && data['message'] != null) {
      for (var i = 0; i < data['message'].length; i++) {
        userList.add(UserList(
          userName: data['message'][i]['username'],
          name: data['message'][i]['name'],
          surName: data['message'][i]['surname'],
          phone: data['message'][i]['phone'],
          country: data['message'][i]['country'],
          password: data['message'][i]['password'],
          registerDate: data['message'][i]['register_date'],
          blocked: data['message'][i]['blocked'],
          userId: data['message'][i]['user_id'],
          userStatus: data['message'][i]['user_status'],
          userRole: data['message'][i]['user_role'],
        ));
      }
      setState(() {
        users = userList;
      });
      return;
    }
  }

  Future<void> _addUser() async{
    final response = await http.post(
      Uri.parse('https://golalang-online-sklad-production.up.railway.app/register'),
      body: jsonEncode(<Object, Object>{
        'username': _userNameController.text,
        'name': _nameController.text,
        'surname': _surNameController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
      }),
    );
    final data = jsonDecode(response.body);
    print(data);
    print(response.statusCode);
    if(response.statusCode == 200){
      if (data['status'] == 'success' && data['message'] == 'User created') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User created'),
            backgroundColor: Colors.green,
          ),
        );
        return;
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not created'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not created'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
  }

  Future<void> _deleteUser(String userId) async {
    //https://golalang-online-sklad-production.up.railway.app/deleteUser?userid=JquoRovTlsWSZKqxUPbvu4gEfNH0XcAL
    var url = Uri.parse('https://golalang-online-sklad-production.up.railway.app/deleteUser?userid=$userId');
    var response = await http.delete(url);
    final data = jsonDecode(response.body);
    if(response.statusCode == 200){
      if (data['status'] == 'success' && data['message'] == null) {
        print('data is null');
        return;
      }

      if (data['status'] == 'success' && data['message'] != null) {
        print('data is not null');
        setState(() {
          _getUsers();
        });
        return;
      }

      if (data['status'] == 'error' && data['message'] != null) {
        print('data is not null');
        return;
      }
    }else{
      print('error');
    }
  }

  void _showDeleteDialog(String userId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('O`chirish'),
            content: const Text('Bu foydalanuvchini o`chirishni istaysizmi?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Yo`q'),
              ),
              TextButton(
                onPressed: () {
                  print(userId);
                  _deleteUser(userId);
                  Navigator.of(context).pop();
                },
                child: const Text('Ha'),
              ),
            ],
          );
        });
  }

  void showAddUserDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Yangi foydalanuvchi qo`shish'),
            content: Container(
              height: 400,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                  ),
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
                      controller: _userNameController,
                      textAlign: TextAlign.left,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'Foydalanuvchi nomi',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
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
                      controller: _nameController,
                      textAlign: TextAlign.left,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'Ism',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
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
                      controller: _surNameController,
                      textAlign: TextAlign.left,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'Familiya',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
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
                      controller: _phoneController,
                      textAlign: TextAlign.left,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'Telefon raqami',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
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
                      controller: _passwordController,
                      textAlign: TextAlign.left,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                        border: InputBorder.none,
                        hintText: 'Parol',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Bekor qilish'),
              ),
              TextButton(
                onPressed: () {
                  if (_userNameController.text.isEmpty ||
                      _nameController.text.isEmpty ||
                      _surNameController.text.isEmpty ||
                      _phoneController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Barcha maydonlarni to`ldiring'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  _addUser();
                  Navigator.of(context).pop();
                },
                child: const Text('Saqlash'),
              ),
            ],
          );
        });
  }



  void _searchProduct(String value) {
    if (value.isEmpty) {
      setState(() {
        users = userList;
      });
    } else {
      //search name price
      setState(() {
        users = userList
            .where((element) =>
                element.userName.toLowerCase().contains(value.toLowerCase()) ||
                element.name
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void initState() {
    _getUser();
    _getUsers();
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
              const Expanded(
                child: SizedBox(),
              ),
              //iconbutton
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
              if (userRole == 'creator')
                SizedBox(
                  width: MediaQuery.of(context).size.width / 50,
                ),
              if (userRole == 'creator')
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransaktionsPage(),
                          ),
                        );
                      },
                      icon: SvgPicture.asset(
                        'assets/userStatic.svg',
                        color: Colors.deepPurpleAccent,
                        height: 25,
                        width: 25,
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
                      showAddUserDialog();
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.deepPurpleAccent,
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
                for (var i = 0; i < users.length; i++)
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
                                      'assets/userIcon.svg',
                                      color: Colors.deepPurpleAccent,
                                      height: 60,
                                      width: 60,
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
                                          users[i].name,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          users[i].phone,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          users[i].userName,
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
                                      users[i].userRole,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.009,
                                  ),
                                  if (users[i].userRole == 'user'||users[i].userRole == "admin"&&userRole=='creator')
                                  IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                        'assets/userPermission.svg',
                                        color: Colors.deepPurpleAccent,
                                        height: 25,
                                        width: 25,
                                      )),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.005,
                                  ),
                                  if (users[i].userRole == 'user'||users[i].userRole == "admin"&&userRole=='creator')
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
                                    width: MediaQuery.of(context).size.width *
                                        0.005,
                                  ),
                                  if (users[i].userRole == 'user'||users[i].userRole == "admin"&&userRole=='creator')
                                    IconButton(
                                      onPressed: () {
                                        _showDeleteDialog(users[i].userId);
                                      },
                                      icon: SvgPicture.asset(
                                        'assets/deleteIcon.svg',
                                        height: 25,
                                        width: 25,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                    ),

                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.005,
                                  ),
                                  if (users[i].userRole == 'user'||users[i].userRole == "admin"&&userRole=='creator')
                                  IconButton(
                                    onPressed: () {},
                                    icon: SvgPicture.asset(
                                      'assets/userBlock.svg',
                                      height: 25,
                                      width: 25,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.025,),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.02),
                            ],
                          ),
                        ),
                        if (users.isEmpty)
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
        ],
      ),
    );
  }

}
