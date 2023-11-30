import 'package:flutter/material.dart';
import 'package:fyp/scrap services/scrap_upload.dart';
import 'package:fyp/inventory/inventory_tab.dart';
import 'package:fyp/model/feature/product_model.dart';
import 'package:fyp/notification/notification.dart';
import 'package:fyp/scrap%20services/scrap_item_details.dart';
import 'package:fyp/ui/reusable/cache_image_network.dart';
import 'package:fyp/ui/reusable/global_function.dart';
import 'package:fyp/ui/reusable/global_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DestinationPage extends StatefulWidget {
  final String? data;
  final String? city;

  const DestinationPage({Key? key, required this.data, this.city})
      : super(key: key);

  @override
  _DestinationPageState createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  // initialize global widget
  final _globalWidget = GlobalWidget();
  final _globalFunction = GlobalFunction();

  Color _color1 = Color(0xFF515151);
  Color _color2 = Color(0xFFaaaaaa);

  @override
  void initState() {
    print("object is ${widget.data}");

    getItemDetails();
    setState(() {});
    super.initState();
  }

  List<Map<String, dynamic>> items = [];

  Future<void> getItemDetails() async {
    final url = Uri.parse('http://10.0.2.2:8000/get-item-details');

    try {
      final response = await http.post(
        url,
        body: {'title': widget.data, 'city': widget.city},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Check if 'items' key exists in the response
        if (data.containsKey('items')) {
          final List<dynamic> itemsData = data['items'];

          setState(() {
            items = List<Map<String, dynamic>>.from(itemsData);
          });

          print('Item details: $items');
        } else {
          print('Items not found.');
        }
      } else {
        print(
            'Failed to get item details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0, // No shadow
          backgroundColor: Colors.green,
          flexibleSpace: Container(
            decoration: BoxDecoration(
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
            'Recycle Now',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.06,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _globalWidget.createDetailWidget(
                  title: 'Search Product', desc: ''),
              _buildProducts(),
            ],
          ),
        ));
  }

  Widget _buildProducts() {
    final double boxImageSize = (MediaQuery.of(context).size.width / 4);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> currentItem = items[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetails(productId: currentItem['id']),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  child: buildCacheNetworkImage(
                    width: boxImageSize,
                    height: boxImageSize,
                    url: currentItem['image'] != null
                        ? 'http://10.0.2.2:8000${currentItem['image'][0]}'
                        : '',
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${currentItem['title']}' ??
                            'Title Not Available',
                        style: TextStyle(fontSize: 13, color: _color1),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          'Price: ${currentItem['price']}' ??
                              'Price Not Available',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: _color2, size: 12),
                            Text(
                              'Location: ${currentItem['location']}' ??
                                  'Location Not Available',
                              style: TextStyle(fontSize: 11, color: _color2),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          'Status: ${currentItem['status']}' ??
                              'Status Not Available',
                          style: TextStyle(fontSize: 11, color: _color1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
