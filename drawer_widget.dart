import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onAgencyPressed;
  final VoidCallback onLawsPressed;
  final VoidCallback onEventsPressed;
  final VoidCallback onAbroadPressed;
  final VoidCallback onContactPressed;
  final VoidCallback onLogoutPressed;

  const CustomDrawer({
    super.key,
    required this.onHomePressed,
    required this.onAgencyPressed,
    required this.onLawsPressed,
    required this.onEventsPressed,
    required this.onAbroadPressed,
    required this.onContactPressed,
    required this.onLogoutPressed,
  });

  factory CustomDrawer.defaults(BuildContext context) {
    return CustomDrawer(
      onHomePressed: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home');
      },
      onAgencyPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/intro');
      },
      onLawsPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/laws');
      },
      onEventsPressed: () {
        Navigator.pop(context);
        _launchURL('https://www.elections.eg/events-menu');
      },
      onAbroadPressed: () {
        Navigator.pop(context);
        _launchURL('https://www.elections.eg/hor20-ocv/ocv-locations');
        },
      onContactPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/contact');
      },
      onLogoutPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/sign_in');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'القائمة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildListTile('الرئيسية', onHomePressed),
          _buildListTile('الهيئة', onAgencyPressed),
          _buildListTile('القوانين', onLawsPressed),
          _buildListTile('الأحداث', onEventsPressed),
          _buildListTile('المصريون بالخارج', onAbroadPressed),
          _buildListTile('تواصل معنا', onContactPressed),
          const SizedBox(height: 24),
          _buildListTileWithIcon('تسجيل خروج', Icons.exit_to_app, onLogoutPressed),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  ListTile _buildListTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 18,
        ),
      ),
      onTap: onTap,
    );
  }

  ListTile _buildListTileWithIcon(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 18,
            ),
          ),
          Icon(
            icon,
            color: Colors.black54,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

        static Future<void> _launchURL(String url) async {
          try {
              await launch(
                url,
                forceSafariVC: false,
                forceWebView: false,
                headers: <String, String>{'header_key': 'header_value'},
              );
          } catch (e)
          {
            print('Error launching URL: $e');
          }
  }
}