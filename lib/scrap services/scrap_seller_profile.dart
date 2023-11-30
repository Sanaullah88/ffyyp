import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp/scrap%20services/scrap_item_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class ScrapContactUsPage extends StatefulWidget {
  final int userid;

  const ScrapContactUsPage({Key? key, required this.userid}) : super(key: key);

  @override
  State<ScrapContactUsPage> createState() => _ScrapContactUsPageState();
}

class _ScrapContactUsPageState extends State<ScrapContactUsPage> {
  Map<String, dynamic> userData = {};
  Color _color1 = Color.fromARGB(255, 17, 167, 67);
  Color _color2 = Color(0xFF333333);
  Color _color3 = Color(0xFF666666);
  Map<String, dynamic> inventoryData = {}; // Updated to a Map

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchAdd();
  }

  Future<void> fetchAdd() async {
    final url = Uri.parse('http://10.0.2.2:8000/getitem');

    final Map<String, dynamic> requestBody = {
      'userid': widget.userid,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      print("responsebody${response.body}");
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

  Future<void> fetchData() async {
    final url = Uri.parse('http://10.0.2.2:8000/getsingleuser');

    final Map<String, dynamic> requestBody = {
      'id': widget.userid,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        userData = data;
      });
    } else if (response.statusCode == 404) {
      throw Exception("Item does not exist");
    } else {
      throw Exception("Failed to fetch data: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF00AA5E),
                Colors.teal,
              ],
            ),
          ),
        ),
        title: Text(
          'User Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.06,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  userData != null && userData['data'] != null
                      ? 'http://10.0.2.2:8000/' +
                          (userData['data']['image'] ?? 'defaultImageURL')
                      : 'https://www.shutterstock.com/image-vector/img-vector-icon-design-on-260nw-2164648583.jpg',
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.account_circle_outlined,
                      size: 70,
                    );
                  },
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData != null && userData['data'] != null
                        ? userData['data']['username']
                        : '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _color2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    userData != null && userData['data'] != null
                        ? userData['data']['phone_number']
                        : '',
                    style: TextStyle(
                      color: _color3,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              'Published Ads:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _color2,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          // Replace the GridView.builder with your actual implementation
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: (inventoryData != null
                ? inventoryData!['data']?.length ?? 0
                : 0),
            itemBuilder: (context, rowIndex) {
              final int index1 = rowIndex * 2;
              final int index2 = index1 + 1;

              if (inventoryData != null &&
                  inventoryData!['data'] != null &&
                  inventoryData!['data']!.isNotEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: index1 < inventoryData!['data']!.length
                          ? _buildProductCard(index1)
                          : Container(),
                    ),
                    if (index2 < inventoryData!['data']!.length)
                      Expanded(
                        child: _buildProductCard(index2),
                      ),
                  ],
                );
              } else {
                return const Center(
                  child: Text("No Data Found"),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(int index) {
    final product = inventoryData['data']![index];
    print("object is${product['title']}");
    bool isActive = true;
    return SizedBox(
      width: 250,
      height: 250,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetails(productId: product['id']),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  'http://10.0.2.2:8000/${product['images'][0]}',
                  height: 150, // Set the image height
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['title'].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs ' + product['price'].toString(),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        // Icon(
                        //   Icons.circle,
                        //   color: isActive ? Colors.green : Colors.grey,
                        //   size: 12,
                        // ),
                        // Text(

                        //   product..toString(),
                        //   style: TextStyle(
                        //     fontSize: 11,
                        //     color: Colors.grey,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 12,
                        ),
                        Text(
                          product['location'].toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          product['date'].toString(),
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
