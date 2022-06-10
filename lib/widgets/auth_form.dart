import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Future Function(
      String email, String password, String username, bool isLogin) onSubmit;
  const AuthForm(this.onSubmit, {Key? key}) : super(key: key);
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _username = "";
  var _email = "";
  var _password = "";
  var _isLogin = true;
  var _isLoading = false;
  void _attemptLogin() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      widget
          .onSubmit(
        _email.trim(),
        _password.trim(),
        _username.trim(),
        _isLogin,
      )
          .whenComplete(() {
        setState(() {
          if (mounted) {
            _isLoading = false;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const ValueKey('email'),
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter an Email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter a username";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a Password";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _attemptLogin,
                          child: _isLogin
                              ? const Text("Log In")
                              : const Text("Sign Up")),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: !_isLogin
                        ? const Text("Switch to Log In")
                        : const Text("Switch to Sign Up"),
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
