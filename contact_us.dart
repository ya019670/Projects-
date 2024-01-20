import 'package:flutter/material.dart';

import '../shared/BottomBar.dart';
import '../shared/drawer_widget.dart';

class ContactUsPage extends StatelessWidget {
   ContactUsPage({Key? key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/home');
          return false;
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: const Text('تواصل معنا'),
            backgroundColor: Colors.redAccent,
            toolbarHeight: 70,
          ),
          body: const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    'يمكنك التواصل مع الهيئة الوطنية للانتخابات عن طريق:',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 20.0),
                  ContactInfoCard(
                    icon: Icons.phone,
                    label: 'رقم الهاتف:',
                    value: '02 2793 3136',
                  ),
                  ContactInfoCard(
                    icon: Icons.email,
                    label: 'البريد الإلكتروني:',
                    value: 'Elections@nea.gov.eg',
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: MyBottomNavigationBar(
            onHomeTabPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            onContactTabPressed: () {},
            onMenuTabPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
          ),
          drawer: CustomDrawer.defaults(context),
        ),
      ),
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ContactInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30.0,
              color: Colors.redAccent,
            ),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5.0),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
