import 'package:flutter/material.dart';
import 'package:flutter101/components/snackbar.dart';
import 'package:flutter101/screens/login/login.dart';
import 'package:flutter101/services/auth_service.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confpasswordController = TextEditingController();
  bool _buttonState = false;
  final _formKey = GlobalKey<FormState>();

  void _goMainPage(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _buttonState = true;
      });
      String status = await context.read<AuthService>().signUp(
          emailController.text,
          passwordController.text,
          fullNameController.text,
          'user');
      if (status == 'success') {
        await Navigator.pushNamed(context, '/');
      } else {
        CustomSnackBar(seconds: 4, text: status, type: 'error').show(context);
      }

      setState(() {
        _buttonState = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                    hintText: 'full name',
                    icon: Icon(
                      Icons.email_outlined,
                      color: Colors.deepPurple,
                    ),
                    labelText: "full name"),
                validator: (value) {
                  if (value!.isEmpty == true) {
                    return 'enter valid email id';
                  }
                },
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    hintText: 'example@example.com',
                    icon: Icon(
                      Icons.email_outlined,
                      color: Colors.deepPurple,
                    ),
                    labelText: "Email"),
                validator: (value) {
                  if (value?.contains('@') == false) {
                    return 'enter valid email id';
                  }
                },
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: passwordController,
                decoration: const InputDecoration(
                    hintText: 'password ',
                    icon: Icon(
                      Icons.password_outlined,
                      color: Colors.deepPurple,
                    ),
                    labelText: "Password"),
                validator: (value) {
                  if (value != null && value.length < 8) {
                    return 'password is too short';
                  }
                },
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: confpasswordController,
                decoration: const InputDecoration(
                    hintText: 'password ',
                    icon: Icon(
                      Icons.password_outlined,
                      color: Colors.deepPurple,
                    ),
                    labelText: "Confirm Password"),
                validator: (value) {
                  if (value != null && value.length < 8) {
                    return 'password is too short';
                  } else if (passwordController.text !=
                      confpasswordController.text) {
                    return 'password does not match';
                  }
                },
              ),
              const SizedBox(
                height: 50,
              ),
              signUpButton(context),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text('Already have account? Sign in'))
            ],
          ),
        ),
      ),
    ));
  }

  Material signUpButton(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(_buttonState ? 25 : 10),
      color: Colors.deepPurple,
      child: InkWell(
        onTap: () => _goMainPage(context),
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          child: _buttonState
              ? const Icon(
                  Icons.done,
                  color: Colors.white,
                )
              : Center(
                  child: Text(
                  "Sign Up",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      ?.copyWith(color: Colors.white),
                )),
          width: _buttonState ? 50 : 150,
          height: 50,
        ),
      ),
    );
  }
}
