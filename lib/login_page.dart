import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_sklad/sample_page.dart';
import 'package:online_sklad/user/sample_page_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final _emailController = TextEditingController();
  late final _passwordController = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _isLoading = false;

  var usersLiest = ["",""];

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

  Future<void> _login() async {
    checkInternetConnection().then((value) {
      if (!value) {
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
        _isLoading = false;
        return;
      } else {
        //_isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connected'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 1700),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final response = await http.post(
      Uri.parse(
          'https://golalang-online-sklad-production.up.railway.app/login'),
      body: jsonEncode(<String, String>{
        'username': _emailController.text,
        'password': _passwordController.text,
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      _isLoading = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = jsonDecode(response.body);
      if (data['message'] == 'User not found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 1700),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
        _isLoading = false;
        setState(() {});
        return;
      }
      if (data['message'] == 'Wrong password') {
        _isLoading = false;
        _passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 1700),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
        setState(() {});
        return;
      }
      prefs.setString('name', data['name']);
      prefs.setString('surname', data['surname']);
      prefs.setString('phone', data['phone']);
      prefs.setString('username', data['username']);
      prefs.setString('userid', data['userid']);
      prefs.setString('role', data['role']);
      prefs.setString('userstatus', data['userstatus']);
      prefs.setString('registerdate', data['registerdate']);
      prefs.setBool('blocked', data['blocked']);
      _isLoading = false;
      setState(() {});
      if (data['role'] == 'admin' || data['role'] == 'creator') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SamplePage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SamplePageUser(),
          ),
        );
      }
    } else {
      _isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Iltimos login yoki parolni tekshiring'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(milliseconds: 1700),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {});
    }
  }

  Future<void> _getUsers() async {
    final response = await http.get(
      Uri.parse(
          'https://golalang-online-sklad-production.up.railway.app/getAllUser'),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var i = 0; i < data['message'].length; i++) {
        usersLiest.add(''+data['message'][i]['username'].toString());
      }
    } else {
      print('error');
    }
    print(usersLiest);
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
    checkInternetConnection().then((value) {
      if (!value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Not Connected'),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // here the desired height
        child: AppBar(
          backgroundColor: const Color.fromRGBO(33, 158, 188, 10),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.06,
              ),
              Column(
                children: [
                  if(usersLiest.isNotEmpty)
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
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }
                          return usersLiest.where((String option) {
                            return option
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (String selection) {
                          _emailController.text = selection;
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextFormField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            onFieldSubmitted: (String value) {
                              onFieldSubmitted();
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10, right: 10),
                              border: InputBorder.none,
                              hintText: 'Username',
                              errorText: _validateEmail ? 'Pochta kiriting' : null,
                            ),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                              fontFamily: 'Roboto',
                            ),
                            keyboardType: TextInputType.text,
                          );
                        },
                        optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              elevation: 4.0,
                              borderOnForeground: true,
                              borderRadius: BorderRadius.circular(10),
                              animationDuration: const Duration(milliseconds: 100),
                              child: SizedBox(
                                height: 150,
                                width: MediaQuery.of(context).size.width / 2.7,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(8.0),
                                  itemCount: options.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final String option = options.elementAt(index);
                                    return GestureDetector(
                                      onTap: () {
                                        onSelected(option);
                                      },
                                      child: ListTile(
                                        title: Text(option),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if(usersLiest.isEmpty)
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
                          controller: _emailController,
                          textAlign: TextAlign.left,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10, right: 10),
                            border: InputBorder.none,
                            hintText: 'Username',
                            errorText: _validateEmail ? 'Pochta kiriting' : null,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
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
                        controller: _passwordController,
                        textAlign: TextAlign.left,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(left: 10, right: 10),
                          border: InputBorder.none,
                          hintText: 'Parol',
                          errorText:
                              _validatePassword ? 'Parol kiriting' : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width / 7.5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(33, 158, 188, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_emailController.text.isEmpty) {
                      setState(() {
                        _validateEmail = true;
                      });
                    } else if (_passwordController.text.isEmpty) {
                      setState(() {
                        _validatePassword = true;
                      });
                    } else {
                      setState(() {
                        _validateEmail = false;
                        _validatePassword = false;
                      });
                      _isLoading = true;
                      _login();
                    }
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('Kirish'),
                      const Expanded(child: SizedBox()),
                      //SizedBox(width: MediaQuery.of(context).size.width*0.01,),
                      if (_isLoading)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.height * 0.03,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      if (!_isLoading) const Icon(Icons.arrow_forward),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.06,
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
        ],
      ),
    );
  }
}
