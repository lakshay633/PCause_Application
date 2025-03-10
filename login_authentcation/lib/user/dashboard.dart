import 'package:flutter/material.dart';
import 'package:login_authentcation/Pages/login.dart';
import 'package:login_authentcation/User_pages/page1.dart';
import 'package:login_authentcation/User_pages/page2.dart';
import 'package:login_authentcation/User_pages/page3.dart';
import 'package:login_authentcation/user/profile.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.black), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange.shade800,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.pink.shade400, Colors.blue.shade700],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTile(context, 'PCOS Detection', "assets/one.png",
                  PCOSDetectionPage(), screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildTile(context, 'Get the Analytics', "assets/two.png",
                  Page2(), screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildTile(context, 'Check Symptoms', "assets/three.png", Page3(),
                  screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, String imagePath,
      Widget page, double screenWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Card(
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.white, width: 1.5),
        ),
        shadowColor: Colors.black45,
        child: Container(
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: screenWidth * 0.4,
                ),
                Container(
                  width: double.infinity,
                  height: screenWidth * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
