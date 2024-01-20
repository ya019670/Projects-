import 'package:flutter/material.dart';
import 'package:electronic_election/screens/results.dart';
import 'package:electronic_election/screens/sign_in_page.dart';
import 'package:electronic_election/screens/splash_screen.dart';
import 'contact_us.dart';
import 'election_page.dart';
import 'home_page.dart';
import 'intro.dart';
import 'laws_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/sign_in': (context) => const SignInPage(),
        '/home': (context) => HomePage(),
        '/intro': (context) => IntroPage(),
        '/laws': (context) => LawsPage(),
        '/contact': (context) => ContactUsPage(),
        '/results': (context) => ResultsPage(),
        '/splash': (context) => const SplashScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (context) => const SplashScreen());
          case '/sign_in':
            return MaterialPageRoute(
              builder: (context) => const SignInPage(),
              settings: RouteSettings(name: '/sign_in'),
            );
          case '/welcome':
            return MaterialPageRoute(builder: (context) => WelcomePage());
        // Add other cases if needed
          default:
          // Handle unknown routes
            return MaterialPageRoute(builder: (context) => const SplashScreen());
        }
      },
      initialRoute: '/splash',
      onGenerateInitialRoutes: (String initialRouteName) {
        return [
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
            settings: RouteSettings(name: '/splash'),
          ),
        ];
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
