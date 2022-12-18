import 'package:flutter/material.dart';

class TransaktionsPage extends StatefulWidget {
  const TransaktionsPage({super.key});

  @override
  _TransktionPageState createState() => _TransktionPageState();
}

class _TransktionPageState extends State<TransaktionsPage>  with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
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
        children: const [
          Text(''),
          //floating button default
        ],
      ),
    );
  }
}