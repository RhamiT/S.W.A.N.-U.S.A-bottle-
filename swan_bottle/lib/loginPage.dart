// TODO:
//    - Add specifications for registration and check
import 'package:flutter/material.dart';
import 'dart:convert';
import 'main.dart';
import 'user.dart';
import 'package:http/http.dart' as http;

//global functions and variables
User user = User();

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginMenu();
}

class _LoginMenu extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String? _username;
  String? _password;
  String _errMsg = "";

  @override
  void initState() {
    super.initState();
    user.amplifyInit();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("login menu")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text("Login"),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Login",
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => _username = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        print(
                          "testing testing testing ($_username : $_password) testing testing testing",
                        ); // rm
                        if (_formKey.currentState!.validate())
                          _formKey.currentState!.save();
                        bool? msg = await user.LoginUsr(_username!, _password!);

                        //might need to change to a failure msg
                        setState(() {
                          if (msg == false) {
                            _errMsg =
                                "Wrong username or password. Please try again.";
                            // ignore: unused_local_variable
                            final snackBar = SnackBar(
                              content: Text(_errMsg),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            );
                          }
                        });
                        final snackBar = SnackBar(
                          content: Text(_errMsg),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        if (msg == true) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Login"),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      child: const Text("Create Account"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _confKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String? _username;
  String? _password;
  String? _email;
  String? _confirmationCode;
  bool _confirmation = false;
  String _errorMsg = "";
  int _resendNotification = 0;

  // Future<Map<String, dynamic>?> registerUser(
  //   String username,
  //   String password,
  //   String email,
  // ) async {}

  // Future<bool> resendConfirmation(String username) async {

  // }

  // Future<bool> sendConfirmation(String code, String username) async {

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("login menu")),
      body: Center(
        child:
            !_confirmation
                ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text("Create Account"),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) => _email = value,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Login",
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) => _username = value,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Password",
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              onSaved: (value) => _password = value,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate())
                                  _formKey.currentState!.save();
                                // change
                                Future<bool> msg = user.registerUser(
                                  _username!,
                                  _password!,
                                  _email!,
                                );

                                setState(() {
                                  // ignore: unnecessary_null_comparison
                                  if (msg == false) {
                                    _errorMsg =
                                        "account invalid or doesn't exists";
                                  } else {
                                    //confirmation code switch
                                    _confirmation = true;
                                  }
                                });
                                final snackBar = SnackBar(
                                  content: Text(_errorMsg),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                );
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(snackBar);
                              },
                              child: const Text("Register"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                // ignore: dead_code
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _confKey,
                    child: Column(
                      children: [
                        const Text("Verification Code"),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "code",
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (value) => _confirmationCode = value,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_confKey.currentState!.validate()) {
                              _confKey.currentState!.save();
                            } else {
                              setState(() {
                                _errorMsg =
                                    "Verification code failed please try again!";
                              });
                              final snackBar = SnackBar(
                                content: Text(_errorMsg),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(snackBar);
                            }
                            try {
                              if (await user.confirmUser(
                                _username!,
                                _confirmationCode!,
                              )) {
                                print("user verified\nattempting login");
                                if (await user.LoginUsr(
                                  _username!,
                                  _password!,
                                )) {
                                  print("user loggedin successfully");
                                  setState(() => _errorMsg = "");
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                } else {
                                  throw Exception(
                                    "failed to login usr after confirmation",
                                  );
                                }
                              } else {
                                throw Exception("failed to confirm user");
                              }
                            } catch (e) {
                              print("ERR: $e");
                              setState(() {
                                _errorMsg = "invalid code please try again.";
                              });
                            }
                          },
                          child: const Text("Submit"),
                        ),
                        TextButton(
                          onPressed: () {
                            try {
                              user.resendConf(_username!);
                            } catch (e) {
                              setState(() {
                                _resendNotification += 1;
                                _errorMsg =
                                    "Failed to re-send code, attempt $_resendNotification";
                              });
                              final snackBar = SnackBar(
                                content: Text(_errorMsg),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(snackBar);
                            }
                          },
                          child: const Text("resend Code"),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
