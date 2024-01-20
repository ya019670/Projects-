import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final Function() onHomeTabPressed;
  final Function() onContactTabPressed;
  final Function() onMenuTabPressed;

  const MyBottomNavigationBar({
    super.key,
    required this.onHomeTabPressed,
    required this.onContactTabPressed,
    required this.onMenuTabPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(26.0), // Adjust the corner radius as needed
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(
              Icons.home,
              'الرئيسية',
              onHomeTabPressed,
              iconSize: 40.0,
              textColor: Colors.grey,
            ),
            _buildTabItem(
              Icons.call,
              'اتصل بنا',
              onContactTabPressed,
              iconSize: 40.0,
              textColor: Colors.grey,
            ),
            _buildTabItem(
              Icons.menu,
              'القائمة',
              onMenuTabPressed,
              iconSize: 40.0,
              textColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(IconData icon, String title, Function() onPressed,
      {double iconSize = 24.0, Color textColor = Colors.black}) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(icon),
              color: Colors.white,
              iconSize: iconSize,
              onPressed: onPressed,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
