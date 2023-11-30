import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp/inventory/inventory_tab.dart';
import 'package:fyp/scrap services/scrap_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UploadScreen extends StatefulWidget {
  final String? category;

  const UploadScreen({super.key, this.category});
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _imageFile;
  final picker = ImagePicker();
  final _categories = [
    'Metal',
    'Electronics',
    'Plastic',
    'Glass',
    'Clothing',
    'Books',
    'Other',
    'E-Waste',
    'Papers',
    'Fabrics',
  ];

  String? category;
  String? _selectedCategory;

  String _selectedSubCategory = 'Phones';
  int _quantity = 1;
  double _price = 0.0;
  String? selectedWeightUnit; // Default weight unit
  String selectedQuantityUnit = 'item'; // Default quantity unit

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String? username;
  int? userid;
  String? email;
  String? city;
  Future<void> newvalues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt('userId');
    username = prefs.getString('username');
    email = prefs.getString('email');
    city = prefs.getString('city');
  }

  List<File> _imageFiles = <File>[];

  Future<void> _getImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _imageFiles =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  Future<void> _postAd() async {
    print('User data $userid,$username,$email');

    final apiUrl = Uri.parse('http://10.0.2.2:8000/additem');

    final request = http.MultipartRequest('POST', apiUrl);

    if (_imageFiles.isNotEmpty) {
      for (File imageFile in _imageFiles) {
        final image = await http.MultipartFile.fromPath(
          'images[]', // Use an array to upload multiple images
          imageFile.path,
        );
        request.files.add(image);
      }
    }

    request.fields['category'] = _selectedCategory!;
    request.fields['title'] = titleController.text;
    request.fields['quantity'] = quantityController.text;
    request.fields['price'] = priceController.text;
    request.fields['description'] = descriptionController.text;
    request.fields['location'] = locationController.text;
    request.fields['user'] = userid.toString();
    request.fields['unit'] = selectedWeightUnit!;
    request.fields['city'] = city!;

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        final responseString = await response.stream.bytesToString();
        final responseData = json.decode(responseString);
        Fluttertoast.showToast(
            msg: "Item Added Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0,
            backgroundColor: Colors.green);

        // Clear the text fields
        titleController.clear();
        quantityController.clear();
        priceController.clear();
        descriptionController.clear();
        locationController.clear();

        // Close the dialog
        Navigator.pop(context);

        // Navigate to the InventoryTab
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const InventoryTab()));
      } else {
        print('Request failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }

  @override
  void initState() {
    _selectedCategory = widget.category.toString();
    print("object $_selectedCategory");
    super.initState();
    _postAd();
    newvalues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // No shadow
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
          'Add Ads',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.06,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: _getImages,
                child: Container(
                    height: 160.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 214, 150, 150),
                        width: 1.0,
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/upload.png',
                      width: 200,
                      height: 200,
                    )),
              ),
              const SizedBox(height: 16.0),
              Visibility(
                visible: _imageFiles.length > 0,
                child: SizedBox(
                  height: 100,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                    itemCount: _imageFiles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(
                        _imageFiles[index],
                        width: 150, // Set a fixed width for the image
                        height: 150, // Set a fixed height for the image
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map(
                      (category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Ad Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: quantityController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: const OutlineInputBorder(),
                      suffixIcon: DropdownButton(
                        value: selectedWeightUnit,
                        items: const [
                          DropdownMenuItem(
                            value: 'gm',
                            child: Text('gram'),
                          ),
                          DropdownMenuItem(
                            value: 'g',
                            child: Text('Item'),
                          ),
                          DropdownMenuItem(
                            value: 'kg',
                            child: Text('Kg'),
                          ),
                        ],
                        onChanged: (value) {
                          // Handle weight unit selection
                          setState(() {
                            selectedWeightUnit = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3, // Adjust the number of lines as needed
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 180,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.1,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Debris_services()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 180,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.1,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmation'),
                              content: const Text('Do you want to post ads?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Post'),
                                  onPressed: () {
                                    _postAd();

                                    // Perform the post action here
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => InventoryTab()),
                                    // );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Post',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
