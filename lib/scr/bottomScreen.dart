import 'package:flutter/material.dart';
import 'package:itec_parking/scr/contactScreen.dart';
import 'package:itec_parking/scr/homeScreen.dart';
import 'package:itec_parking/scr/postPaid.dart';

class BottomNavigation extends StatefulWidget {
  final int initialIndex; // Add this parameter

  const BottomNavigation({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Set the initial tab
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Color(0xFFA77D55), // Background color of the bar
        elevation: 10, // Add shadow
        type: BottomNavigationBarType.fixed, // Keep items fixed in position
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        showUnselectedLabels: true, //
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Post-Paid',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Contact',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const PostpaidScreen();
      case 2:
        return const ContactScreen();

      default:
        return const HomeScreen();
    }
  }
}
