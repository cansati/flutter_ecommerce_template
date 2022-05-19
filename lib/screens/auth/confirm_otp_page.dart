import 'dart:async';

import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/screens/intro_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class ConfirmOtpPage extends StatefulWidget {
  String phoneNumber;
  ConfirmOtpPage({required this.phoneNumber});

  @override
  _ConfirmOtpPageState createState() => _ConfirmOtpPageState();
}

class _ConfirmOtpPageState extends State<ConfirmOtpPage> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  bool _canResendClick = false;
  Timer? timer;
  Timer? timer1;
  int? secondsInt = 45;
  final snackBar = SnackBar(
    duration: Duration(seconds: 5),
    content: Text('The provided phone number is not valid'),
  );
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();
  TextEditingController pinCodeTextEditingController = TextEditingController();

  Widget otpBox(TextEditingController otpController) {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.8),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: SizedBox(
          width: 9,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextField(
              onChanged: (value) {},
              controller: otpController,
              decoration: InputDecoration(
                  border: InputBorder.none, contentPadding: EdgeInsets.zero),
              style: TextStyle(fontSize: 16.0),
              keyboardType: TextInputType.phone,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {

    controller = AnimationController(
      duration: Duration(seconds: 45),
      vsync: this,
    );
    setTimerAgain();
    sendSms();
    super.initState();
    controller?.forward();
    controller?.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller?.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller?.forward();
        }
      });

  }

  Future setSecondsTimer() async {
    timer1 = Timer.periodic(Duration(seconds: 1), (_) {
      if (!_canResendClick) {
        setState(() {
          if (secondsInt! > 0) secondsInt = secondsInt! - 1;
        });
      } else {
        timer1?.cancel();
      }
    });
    setSecondsTimer();
  }

  Future setTimerAgain() async {
    timer = Timer.periodic(Duration(seconds: 45), (_) {
      setState(() {
        _canResendClick = true;
      });
    });
    setSecondsTimer();
  }

  Future sendSms() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.currentUser!.updatePhoneNumber(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: pinCodeTextEditingController.text);

        try {
          await _auth.currentUser!.updatePhoneNumber(credential);
        } catch (e) {}
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      'Confirm your OTP',
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
          'Please wait, we are confirming your OTP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget verifyButton = Center(
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => IntroPage()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Verify",
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

/*    Widget otpCode = Container(
      padding: const EdgeInsets.only(right: 28.0),
      height: 190,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          otpBox(otp1),
          otpBox(otp2),
          otpBox(otp3),
          otpBox(otp4)
        ],
      ),
    );*/

    Widget resendText = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Resend again after ",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Color.fromRGBO(255, 255, 255, 0.5),
            fontSize: 14.0,
          ),
        ),
        InkWell(
          onTap: () async {
            if (_canResendClick) {
              setState(() {
                _canResendClick = false;
              });
              await setTimerAgain();
              await sendSms();
            }
          },
          child: Text(
            controller!.value.toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
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
                  padding: const EdgeInsets.only(left: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(flex: 3),
                      title,
                      Spacer(),
                      subTitle,
                      Spacer(flex: 1),
                      Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: Center(
                          child: PinCodeTextField(
                            controller: pinCodeTextEditingController,
                            highlightColor: Colors.white,
                            highlightAnimation: true,
                            highlightAnimationBeginColor: Colors.white,
                            highlightAnimationEndColor:
                                Theme.of(context).primaryColor,
                            pinTextAnimatedSwitcherDuration:
                                Duration(milliseconds: 500),
                            wrapAlignment: WrapAlignment.center,
                            hasTextBorderColor: Colors.transparent,
                            highlightPinBoxColor: Colors.white,
                            autofocus: true,
                            pinBoxHeight: MediaQuery.of(context).size.width / 8,
                            pinBoxWidth: MediaQuery.of(context).size.width / 8,
                            pinBoxRadius: 5,
                            defaultBorderColor: Colors.transparent,
                            pinBoxColor: Color.fromRGBO(255, 255, 255, 0.8),
                            maxLength: 6,
                          ),
                        ),
                      ),
                      Spacer(flex: 1),
//                      otpCode,
                      Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: verifyButton,
                      ),
                      Spacer(flex: 2),
                      resendText,
                      Spacer()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
