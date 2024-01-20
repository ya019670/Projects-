import 'package:flutter/material.dart';
import '../shared/BottomBar.dart';
import '../shared/candidate_database_helper.dart';
import '../shared/drawer_widget.dart';
import 'contact_us.dart';

class CandidatesPage extends StatefulWidget {
  CandidatesPage({Key? key}) : super(key: key);

  @override
  _CandidatesPageState createState() => _CandidatesPageState();
}

class _CandidatesPageState extends State<CandidatesPage> {
  String? selectedFilter1;
  String? selectedFilter2;
  List<String> filter2Options = [];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late CandidateDatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = CandidateDatabaseHelper.instance;

    // Uncomment the next line to add candidates to the database for testing
    // _addCandidates();
    // Uncomment the next line to delete all candidates from the database
    // _deleteCandidates();
    // _deleteCandidate(' محمد وحيد');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('قائمة المرشحين'),
          backgroundColor: Colors.redAccent,
          toolbarHeight: 70.0,
        ),
        body: Column(
          children: [
            SizedBox(height: 16.0),
            _buildFiltersRow1(),
            _buildFiltersRow2(),
            SizedBox(height: 16.0),
            Expanded(
              child: _buildCandidatesList(),
            ),
          ],
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

  Widget _buildCandidatesList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: databaseHelper.getCandidates(
          city: selectedFilter1, state: selectedFilter2),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
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
        child: InkWell(
          onTap: () {
            _showMoreInformationDialog(candidate);
          },
          child: Padding(
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
                      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                      child: Text(
                        candidate['name']!,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
                      child: Text(
                        candidate['details']!,
                        style: const TextStyle(fontSize: 22.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMoreInformationDialog(Map<String, dynamic> candidate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'البرنامج الانتخابي',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    candidate['extraInfo'] ?? '', // Use the actual extra info
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  void _addCandidates() async {
    await databaseHelper.insertCandidate({
      'name': 'محمد عبدالتواب',
      'details': '58',
      'city': 'الغربية',
      'state': 'اول طنطا',
      'extraInfo': 'البرنامج الانتخابي للمرشح محمد عبدالتواب',
      'image': 'images/avatar.jpg',
      'votes': 0, // Default votes to 0
    });

    await databaseHelper.insertCandidate({
      'name': 'خالد منصف',
      'details': '5',
      'city': 'الغربية',
      'state': 'المحلة',
      'extraInfo': 'البرنامج الانتخابي للمرشح خالد منصف',
      'image': 'images/avatar.jpg',
      'votes': 0, // Default votes to 0
    });

    // Add more candidates if needed
  }

  void _deleteCandidates() async {
    await databaseHelper.database.then((db) async {
      await db.delete('candidates');
    });
  }

  // void _deleteCandidate(String candidateName) async {
  //   await databaseHelper.deleteCandidateByName(candidateName);
  //   setState(() {
  //   });
  // }

  void _deleteCandidate(String candidateName) async {
    await databaseHelper.deleteCandidateByName(candidateName);
    setState(() {});
  }
}
