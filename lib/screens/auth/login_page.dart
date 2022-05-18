import 'package:ecommerce_int2/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_int2/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ecommerce_int2/screens/main/main_page.dart';
import 'package:email_validator/email_validator.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _bottomMargin = 85.0;
  double _containerHeight = 140;
  final snackBar = SnackBar(
    duration: Duration(seconds: 5),
    content: Text('No user found!'),
  );

  final _auth = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    Widget welcomeBack = Text(
      'Welcome to eCommerce',
      style: TextStyle(
          color: Colors.white,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Login to your account using\nEmail address',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget loginButton = Positioned(
      right: (MediaQuery.of(context).size.width / 4) - 28,
      bottom: _bottomMargin,
      child: InkWell(
        onTap: () async {
          // TODO: Login with firebase or API
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => RegisterPage()));
          /*if (_formKey.currentState!.validate()) {
            try {
              await _auth.signInWithEmailAndPassword(
                  email: email.text, password: password.text);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => MainPage()));
            } catch (e) {
              if (e.toString() ==
                  '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.') {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }
          } else {
            setState(() {
              _bottomMargin = 40.0;
              _containerHeight = 190.0;
            });
          }*/
          /*Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => RegisterPage()));*/
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Log In",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(236, 60, 3, 1),
                    Color.fromRGBO(234, 60, 3, 1),
                    Color.fromRGBO(216, 78, 16, 1),
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget loginForm = Container(
      height: 290,
      child: Stack(
        children: <Widget>[
          Container(
            height: _containerHeight,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 25.0, right: 20.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter an email address';
                        } else if (!EmailValidator.validate(value)) {
                          return "Enter a valid email address";
                        }
                      },
                      decoration: new InputDecoration(hintText: 'E-mail'),
                      controller: email,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Alan boş olamaz";
                        } else if (value.length < 6) {
                          return "Parola 6 karakterden kısa olamaz";
                        } else if (value.length > 30) {
                          return "Parola 30 karakterden uzun olamaz";
                        }
                      },
                      decoration: new InputDecoration(
                          hintText: 'Password',
                          suffixIcon: _obscurePassword
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscurePassword = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.visibility_off_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscurePassword = true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.visibility_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                )),
                      controller: password,
                      style: TextStyle(fontSize: 16.0),
                      obscureText: _obscurePassword,
                    ),
                  ),
                ],
              ),
            ),
          ),
          loginButton,
        ],
      ),
    );

    Widget forgotPassword = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Forgot your password? ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Text(
              'Reset password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.jpg'),
                      fit: BoxFit.cover)),
            ),
            Container(
              decoration: BoxDecoration(
                color: transparentYellow,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28.0, right: 28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Spacer(flex: 3),
                  welcomeBack,
                  Spacer(),
                  subTitle,
                  Spacer(flex: 2),
                  loginForm,
                  Spacer(flex: 2),
                  forgotPassword
                ],
              ),
            )
          ],
        ));
  }
}
