import 'package:flutter/material.dart';
import 'package:fyp/home/home.dart';
import 'package:fyp/inventory/All_inventory.dart';
import 'package:fyp/inventory/pending_inventory.dart';
import 'package:fyp/inventory/sold_niventory.dart';
import 'package:fyp/user%20profile/user_profile.dart';
import 'package:google_fonts/google_fonts.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  @override
  int _currentIndex = 1;
  Size get preferredSize => Size.fromHeight(80.0);
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // Choose your preferred color
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
            'Pickup Service',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.06,
              color: Colors.white,
            ),
          ),

          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: Container(
              height: 60,
              margin: EdgeInsets.symmetric(horizontal: 45),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TabBar(
                tabs: [
                  Tab(
                    text: 'Active',
                    icon: Icon(Icons.sell),
                  ),
                  Tab(
                    text: 'Sold',
                    icon: Icon(Icons.done),
                  ),
                ],
                labelColor: Colors.green, // Set the label color
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            AllProduct(),
            SoldProduct(),
            PendingProduct(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InventoryTab(),
                  ),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}
