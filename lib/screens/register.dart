import 'package:flutter/material.dart';
import '../Components/MyTextfield.dart';
import '../Components/My_button.dart';
import '../services/user_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final AuthService authService = AuthService();

  String? selectedApprover;
  final Map<String, int> approvers = {
    'Pranjal Bezbaruah': 15,
    'Hiranmayee Goswami': 16,
    'None': 0
  };

  String? emailError;
  String? passwordError;

  Future<void> registerUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      int? firstApproverId = selectedApprover != null ? approvers[selectedApprover!] : null;

      try {
        final response = await authService.register(
          name: name,
          email: email,
          password: password,
          firstApproverId: firstApproverId,
        );

        if (response.isNotEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Registration Successful'),
                content: Text('You have been successfully registered.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.of(context).pop(); // Go back to the login page
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      setState(() {
        emailError = 'Please enter your email';
      });
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      setState(() {
        emailError = 'Please enter a valid email';
      });
    } else {
      setState(() {
        emailError = null;
      });
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      setState(() {
        passwordError = 'Please enter your password';
      });
    } else if (value.length < 6) {
      setState(() {
        passwordError = 'Password must be at least 6 characters long';
      });
    } else if (!RegExp(r'^(?=.*[!@#\$&*~]).{6,}$').hasMatch(value)) {
      setState(() {
        passwordError = 'Password is too weak';
      });
    } else {
      setState(() {
        passwordError = null;
      });
    }
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
                    Icons.person_add,
                    size: 100,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Create an Account',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        MyTextField(
                          controller: nameController,
                          hintText: 'Name',
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: emailController,
                          hintText: 'Email',
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          onChanged: validateEmail,
                          errorText: emailError,
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            if (!RegExp(r'^(?=.*[!@#\$&*~]).{6,}$').hasMatch(value)) {
                              return 'Password is too weak';
                            }
                            return null;
                          },
                          onChanged: validatePassword,
                          errorText: passwordError,
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(color: Colors.white),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: selectedApprover,
                              hint: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text('Select HOD', style: TextStyle(color: Colors.grey[500])),
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                              ),
                              items: approvers.keys.map((String key) {
                                return DropdownMenuItem<String>(
                                  value: key,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Text(key),
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedApprover = newValue;
                                });
                              },
                              validator: (value) {
                                return null; // Optional field, so no validation needed
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        _isLoading
                            ? CircularProgressIndicator()
                            : MyButton(
                          onTap: () => registerUser(context),
                          text: 'Register',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(); // Go back to the login page
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
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
