// vote_places_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/BottomBar.dart';
import '../shared/drawer_widget.dart';
import 'contact_us.dart';

class VotePlacesPage extends StatefulWidget {
  const VotePlacesPage({super.key});


  @override
  _VotePlacesPageState createState() => _VotePlacesPageState();
}

class _VotePlacesPageState extends State<VotePlacesPage> {
  String? selectedFilter1;
  String? selectedFilter2;
  List<String> filter2Options = [];

  final GlobalKey<ScaffoldState> scaffoldKey =
  GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('أماكن اللجان'),
          backgroundColor: Colors.redAccent, // Choose the desired color
          toolbarHeight: 70.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16.0),
              _buildFiltersRow1(),
              _buildFiltersRow2(),
              const SizedBox(height: 16.0),
              _buildVotePlacesList(),
            ],
          ),
        ),
        bottomNavigationBar: MyBottomNavigationBar(
          onHomeTabPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          onContactTabPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ContactUsPage()),
            );
          },
          onMenuTabPressed: () {

            scaffoldKey.currentState?.openDrawer();
          },
        ),
        drawer: CustomDrawer.defaults(context),
      ),
    );
  }

  Widget _buildFiltersRow1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDropdownFilter(
            'اختر المحافظة',
            Colors.grey.shade400,
            selectedFilter1,
            ['الغربية'],
                (String? value) {
              setState(() {
                selectedFilter1 = value;
                // Update filter2Options based on selectedFilter1
                filter2Options = _getFilter2Options(selectedFilter1);
                // Reset selectedFilter2 when changing filter1
                selectedFilter2 = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersRow2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDropdownFilter(
            'اختر المركز',
            Colors.grey.shade400,
            selectedFilter2,
            filter2Options,
                (String? value) {
              setState(() {
                selectedFilter2 = value;
              });
            },
          ),
        ],
      ),
    );
  }

  List<String> _getFilter2Options(String? selectedFilter1) {
    // Replace this with logic to get filter2 options based on filter1 selection
    // For demonstration, using static options
    if (selectedFilter1 == 'الغربية') {
      return ['اول طنطا', 'المحلة'];
    } else {
      return [];
    }
  }

  Widget _buildDropdownFilter(String filterName,
      Color backgroundColor,
      String? value,
      List<String> items,
      Function(String?) onChanged,) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: 350,
        height: 50.0,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28.0),
        ),
        child: DropdownButton<String>(
          value: value,
          icon: null,
          iconSize: 0,
          elevation: 12,
          hint: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                filterName,
                textAlign: TextAlign.right,
              ),
            ),
          ),
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 2,
            color: Colors.transparent,
          ),
          items: items.map((String itemValue) {
            return DropdownMenuItem<String>(
              value: itemValue,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(itemValue, textAlign: TextAlign.right),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildVotePlacesList() {
    List<Map<String, String>> votePlaces = [
      {'name': 'مدرسة الشهيد علي', 'url': 'https://maps.app.goo.gl/G28xgCvEFPvfvhxS9'},
      {'name': 'مدرسة النور', 'url': 'https://maps.app.goo.gl/G28xgCvEFPvfvhxS9'},
      {'name': 'مدرسة الحرية', 'url': 'https://maps.app.goo.gl/G28xgCvEFPvfvhxS9'},
      // Add more vote places with their names and URLs
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: votePlaces.length,
      itemBuilder: (context, index) {
        return _buildVotePlaceCard(votePlaces[index]);
      },
    );
  }



  Widget _buildVotePlaceCard(Map<String, String> votePlace) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0), // Adjust the value for more or less rounding
      ),
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  votePlace['name']!,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0), // Add some space between the ListTile and TextButton
            // Add a TextButton on the right side of the card
            TextButton(
              onPressed: () {
                // Navigate to the URL link
                // Use the URL provided in the votePlace map
                launch(votePlace['url']!);
              },
              child: const Text(
                'اطلع على الخريطة',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}