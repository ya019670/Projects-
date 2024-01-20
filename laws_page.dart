import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:electronic_election/shared/drawer_widget.dart';
import 'contact_us.dart';
import 'home_page.dart';
import '../shared/BottomBar.dart';

class LawsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  LawsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          return false;
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: const Text('القوانين'),
            backgroundColor: Colors.redAccent,
            toolbarHeight: 70.0,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end, // Align to the end
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildStyledText('دستور جمهورية مصر العربية', 24.0, Colors.red.shade800), // Styled text
                    buildUnderlinedBoldTextWithLink(
                      '-  دستور جمهورية مصر العربية الصادر في يناير ٢٠١٤ والمعدل بالاستفتاء على تعديل بعض مواد الدستور ٢٠١٩',
                      'https://www.elections.eg/images/pdfs/laws/Constitution_2014.pdf',
                      16.0,
                    ),
                    const SizedBox(height: 16.0),
                    buildStyledText('قانون إنشاء الهيئة الوطنية للانتخابات', 24.0, Colors.red.shade800), // Styled text
                    buildUnderlinedBoldTextWithLink(
                      '-  قانون رقم ١٩٨ لسنة ٢٠١٧ بشأن الهيئة الوطنية للانتخابات',
                      'https://www.elections.eg/images/pdfs/laws/NEAlaw2017-198.pdf',
                      16.0,
                    ),
                    const SizedBox(height: 16.0),
                    buildStyledText('قوانين ذات صلة ', 24.0, Colors.red.shade800), // Styled text
                    buildUnderlinedBoldTextWithLink(
                      '-  قانون رقم ١٤١ لسنة ٢٠٢٠ بإصدار قانون مجلس الشيوخ',
                      'https://www.elections.eg/images/pdfs/laws/Senate2020-141.pdf',
                      16.0,
                    ),
                    buildUnderlinedBoldTextWithLink(
                      '-  قانون رقم ٤٥ لسنة ٢٠١٤ بتنظيم مباشرة الحقوق السياسية',
                      'https://www.elections.eg/images/pdfs/laws/PoliRights2014-45.pdf',
                      16.0,
                    ),
                    buildUnderlinedBoldTextWithLink(
                      '-  قانون رقم ٩٢ لسنة ٢٠١٥ بتعديل بعض أحكام القرار بقانون رقم ٤٥ لسنة ٢٠١٤ والقرار بقانون رقم ٤٦ لسنة ٢٠١٤',
                      'https://www.elections.eg/images/pdfs/laws/HouseOfRepresentativesAmendments2015-92.pdf',
                      16.0,
                    ),
                    buildUnderlinedBoldTextWithLink(
                      '-  قانون رقم ١٤٠ لسنة ٢٠٢٠ بتعديل بعض أحكام قانون تنظيم مباشرة الحقوق السياسية',
                      'https://www.elections.eg/images/pdfs/laws/PoliRightsAmendments2020-140.pdf',
                      16.0,
                    ),
                    buildUnderlinedBoldTextWithLink(
                      '-  قانون رقم ٤٦ لسنة ٢٠١٤ لمجلس النواب',
                      'https://www.elections.eg/images/pdfs/laws/HouseOfRepresentatives2014-46.pdf',
                      16.0,
                    ),
                    buildUnderlinedBoldTextWithLink(
                      '-  قانون رقم ٢٠٢ لسنة ٢٠١٤ في شأن تقسيم دوائر انتخابات مجلس النواب',
                      'https://www.elections.eg/images/pdfs/laws/Constituencies2014-202.pdf',
                      16.0,
                    ),
                    buildUnderlinedBoldTextWithLink(
                      '-  قانون رقم ٨٨ لسنة ٢٠١٥ بتعديل بعض أحكام القرار بقانون رقم ٢٠٢ لسنة ٢٠١٤',
                      'https://www.elections.eg/images/pdfs/laws/Constituencies2015-88.pdf',
                      16.0,
                    ),
                  ],
                ),
              ),
            ),
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
      ),
    );
  }

  Widget buildStyledText(String text, double fontSize, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.red.shade800,
        ),
      ),
    );
  }

  Widget buildUnderlinedBoldText(String text, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        textDirection: TextDirection.rtl, // Set text direction
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: fontSize,
          // decoration: TextDecoration.underline,
          //  fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget buildUnderlinedBoldTextWithLink(
      String text,
      String link,
      double fontSize,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        text: TextSpan(
          style: TextStyle(
            fontSize: fontSize,
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          children: [
            TextSpan(
              text: text,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await _launchURL(link);
                },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      // Open the URL in the system browser
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
