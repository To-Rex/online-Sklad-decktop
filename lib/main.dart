import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_sklad/login_page.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions =  const WindowOptions(
    size: Size(1000, 700),
    center: true,
    backgroundColor: Colors.white,
    skipTaskbar: false,
    //titleBarStyle: TitleBarStyle.hidden,
    minimumSize: Size(1000, 700),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Work Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Work Manager Asosiy Sahifa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var text = 'Internetga ulanishni tekshirilmoqda ...';
  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Timer(const Duration(milliseconds: 2000), () {
          setState(() {
            text = 'Internetga muvaffaqiyatli ulandi';
          });
          //login page navigator push
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        });
        return true;
      }
    } on SocketException catch (_) {
      Timer(const Duration(milliseconds: 2000), () {
        setState(() {
          text = 'Internetga ulanishda xatolik yuz berdi';
        });
      });
      return false;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(child: SizedBox()),
            Text(text, style: const TextStyle(fontSize: 20)),
            const Expanded(child: SizedBox()),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                const Expanded(child: SizedBox()),
                const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                    backgroundColor: Colors.black12,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                const Text('  Kuting ...', style: TextStyle(fontSize: 20)),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }
}
