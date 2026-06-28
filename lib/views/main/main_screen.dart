import 'package:flutter/material.dart';
import 'package:saku_app/views/main/add_transaction_screen.dart';
import 'package:saku_app/views/main/home_screen.dart';
import 'package:saku_app/views/main/profil_screen.dart';
import 'package:saku_app/views/main/statistic_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final pages = const [
    HomeScreen(),
    StatisticsScreen(),
    AddTransactionScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: Container(
  decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, -4),
      ),
    ],
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    ),
  ),
  child: ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    ),
    child: BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },

      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 0,

      selectedItemColor: const Color(0xff2563EB),
      unselectedItemColor: Colors.grey.shade500,

      selectedFontSize: 13,
      unselectedFontSize: 12,

      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),

      showUnselectedLabels: true,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          activeIcon: Icon(
            Icons.home_rounded,
            size: 30,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_rounded),
          activeIcon: Icon(
            Icons.bar_chart_rounded,
            size: 30,
          ),
          label: "Statistics",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_rounded),
          activeIcon: Icon(
            Icons.add_circle,
            size: 34,
          ),
          label: "Add",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          activeIcon: Icon(
            Icons.person_rounded,
            size: 30,
          ),
          label: "Profile",
        ),
      ],
    ),
  ),
),
    );
  }
}