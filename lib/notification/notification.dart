import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

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
          'Notifications',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.06,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        children: [
          _buildNotificationItem(
            icon: Icons.info,
            title: 'New update available',
            subtitle: 'Version 2.0 is now available for download',
            date: 'May 5, 2023',
          ),
          _buildNotificationItem(
            icon: Icons.check_circle_outline,
            title: 'Order confirmed',
            subtitle: 'Your order #12345 has been confirmed',
            date: 'May 3, 2023',
          ),
          _buildNotificationItem(
            icon: Icons.warning,
            title: 'Payment failed',
            subtitle: 'Your payment for order #67890 has failed',
            date: 'May 1, 2023',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String date,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(date),
      onTap: () {
        // Handle notification tap here
      },
    );
  }
}
