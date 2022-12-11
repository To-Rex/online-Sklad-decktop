
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  var category_id;
  var category_name;
  ProductPage({super.key, this.category_id, this.category_name});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with SingleTickerProviderStateMixin {


 // https://golalang-online-sklad-production.up.railway.app/getProductsByCategory?categoryId=iYVt395gIGixhDlAmW9OYbCFcs0C2lBe
  Future<void> _getProductsByCategory() async {
    var catId = widget.category_id;
    final response = await http.get(
      Uri.parse('https://golalang-online-sklad-production.up.railway.app/getProductsByCategory?categoryId=$catId'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    _getProductsByCategory();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(10), // here the desired height
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
