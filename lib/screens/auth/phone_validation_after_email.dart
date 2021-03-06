import 'dart:async';

import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/screens/auth/verify_email_notify_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'confirm_otp_page.dart';

class PhoneValidationAfterEmail extends StatefulWidget {
  @override
  _PhoneValidationAfterEmailState createState() =>
      _PhoneValidationAfterEmailState();
}

class _PhoneValidationAfterEmailState extends State<PhoneValidationAfterEmail> {
  TextEditingController phoneNumber = TextEditingController();
  Timer? timer;
  final _auth = FirebaseAuth.instance;
  GlobalKey prefixKey = GlobalKey();
  double prefixWidth = 0;
  bool _isEmailVerified = false;
  String? countryCode;

  Widget prefix() {
    return Container(
        key: prefixKey,
        //padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0),
        margin: EdgeInsets.only(right: 4.0),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black, width: 0.5))),
        child: CountryCodePicker(
          onInit: (code) {
            countryCode = code!.dialCode;
          },
          onChanged: (code) {
            countryCode = code!.dialCode;
          },
          initialSelection: 'TR',
          favorite: ['+1', 'US'],
        ));
  }

  Future sendVerificationEmail() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } catch (e) {}
  }

  @override
  void initState() {
    print("1");
    print(_isEmailVerified);
    _isEmailVerified = _auth.currentUser!.emailVerified;
    print("2");
    print(_isEmailVerified);
    if (!_isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await _auth.currentUser!.reload();
    setState(() {
      print("3");
      print(_isEmailVerified);
      _isEmailVerified = _auth.currentUser!.emailVerified;
    });
    if (_isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Widget background = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/background.jpg'), fit: BoxFit.cover),
      ),
      foregroundDecoration: BoxDecoration(color: transparentYellow),
    );

    Widget title = Text(
      'Forgot your Password?',
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
          'Enter your registered mobile number to get the OTP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget sendButton = Positioned(
      left: (MediaQuery.of(context).size.width / 4) - 28,
      bottom: 40,
      child: InkWell(
        onTap: () {
          if (phoneNumber.text.isNotEmpty) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ConfirmOtpPage(
                      phoneNumber: '$countryCode${phoneNumber.text}',
                    )));
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Send OTP",
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

    Widget phoneForm = Container(
      height: 210,
      child: Stack(
        children: <Widget>[
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0, bottom: 30),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                prefix(),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                      controller: phoneNumber,
                      style: TextStyle(fontSize: 16.0),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
              ],
            ),
          ),
          sendButton,
        ],
      ),
    );

    Widget thisPagesDesign = GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.jpg'), fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(color: transparentYellow),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(flex: 1),
                      title,
                      Spacer(),
                      subTitle,
                      Spacer(flex: 1),
                      phoneForm,
                      Spacer(flex: 3),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

    return _isEmailVerified
        ? thisPagesDesign
        : VerifyEmailNotifyPage(
            resent: sendVerificationEmail,
          );
  }
}
