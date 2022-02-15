import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:rt_market/global/modal.dart';

import '../index.dart';

class UserBox extends StatelessWidget {
  final Color color;
  const UserBox({
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Container(
        margin: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
        height: 50.0,
        padding: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.6),
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 50.0,
              width: 45.0,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(.4),
                        blurRadius: 12.0,
                        offset: const Offset(0, 3))
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(
                    CupertinoIcons.person,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Obx(() {
              return Container(
                height: 50.0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sqlManagerController.loggedUser.value.userName,
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 16.0,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        sqlManagerController.loggedUser.value.userRole,
                        style: GoogleFonts.lato(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      onSelected: (value) {
        switch (value) {
          case 1:
            XDialog.show(
              icon: Icons.logout,
              context: context,
              content:
                  "Etes-vous sûr de vouloir vous déconnecter de votre compte ?",
              title: "Déconnexion",
              onValidate: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                        child: const AuthScreen(),
                        type: PageTransitionType.bottomToTop),
                    (route) => false);
              },
            );
            break;
          case 2:
            XDialog.show(
              icon: Icons.clear,
              context: context,
              content: "Etes-vous sûr de vouloir fermer l'application ?",
              title: "Fermeture",
              onValidate: () {
                exit(0);
              },
            );
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 1,
            child: Row(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                  child: Icon(
                    Icons.exit_to_app,
                    size: 20,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'Déconnexion',
                  style:
                      GoogleFonts.mulish(color: Colors.black54, fontSize: 14.0),
                )
              ],
            )),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: Colors.black54,
                ),
              ),
              Text(
                "Quitter",
                style:
                    GoogleFonts.mulish(color: Colors.black54, fontSize: 14.0),
              )
            ],
          ),
        ),
      ],
    );
  }
}
