import 'package:flutter/material.dart';
import 'package:mybarsheet/core/constants/appColors.dart';
import 'package:mybarsheet/presentation/screens/addItem_screen.dart';
import 'package:mybarsheet/presentation/screens/home_screen.dart';
import 'package:mybarsheet/presentation/screens/profile_screen.dart';

class BottomTab extends StatefulWidget {
  const BottomTab({super.key});

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProfileScreen(),
  ];

  void _onTabTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );
        },
        child: Icon(Icons.shopping_basket, color: Colors.black, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomPaint(
        painter: WavyBottomNavPainter(),
        child: BottomAppBar(
          color: Colors.transparent,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          elevation: 0,
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.inventory_2_outlined,
                      color: _selectedIndex == 0 ? Color(0xFFD9B382) : Colors.grey,
                    ),
                    onPressed: () => _onTabTap(0),
                  ),
                  const SizedBox(width: 48),
                  IconButton(
                    icon: Icon(
                      Icons.person_outline,
                      color: _selectedIndex == 1 ? Color(0xFFD9B382) : Colors.grey,
                    ),
                    onPressed: () => _onTabTap(1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WavyBottomNavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.card
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width * 0.2, 0);

    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.28, 15);
    path.quadraticBezierTo(size.width * 0.5, 50, size.width * 0.72, 15);
    path.quadraticBezierTo(size.width * 0.75, 0, size.width * 0.8, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}