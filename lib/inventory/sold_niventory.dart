import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class SoldProduct extends StatefulWidget {
  const SoldProduct({super.key});

  @override
  State<SoldProduct> createState() => _SoldProductState();
}

class _SoldProductState extends State<SoldProduct> {
  String _formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String formattedDate = DateFormat('MM/dd/yyyy').format(date);
    return formattedDate;
  }

  Map<String, dynamic> inventoryData = {};
  String? username;
  int? userid;
  String? email;

  @override
  void initState() {
    super.initState();
    initValues();
  }

  Future<void> initValues() async {
    await newvalues(); // Await this function to ensure userid is initialized
    fetchData();
  }

  Future<void> newvalues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt('userId');
    username = prefs.getString('username');
    email = prefs.getString('email');
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://10.0.2.2:8000/getsolditem');

    final Map<String, dynamic> requestBody = {
      'userid': userid,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      print(response.body);
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        inventoryData = data;
      });
    } else if (response.statusCode == 404) {
      throw Exception("Item does not exist");
    } else {
      throw Exception("Failed to fetch data: ${response.statusCode}");
    }
  }

  Future<void> deleteAdd(int productid) async {
    final url = Uri.parse('http://10.0.2.2:8000/deleteitem');

    final Map<String, dynamic> requestBody = {
      'userid': userid,
      'productid': productid,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      print(response.body);
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        inventoryData = data;
      });
    } else if (response.statusCode == 404) {
      throw Exception("Item does not exist");
    } else {
      throw Exception("Failed to delete item: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (inventoryData == null ||
        inventoryData.isEmpty ||
        inventoryData['data'] == null) {
      setState(() {
        fetchData();
      });
      return const Center(
        child: Text('No items found.'),
      );
    } else {
      return Container(
        alignment: Alignment.topCenter,
        child: ListView.builder(
          itemCount: inventoryData['data'].length,
          itemBuilder: (context, index) {
            final item = inventoryData['data'][index];
            return Card(
              elevation: 5,
              child: SizedBox(
                height: 100.0,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 100.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'http://10.0.2.2:8000/' + item['images'][0]),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        height: 150,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  // Text(
                                  //   'Name: ',
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Quantity:',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    item['quantity'].toString() +
                                        ' ' +
                                        item['unit'].toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  // const Text(
                                  //   'Price: ',
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  Text(
                                    'Rs ${item['price']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  // Text(
                                  //   'Description: ',
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  Text(
                                    _formatDate(item['date']),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmation'),
                                  content: const Text(
                                      'Do you want to delete the ad?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        deleteAdd(item['id']);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
