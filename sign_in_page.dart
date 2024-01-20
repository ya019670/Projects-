import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../shared/database_helper.dart';
import 'election_page.dart';
import 'home_page.dart';
import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _signIn(BuildContext context) async {
    String nationalId = _nationalIdController.text;
    String password = _passwordController.text;

    if (nationalId.isNotEmpty && password.isNotEmpty) {
      bool userExists = await _databaseHelper.checkUserExists(nationalId, password);

      if (userExists) {
        print('تسجيل الدخول بالرقم القومي: $nationalId, كلمة المرور: $password');

        // Navigate to the WelcomePage instead of HomePage
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomePage()));
      } else {
        print('الرقم القومي أو كلمة مرور غير صالحة');
        // Handle invalid login
        // Show an error message to the user, if needed
      }
    } else {
      print('الرقم القومي أو كلمة مرور غير صالحة');

      // Exit the app when login details are empty
      SystemNavigator.pop();
    }
  }

  void _forgotPassword() {
    // Implement the logic for handling forgot password
    print('Forgot Password');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تسجيل الدخول',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.redAccent,
          toolbarHeight: 70.0,
          automaticallyImplyLeading: false, // Hide the back arrow
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 100.0, 16.0, 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Image.asset(
                            'images/logo.png',
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _nationalIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'الرقم القومي',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال الرقم القومي';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال كلمة المرور';
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: _forgotPassword,
                        child: const Text(
                          'نسيت كلمة المرور؟',
                          style: TextStyle(
                            color: Colors.redAccent,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signIn(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                        ),
                        child: const Text(
                          'دخول',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                          if (result == 'resetForm') {
                            _formKey.currentState?.reset();
                          }
                        },
                        child: const Center(
                          child: Text(
                            'سجل الآن',
                            style: TextStyle(
                              color: Colors.redAccent,
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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
