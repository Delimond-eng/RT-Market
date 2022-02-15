import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

import '../index.dart';

class Xloading {
  static dismiss() {
    Get.back();
  }

  static showLottieLoading(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black26,
        context: context,
        useRootNavigator: true,
        builder: (BuildContext context) {
          return Center(
            child: SingleChildScrollView(
              child: Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: Container(
                    width: 100,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: const SpinKitFadingCircle(
                            color: Colors.blue,
                            size: 100.0,
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          );
        });
  }

  static show(context, String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: primaryColor.withOpacity(.8),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ignore: prefer_const_constructors
              CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
              if (title.isNotEmpty)
                const SizedBox(
                  width: 10,
                ),
              Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  )),
            ],
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 10), () {
      Get.back();
    });
  }
}

//attribution_sharp

class XDialog {
  static show(
      {BuildContext context,
      title,
      content,
      Function onValidate,
      Function onCancel,
      IconData icon}) {
    // set up the buttons
    // ignore: deprecated_member_use
    Widget cancelButton = FlatButton(
      child: Text(
        "Annuler".toUpperCase(),
        style: GoogleFonts.mulish(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            letterSpacing: 1.0,
            color: Colors.red[300]),
      ),
      onPressed: onCancel ?? () => Get.back(),
    );
    // ignore: deprecated_member_use
    Widget continueButton = FlatButton(
      child: Text(
        "Valider".toUpperCase(),
        style: GoogleFonts.mulish(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            letterSpacing: 1.0,
            color: Colors.green[900]),
      ),
      onPressed: () {
        Get.back();
        Future.delayed(const Duration(microseconds: 500));
        onValidate();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.amber[800]),
          // ignore: prefer_const_constructors
          SizedBox(
            width: 5,
          ),
          Text("$title"),
        ],
      ),
      content: Text("$content"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showSuccessMessage(context, {title, message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white12,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green[400],
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "$title",
                style: GoogleFonts.mulish(color: Colors.white),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              message,
              style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  color: Colors.white),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 4), () {
      Get.back();
    });
  }

  static showSuccessAnimation(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white12,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white38,
          elevation: 0,
          contentPadding: const EdgeInsets.all(8.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            color: Colors.transparent,
            width: 200.0,
            height: 200.0,
            child: Lottie.asset("assets/lotties/17828-success.json",
                width: 150.0,
                height: 150.0,
                alignment: Alignment.center,
                animate: true,
                repeat: false,
                fit: BoxFit.cover),
          )),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      Get.back();
    });
  }

  static showErrorAnimation(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white12,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          content: SingleChildScrollView(
              child: Container(
            padding: const EdgeInsets.all(20.0),
            alignment: Alignment.center,
            width: 200.0,
            height: 200.0,
            child: Lottie.asset("assets/lotties/32889-error-message.json",
                width: 150.0,
                height: 150.0,
                alignment: Alignment.center,
                animate: true,
                repeat: false,
                fit: BoxFit.cover),
          )),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      Get.back();
    });
  }

  static showErrorMessage(context, {title, message, color}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: color ?? Colors.red[300],
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "$title",
                style: GoogleFonts.mulish(color: Colors.white),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              message,
              style: GoogleFonts.mulish(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  color: Colors.white),
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
    });
  }
}

class Modal {
  static void show(context,
      {String title,
      Widget modalContent,
      double height,
      double width,
      IconData icon,
      double radius}) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.white10,
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        (radius != null) ? radius : 5)), //this right here
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: height,
                      width: width ?? MediaQuery.of(context).size.width / 1.50,
                      child: Stack(children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 50.0, left: 10, right: 10, bottom: 5),
                            child: modalContent),
                        Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.purple[900],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          (radius != null) ? radius : 5),
                                      topRight: Radius.circular(
                                          (radius != null) ? radius : 5))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        icon ?? Icons.circle,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        title,
                                        style: GoogleFonts.mulish(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            shadows: [
                                              const Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 1.50))
                                            ]),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    // ignore: prefer_const_constructors
                                    icon: Icon(
                                      CupertinoIcons.clear_circled_solid,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  )
                                ],
                              ),
                            ))
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
