import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fyp/Api/MyAdds.dart';
import 'package:fyp/buyer/auth/login.dart';
import 'package:fyp/destination.dart';
import 'package:fyp/inventory/inventory_tab.dart';
import 'package:fyp/model/feature/MyAdds.dart';
import 'package:fyp/notification/notification.dart';
import 'package:fyp/scrap%20services/scrap_item_details.dart';
import 'package:fyp/setting.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fyp/config/constant.dart';
import 'package:fyp/user profile/user_profile.dart';
import 'package:fyp/scrap services/scrap_services.dart';
import 'package:fyp/model/feature/banner_slider_model.dart';
import 'package:fyp/pickup services/pickup_category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

const tDefaultSize = 30.0;
const tProfile = 'Profile';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum NavItem { home, notifications, messages, profile }

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? inventoryData;
  AllAds? allads;
  List<Data>? mydata;
  AdsApi adsapi = new AdsApi();

  Future<void> fetchAds() async {
    final data = await adsapi.fetchads(city!);
    print("data is ${data}");
    if (data != null) {
      setState(() {
        allads = data;
        mydata = data.data;
        print(mydata);
      });
    }
  }

  int _currentImageSlider = 0;

  int _currentIndex = 0;

  @override
  void initState() {
    newvalues();
    setState(() {
      newvalues();
    });
    _bannerData.add(
      BannerSliderModel(id: 5, image: GLOBAL_URL + '/images/home_banner/5.jpg'),
    );
    _bannerData.add(
      BannerSliderModel(id: 4, image: GLOBAL_URL + '/home_banner/4.jpg'),
    );
    _bannerData.add(
      BannerSliderModel(
          id: 1, image: GLOBAL_URL + '/images/home_banner/recycle.png'),
    );
    _bannerData.add(
      BannerSliderModel(id: 2, image: GLOBAL_URL + '/home_banner/2.jpg'),
    );
    _bannerData.add(
      BannerSliderModel(id: 3, image: GLOBAL_URL + '/home_banner/3.jpg'),
    );
  }

  List<String> cities = [
    "Islamabad",
    "Ahmed Nager",
    "Ahmadpur East",
    "Ali Khan",
    "Alipur",
    "Arifwala",
    "Attock",
    "Bhera",
    "Bhalwal",
    "Bahawalnagar",
    "Bahawalpur",
    "Bhakkar",
    "Burewala",
    "Chillianwala",
    "Chakwal",
    "Chichawatni",
    "Chiniot",
    "Chishtian",
    "Daska",
    "Darya Khan",
    "Dera Ghazi",
    "Dhaular",
    "Dina",
    "Dinga",
    "Dipalpur",
    "Faisalabad",
    "Fateh Jhang",
    "Ghakhar Mandi",
    "Gojra",
    "Gujranwala",
    "Gujrat",
    "Gujar Khan",
    "Hafizabad",
    "Haroonabad",
    "Hasilpur",
    "Haveli",
    "Lakha",
    "Jalalpur",
    "Jattan",
    "Jampur",
    "Jaranwala",
    "Jhang",
    "Jhelum",
    "Kalabagh",
    "Karor Lal",
    "Kasur",
    "Kamalia",
    "Kamoke",
    "Khanewal",
    "Khanpur",
    "Kharian",
    "Khushab",
    "Kot Adu",
    "Jauharabad",
    "Lahore",
    "Lalamusa",
    "Layyah",
    "Liaquat Pur",
    "Lodhran",
    "Malakwal",
    "Mamoori",
    "Mailsi",
    "Mandi Bahauddin",
    "mian Channu",
    "Mianwali",
    "Multan",
    "Murree",
    "Muridke",
    "Mianwali Bangla",
    "Muzaffargarh",
    "Narowal",
    "Okara",
    "Renala Khurd",
    "Pakpattan",
    "Pattoki",
    "Pir Mahal",
    "Qaimpur",
    "Qila Didar",
    "Rabwah",
    "Raiwind",
    "Rajanpur",
    "Rahim Yar",
    "Rawalpindi",
    "Sadiqabad",
    "Safdarabad",
    "Sahiwal",
    "Sangla Hill",
    "Sarai Alamgir",
    "Sargodha",
    "Shakargarh",
    "Sheikhupura",
    "Sialkot",
    "Sohawa",
    "Soianwala",
    "Siranwali",
    "Talagang",
    "Taxila",
    "Toba Tek",
    "Vehari",
    "Wah Cantonment",
    "Wazirabad",
    "Badin",
    "Bhirkan",
    "Rajo Khanani",
    "Chak",
    "Dadu",
    "Digri",
    "Diplo",
    "Dokri",
    "Ghotki",
    "Haala",
    "Hyderabad",
    "Islamkot",
    "Jacobabad",
    "Jamshoro",
    "Jungshahi",
    "Kandhkot",
    "Kandiaro",
    "Karachi",
    "Kashmore",
    "Keti Bandar",
    "Khairpur",
    "Kotri",
    "Larkana",
    "Matiari",
    "Mehar",
    "Mirpur Khas",
    "Mithani",
    "Mithi",
    "Mehrabpur",
    "Moro",
    "Nagarparkar",
    "Naudero",
    "Naushahro Feroze",
    "Naushara",
    "Nawabshah",
    "Nazimabad",
    "Qambar",
    "Qasimabad",
    "Ranipur",
    "Ratodero",
    "Rohri",
    "Sakrand",
    "Sanghar",
    "Shahbandar",
    "Shahdadkot",
    "Shahdadpur",
    "Shahpur Chakar",
    "Shikarpaur",
    "Sukkur",
    "Tangwani",
    "Tando Adam",
    "Tando Allahyar",
    "Tando Muhammad",
    "Thatta",
    "Umerkot",
    "Warah",
    "Abbottabad",
    "Adezai",
    "Alpuri",
    "Akora Khattak",
    "Ayubia",
    "Banda Daud",
    "Bannu",
    "Batkhela",
    "Battagram",
    "Birote",
    "Chakdara",
    "Charsadda",
    "Chitral",
    "Daggar",
    "Dargai",
    "Darya Khan",
    "dera Ismail",
    "Doaba",
    "Dir",
    "Drosh",
    "Hangu",
    "Haripur",
    "Karak",
    "Kohat",
    "Kulachi",
    "Lakki Marwat",
    "Latamber",
    "Madyan",
    "Mansehra",
    "Mardan",
    "Mastuj",
    "Mingora",
    "Nowshera",
    "Paharpur",
    "Pabbi",
    "Peshawar",
    "Saidu Sharif",
    "Shorkot",
    "Shewa Adda",
    "Swabi",
    "Swat",
    "Tangi",
    "Tank",
    "Thall",
    "Timergara",
    "Tordher",
    "Awaran",
    "Barkhan",
    "Chagai",
    "Dera Bugti",
    "Gwadar",
    "Harnai",
    "Jafarabad",
    "Jhal Magsi",
    "Kacchi",
    "Kalat",
    "Kech",
    "Kharan",
    "Khuzdar",
    "Killa Abdullah",
    "Killa Saifullah",
    "Kohlu",
    "Lasbela",
    "Lehri",
    "Loralai",
    "Mastung",
    "Musakhel",
    "Nasirabad",
    "Nushki",
    "Panjgur",
    "Pishin valley",
    "Quetta",
    "Sherani",
    "Sibi",
    "Sohbatpur",
    "Washuk",
    "Zhob",
    "Ziarat"
  ];

  final TextEditingController _searchController = TextEditingController();
  String _selectedCity = 'Islamabad'; // Set a default city
  TextEditingController _typeAheadController = TextEditingController();

  Future<List<String>> _getSuggestions(String query, String city) async {
    final apiUrl = Uri.parse('http://10.0.2.2:8000/search?q=$query&city=$city');

    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data is List) {
          // Remove duplicates by converting the list to a set
          final Set<String> uniqueCategories = data
              .where((item) => item['category']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .map<String>((item) => item['category'].toString())
              .toSet();

          final List<String> suggestions = uniqueCategories.toList();
          return suggestions;
        } else {
          throw Exception('Invalid format: API response is not a List');
        }
      } else {
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  List<BannerSliderModel> _bannerData = [];
  String? username;
  String? email;
  String? image;

  String? city;

  Future<void> newvalues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    email = prefs.getString('email');
    city = prefs.getString('city');
    setState(() {
      image = prefs.getString('image');
      fetchAds();
    });
    image = prefs.getString('image');
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.10,
                            backgroundImage:
                                NetworkImage('http://10.0.2.2:8000/$image'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    username!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            const Divider(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(
                'Home',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text(
                'Profile',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                username != null || username!.isNotEmpty || username != ''
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(
                'Settings',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                username == null || username!.isEmpty || username == ''
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      )
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(),
                        ),
                      );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ));
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('username', '');
                prefs.setString('email', '');
                prefs.setString('image', '');
                prefs.setString('phone', '');
                prefs.setString('city', '');
              },
            ),
          ],
        ),
      ),
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

        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03),
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.05,
              child: IconButton(
                onPressed: () {
                  username == null || username!.isEmpty || username == ''
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationPage(),
                          ),
                        );
                },
                icon: Icon(
                  Icons.notification_add,
                  size: MediaQuery.of(context).size.width * 0.06,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _typeAheadController,
                        decoration: InputDecoration(
                          hintText: 'Select City',
                          prefixIcon: Icon(Icons.location_on),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        return cities.where((city) =>
                            city.toLowerCase().contains(pattern.toLowerCase()));
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        _typeAheadController.text = suggestion;
                        _selectedCity = _typeAheadController.text;
                      },
                      noItemsFoundBuilder: (context) => ListTile(
                        title: Text('No cities found'),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.020,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TypeAheadField<String>(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              color: Colors.grey,
                            ),
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          return _getSuggestions(pattern, _selectedCity);
                        },
                        itemBuilder: (context, String suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        },
                        onSuggestionSelected: (String suggestion) {
                          username == null ||
                                  username!.isEmpty ||
                                  username == ''
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DestinationPage(
                                        data: suggestion, city: _selectedCity),
                                  ),
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Column(
                children: [
                  CarouselSlider(
                    items: [
                      Image.asset(
                        'assets/images/slider_image/banner1.jpg',
                      ),
                      Image.asset(
                        'assets/images/slider_image/banner2.jpg',
                      ),
                      Image.asset(
                        'assets/images/recycle.png',
                      ),
                    ],
                    options: CarouselOptions(
                      aspectRatio: 6 / 3,
                      viewportFraction: 1.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 6),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 300),
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        setState(
                          () {
                            _currentImageSlider = index;
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _bannerData.map(
                      (item) {
                        int index = _bannerData.indexOf(item);
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: _currentImageSlider == index ? 16.0 : 8.0,
                          height: 5.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _currentImageSlider == index
                                ? Colors.amber
                                : Colors.grey[300],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.6),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Categories',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          username == null ||
                                  username!.isEmpty ||
                                  username == ''
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Debris_services(),
                                  ),
                                );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: _mediaQuery.size.width * 0.45,
                          height: _mediaQuery.size.height * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.width * 0.2,
                                child: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width * 0.025,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.delete,
                                    color: const Color.fromARGB(
                                        255, 110, 108, 108),
                                    size: MediaQuery.of(context).size.width *
                                        0.15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              TextButton(
                                onPressed: () {
                                  username == null ||
                                          username!.isEmpty ||
                                          username == ''
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Login(),
                                          ),
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Debris_services(),
                                          ),
                                        );
                                },
                                child: Text(
                                  'Scrap Selling',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  GestureDetector(
                    onTap: () {
                      username == null || username!.isEmpty || username == ''
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PickupCategory(),
                              ),
                            );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: _mediaQuery.size.width * 0.45,
                      height: _mediaQuery.size.height * 0.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.025,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.local_shipping,
                                color: const Color.fromARGB(255, 110, 108, 108),
                                size: MediaQuery.of(context).size.width * 0.15,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          TextButton(
                            onPressed: () {
                              username == null ||
                                      username!.isEmpty ||
                                      username == ''
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                    )
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PickupCategory(),
                                      ),
                                    );
                            },
                            child: Text(
                              'PickUp Service',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              _createAllProduct(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              username == null || username!.isEmpty || username == ''
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
              break;
            case 1:
              username == null || username!.isEmpty || username == ''
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InventoryTab(),
                      ),
                    );
              break;
            case 2:
              username == null || username!.isEmpty || username == ''
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
              break;
            case 3:
              username == null || username!.isEmpty || username == ''
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    )
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
              break;
          }
        },
      ),
    );
  }

  Widget _createAllProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: const Text(
            'News Feed',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: (mydata != null ? (mydata!.length / 2).ceil() : 0),
          itemBuilder: (context, rowIndex) {
            final int index1 = rowIndex * 2;
            final int index2 = index1 + 1;
            if (mydata!.length <= 0) {
              return const Center(
                child: Text("No Data Found"),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: _buildProductCard(index1),
                ),
                if (index2 < mydata!.length)
                  Expanded(
                    child: _buildProductCard(index2),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductCard(int index) {
    final product = mydata![index];
    bool isActive = true;
    return SizedBox(
      width: 250,
      height: 250,
      child: GestureDetector(
        onTap: () {
          username == null || username!.isEmpty || username == ''
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductDetails(productId: product.id!),
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
                  'http://10.0.2.2:8000/${product.image![0]}',
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
                      product.title.toString(),
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
                          'Rs ' + product.price.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 12,
                        ),
                        Expanded(
                          child: Container(
                            height: 20,
                            child: Text(
                              product.location.toString(),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          ' ' +
                              (product.location != null
                                  ? DateFormat('d MMM yyyy').format(
                                      DateTime.parse(product.date.toString()))
                                  : ''),
                          style: TextStyle(fontSize: 11, color: Colors.grey),
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
