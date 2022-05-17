import 'package:ecommerce_int2/app_properties.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'forgot_password_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  double _buttonMargin = 65;
  double _containerHeight = 200;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cmfPassword = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      'Glad To Meet You',
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
          'Create your new account for future uses.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget registerButton = Positioned(
      left: (MediaQuery.of(context).size.width / 4) - 28,
      bottom: _buttonMargin,
      child: InkWell(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            //TODO: implement firebase register functionality

            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
          } else {
            setState(() {
              _buttonMargin = 0.0;
              _containerHeight = 260.0;
            });
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Register",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: mainButton,
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

    Widget registerForm = Container(
      height: 330,
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
                      decoration: new InputDecoration(hintText: 'Password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a password";
                        } else if (value.length < 6) {
                          return "Password must be longer than 6 characters";
                        } else if (value.length > 30) {
                          return "Password must be less than 30 characters";
                        }
                      },
                      controller: password,
                      style: TextStyle(fontSize: 16.0),
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a password";
                        } else if (value.length < 6) {
                          return "Password must be longer than 6 characters";
                        } else if (value.length > 30) {
                          return "Password must be less than 30 characters";
                        } else if (password.text != value) {
                          return "Passwords are not matching";
                        }
                      },
                      decoration:
                          new InputDecoration(hintText: 'Confirm Password'),
                      controller: cmfPassword,
                      style: TextStyle(fontSize: 16.0),
                      obscureText: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          registerButton,
        ],
      ),
    );

    Widget socialRegister = Column(
      children: <Widget>[
        Text(
          'You can sign in with',
          style: TextStyle(
              fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.find_replace),
              onPressed: () {},
              color: Colors.white,
            ),
            IconButton(
                icon: Icon(Icons.find_replace),
                onPressed: () {},
                color: Colors.white),
          ],
        )
      ],
    );

    return Scaffold(
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 3),
                title,
                Spacer(),
                subTitle,
                Spacer(flex: 2),
                registerForm,
                Spacer(flex: 2),
                Padding(
                    padding: EdgeInsets.only(bottom: 20), child: socialRegister)
              ],
            ),
          ),
          Positioned(
            top: 35,
            left: 5,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
