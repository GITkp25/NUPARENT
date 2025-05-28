import 'package:flutter/material.dart';
import 'package:nu_parent/child_dashboard.dart';
import 'package:nu_parent/main.dart';
import 'package:nu_parent/registration_screen.dart';
import 'package:nu_parent/forget_password.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool check = false;
  bool _obscureText = true;
  bool _isChecked = false;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  late ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    _checkKeepLoggedInStatus();
    _progressDialog = ProgressDialog(context);
  }

  Future<void> _checkKeepLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool keepLoggedIn = prefs.getBool('keepLoggedIn') ?? false;

    if (keepLoggedIn) {
      String userId = prefs.getString('uid') ?? '';
      if (userId.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChildDashboard()),
        );
      }
    }
  }

  Future<void> saveUserInfoToLocalDatabase(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', userId);
  }

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _progressDialog.show();
      try {
        final FirebaseAuth auth = FirebaseAuth.instance;
        final UserCredential userCredential =
            await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        );

        // If login is successful, navigate to the SJC page
        if (userCredential.user != null) {
          if (_isChecked) {
            // Save user info to shared preferences
            String userId = userCredential.user?.uid ?? '';
            print('User ID: $userId');
            await saveUserInfoToLocalDatabase(userId);
            // Save login status
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('keepLoggedIn', true);
          }

          _progressDialog.hide();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChildDashboard()),
          );
        }
      } catch (e) {
        // Handle login failure and show an error toast.
        _progressDialog.hide();
        String errorMessage = 'Login failed';

        if (e is FirebaseAuthException) {
          errorMessage = e.code;
        }

        Fluttertoast.showToast(
          msg: errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView(children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Image.asset('assets/TeethFamily.jpg',
                  height: 400, fit: BoxFit.cover),
            ),
            Positioned(
                top: 20,
                left: 90,
                child: ClipOval(
                    child: Image.asset(
                  'assets/nuParent.png',
                  width: 100,
                  height: 100,
                ))),
          ],
        ),
        Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: 'Email Address',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 25.0),
                        filled: true,
                        fillColor: const Color.fromARGB(31, 121, 120, 120),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                        suffixIcon: const Padding(
                          padding: EdgeInsets.only(right: 25.0),
                          child: Icon(Icons.lock),
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                  child: TextFormField(
                    controller: _passController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 25.0),
                      filled: true,
                      fillColor: const Color.fromARGB(31, 121, 120, 120),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none),
                      suffixIcon: InkWell(
                        onTap: _togglePasswordVisibility,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Icon(_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      // Add more password validation logic if needed
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              activeColor: AppColors.primaryColor,
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                            ),
                            const Text('Keep Me Logged In')
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPassword(),
                                ));
                          },
                          child: const Text(
                            'Forget Password ?',
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        )
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationScreen()));
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 30, 80),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15)),
                          child: const Text(
                            'Login',
                            style:
                                TextStyle(fontSize: 20, color: AppColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            )),
      ]),
    );
  }
}
