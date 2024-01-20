import 'package:flutter/material.dart';
import 'package:electronic_election/shared/BottomBar.dart';
import 'package:electronic_election/shared/drawer_widget.dart';
import 'package:flutter/services.dart';

import 'contact_us.dart';

class WelcomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  WelcomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.redAccent,
        ),
        child: WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return true;
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('العناصر الانتخابية'),
              backgroundColor: Colors.redAccent,
              toolbarHeight: 70.0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60.0), // Increased the space under AppBar
                  _buildRoundedButton(context, 'الانتخابات الرئاسية', '/home'),
                  SizedBox(height: 30.0),
                  _buildRoundedButton(context, 'انتخابات مجلس الشعب', '/home'),
                  SizedBox(height: 30.0),
                  _buildRoundedButton(context, 'انتخابات مجلس الشوري', '/home'),
                ],
              ),
            ),
            bottomNavigationBar: MyBottomNavigationBar(
              onHomeTabPressed: () {
                Navigator.pushReplacementNamed(context, '/welcome');
              },
              onContactTabPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUsPage()),
                );
              },
              onMenuTabPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
            ),
            drawer: CustomDrawer.defaults(context),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedButton(BuildContext context, String text, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, routeName);
      },
      child: Container(
        width: double.infinity,
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
