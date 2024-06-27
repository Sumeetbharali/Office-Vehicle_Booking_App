import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nic_yaan/pages/hidden_drawer.dart';
import '../services/api_service.dart'; // Import your API service
import '../Components/MyTextfield.dart';
import '../Components/My_button.dart';
import 'loading.dart';
import 'register.dart';
import 'driver.dart';
import 'approver.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<String?> emailErrorNotifier = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    usernameController.removeListener(_validateEmail);
    usernameController.dispose();
    passwordController.dispose();
    emailErrorNotifier.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = usernameController.text.trim();
    if (email.isEmpty || RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      emailErrorNotifier.value = null;
    } else {
      emailErrorNotifier.value = 'Enter a valid email address';
    }
  }

  Future<void> showErrorDialog(BuildContext context, String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void signUserIn(BuildContext context) async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    // Validate email format before attempting login
    if (emailErrorNotifier.value != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailErrorNotifier.value!)),
      );
      return;
    }

    int responseCode = (await APIServices().login(username, password)) as int;

    if (responseCode == 200) {
      // Navigate to the loading page to check token and navigate accordingly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingPage(),
        ),
      );
    } else {
      // Handle different error codes
      if (responseCode == 404) {
        await showErrorDialog(context, 'Login Failed', 'Email does not exist.');
      } else if (responseCode == 403) {
        await showErrorDialog(context, 'Login Failed', 'Account is not approved yet.');
      } else if (responseCode == 401) {
        await showErrorDialog(context, 'Login Failed', 'Password incorrect.');
      } else {
        await showErrorDialog(context, 'Login Failed', 'An unknown error occurred. Please try again.');
      }
    }
  }

  void navigateToRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Icon(
                    Icons.lock,
                    size: 100,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  ValueListenableBuilder<String?>(
                    valueListenable: emailErrorNotifier,
                    builder: (context, emailError, child) {
                      return Column(
                        children: [
                          MyTextField(
                            controller: usernameController,
                            hintText: 'Username (Email)',
                            obscureText: false,
                          ),
                          if (emailError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                emailError,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    onTap: () => signUserIn(context),
                    text: 'Sign In',
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: () => navigateToRegisterPage(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
