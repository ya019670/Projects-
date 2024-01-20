import 'package:electronic_election/screens/vote_page.dart';
import 'package:electronic_election/screens/vote_place_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:electronic_election/shared/BottomBar.dart';
import 'package:electronic_election/shared/drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'candidates_page.dart';
import 'contact_us.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({Key? key});

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
            // Navigate to the WelcomePage instead of closing the app
            Navigator.pushReplacementNamed(context, '/welcome');
            return false; // Return false to prevent further navigation
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('الرئيسية'),
              backgroundColor: Colors.redAccent,
              toolbarHeight: 70.0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 250.0, // Set your desired height here
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset(
                              'images/vote.jpeg', // Replace with the path to your image
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0, // Adjust this value to place the button at the desired height
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _launchURL('https://www.elections.eg/inquiry');
                                  // Add your button functionality here
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.all(14.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                child: const Text(
                                  'استعلم عن موقفك الانتخابي',
                                  style: TextStyle(fontSize: 16.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 32, 0),
                        child: Expanded(
                          child: Text(
                            'العناصر',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 16.0, color: Colors.grey,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Add functionality for the "قائمة المرشحين" container
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CandidatesPage()),
                          );
                        },
                        child: Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: const IconBox(
                            icon: Icons.people_outline,
                            text: 'قائمة المرشحين',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Add functionality for the "أماكن اللجان" container
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VotePlacesPage()),
                          );
                        },
                        child: Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: const IconBox(
                            icon: Icons.place_outlined,
                            text: 'أماكن اللجان',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Add functionality for the "تصويت" container
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VotePage()),
                          );
                        },
                        child: Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: const IconBox(
                            icon: Icons.how_to_vote_outlined,
                            text: 'تصويت',
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/results');
                        },
                        child: Container(
                          width: 120.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: const IconBox(
                            icon: Icons.list_alt_outlined,
                            text: 'قائمة الفائزين',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
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

  Future<void> _launchURL(String url) async {
    try {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}

class IconBox extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconBox({Key? key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 40.0,
        ),
        const SizedBox(height: 8.0),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}
