import 'package:flutter/material.dart';
import '../shared/BottomBar.dart';
import '../shared/candidate_database_helper.dart';
import '../shared/drawer_widget.dart';
import 'contact_us.dart';
import 'home_page.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late CandidateDatabaseHelper databaseHelper;

  String? selectedFilter1;
  String? selectedFilter2;
  List<String> filter2Options = [];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قائمة الفائزين'),
          backgroundColor: Colors.redAccent, // Customize the color as needed
          toolbarHeight: 70.0,
        ),
        body: Column(
          children: [
            const SizedBox(height: 16.0),
            _buildFiltersRow1(),
            _buildFiltersRow2(),
            const SizedBox(height: 16.0),
            Expanded(
              child: _buildVoteList(),
            ),
          ],
        ),
        bottomNavigationBar: MyBottomNavigationBar(
          onHomeTabPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
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
                filter2Options = _getFilter2Options(selectedFilter1);
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
    if (selectedFilter1 == 'الغربية') {
      return ['اول طنطا', 'المحلة'];
    } else {
      return [];
    }
  }

  Widget _buildDropdownFilter(
      String filterName,
      Color backgroundColor,
      String? value,
      List<String> items,
      Function(String?) onChanged,
      ) {
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

  Widget _buildVoteList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: CandidateDatabaseHelper.instance.getCandidates(
        city: selectedFilter1,
        state: selectedFilter2,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Map<String, dynamic>> candidates = snapshot.data ?? [];
          return ListView.builder(
            itemCount: candidates.length,
            itemBuilder: (context, index) {
              return _buildPersonInfoCard(candidates[index]);
            },
          );
        }
      },
    );
  }

  Widget _buildPersonInfoCard(Map<String, dynamic> candidate) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 45.0,
                    backgroundImage: AssetImage(candidate['image']),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 16, 12),
                        child: Text(
                          candidate['name']!,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 16, 6),
                        child: Text(
                          candidate['details']!,
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 8.0,
              left: 8.0,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: 100,
                    height: 40,
                    child: Text(
                      'الأصوات: ${candidate['votes'] ?? 0}', // Assuming 'votes' is the key for the vote count
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
