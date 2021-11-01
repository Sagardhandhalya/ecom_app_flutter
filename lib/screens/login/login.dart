import 'package:flutter/material.dart';
import 'package:flutter101/components/snackbar.dart';
import 'package:flutter101/screens/signup/signup.dart';
import 'package:flutter101/services/auth_service.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _buttonState = false;
  final _formKey = GlobalKey<FormState>();

  void _goMainPage(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _buttonState = true;
      });
      String status = await context
          .read<AuthService>()
          .signIn(emailController.text, passwordController.text);
      if (status == 'success') {
        // await Navigator.pushNamed(context, '/');
      } else {
        CustomSnackBar(seconds: 4, text: status, type: 'error').show(context);
        setState(() {
          _buttonState = false;
        });
      }
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
                    labelText: "password"),
                validator: (value) {
                  if (value != null && value.length < 8) {
                    return 'password is too short';
                  }
                },
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 50,
              ),
              loginButton(context),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUp()));
                  },
                  child: const Text('Do not have account? create one. ')),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.red, // inkwell color
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                                'http://pngimg.com/uploads/google/google_PNG19635.png',
                                fit: BoxFit.cover)),
                        onTap: () async {
                          await Provider.of<AuthService>(context, listen: false)
                              .signInwithGoogle();
                          Navigator.pushReplacementNamed(context, 'home');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ClipOval(
                    child: Material(
                      color: Colors.white, // button color
                      child: InkWell(
                        splashColor: Colors.red, // inkwell color
                        child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                                'https://www.citypng.com/public/uploads/small/115959785735k3xem706hpfn8xbwxmxvniimtfuxtbng596dmpcylbi7ckrlbew28e6oodqlocogsjo8hg0g5j2ofx0km0lu1ynotna9tsu5xdk.png',
                                fit: BoxFit.cover)),
                        onTap: () async {
                          String? result = await Provider.of<AuthService>(
                                  context,
                                  listen: false)
                              .signInwithFacebook();
                          if (result != 'success') {
                            CustomSnackBar(
                                    seconds: 2,
                                    text: result.toString(),
                                    type: 'error')
                                .show(context);
                          } else {
                            Navigator.pushReplacementNamed(context, 'home');
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Material loginButton(BuildContext context) {
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
                  "Login",
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
