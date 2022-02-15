import 'package:flutter/cupertino.dart';
import 'package:rt_market/global/modal.dart';
import 'package:rt_market/models/sql/unite.dart';
import 'package:rt_market/models/sql/user.dart';

import '../../index.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final textUserName = TextEditingController();
  final textPwd = TextEditingController();
  @override
  void initState() {
    super.initState();
    DBHelper.onCreateDb();
    createDefaultUser();
    createDefaultUnites();
  }

  Future<void> createDefaultUser() async {
    var users = await SqliteDbHelper.query(table: "users");

    if (users.isEmpty) {
      User user1 = User(
          userName: "@administrateur", userRole: "admin", userPass: "12345");
      User user2 =
          User(userName: "@vendeur", userRole: "vendeur", userPass: "12345");
      var lastInsertedUser = await SqliteDbHelper.insert(
        tableName: "users",
        values: user1.toMap(),
      );
      lastInsertedUser = await SqliteDbHelper.insert(
        tableName: "users",
        values: user2.toMap(),
      );
      print(lastInsertedUser);
    }
  }

  Future<void> createDefaultUnites() async {
    var unites = await SqliteDbHelper.query(table: "unites");
    if (unites.isEmpty) {
      Unite u1 = Unite(uniteLibelle: "G");
      Unite u2 = Unite(uniteLibelle: "KG");
      var unite1 =
          await SqliteDbHelper.insert(tableName: "unites", values: u1.toMap());
      var unite2 =
          await SqliteDbHelper.insert(tableName: "unites", values: u2.toMap());
    }
  }

  Future<void> login(context) async {
    if (textUserName.text.isEmpty) {
      Get.snackbar("Avertissement !",
          "vous devez entrer le nom d'utilisateur pour vous connecter! ex. @xxxxxx",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.redAccent[100],
          backgroundColor: Colors.black45,
          maxWidth: 1000,
          borderRadius: 2,);
      return;
    }

    if (textPwd.text.isEmpty) {
      Get.snackbar("Avertissement !",
          "vous devez entrer le mot de passe de l'utilisateur pour vous connecter!",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.redAccent[100],
          backgroundColor: Colors.black45,
          maxWidth: 1000,
          borderRadius: 2);
      return;
    }
    Vendeur user = Vendeur(
      vendeurUtilisateur: textUserName.text,
      vendeurMotDePasse: textPwd.text,
    );

    Xloading.showLottieLoading(context);
    try {
      await Future.delayed(const Duration(seconds: 1));
      User currentUser = User(
        userName: textUserName.text,
        userPass: textPwd.text,
      );
      var loggedUser = await SqliteDbHelper.rawQuery(
          "SELECT * FROM users WHERE user_name='${currentUser.userName}' AND user_pass='${currentUser.userPass}'");
      Xloading.dismiss();
      if (loggedUser.isNotEmpty) {
        User parsedUser = User.fromMap(loggedUser[0]);
        await sqlManagerController.initData();
        sqlManagerController.loggedUser.value = parsedUser;
        if (parsedUser.userRole.contains("admin")) {
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const HomeScreen(), type: PageTransitionType.fade),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(child: VentePage(), type: PageTransitionType.fade),
            (route) => false,
          );
        }
      } else {
        XDialog.showErrorMessage(
          context,
          color: Colors.black87,
          title: "Erreur",
          message: "Mot de passe ou nom d'utilisateur invalide !",
        );
        return;
      }

      /*await DBHelper.loginUser(find: user).then((result) {
        if (result != null) {
          var json = jsonEncode(result);
          Iterable i = jsonDecode(json);
          List<Vendeur> users =
              List<Vendeur>.from(i.map((model) => Vendeur.fromMap(model)));
          dbManagerController.logUser.value = users[0];
          if (users[0].vendeurRole == "admin") {
            Xloading.dismiss();
            dbManagerController.getDatas();
            
          } else {
            dbManagerController.getDatas();
            inventoryController.refreshDatas();
            Xloading.dismiss();
            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(child: VentePage(), type: PageTransitionType.fade),
              (route) => false,
            );
          }
        } else {
         
        }
      });*/
    } catch (err) {
      print(err);
      Xloading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/app.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(.8)),
          child: Center(
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                // ignore: deprecated_member_use
                overflow: Overflow.visible,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: 500.0,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        // ignore: prefer_const_literals_to_create_immutables
                        boxShadow: [
                          const BoxShadow(
                              color: Colors.black38,
                              blurRadius: 12.0,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 60.0, left: 20.0, right: 20.0, bottom: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AuthInput(
                              hintText: "nom d'utilisateur ex. @utilisateur",
                              icon: CupertinoIcons.person,
                              controller: textUserName,
                              keyType: TextInputType.text,
                              isPassWord: false,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            AuthInput(
                              hintText: "Mot de passe",
                              controller: textPwd,
                              icon: CupertinoIcons.lock,
                              isPassWord: true,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            // ignore: deprecated_member_use
                            Container(
                              height: 60.0,
                              width: MediaQuery.of(context).size.width,
                              // ignore: deprecated_member_use
                              child: RaisedButton.icon(
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                splashColor: Colors.purple[100],
                                elevation: 10.0,
                                onPressed: () => login(context),
                                icon: const Icon(
                                  Icons.arrow_right_alt_rounded,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "CONNECTER",
                                  style: GoogleFonts.mulish(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -40,
                    left: 10,
                    right: 10,
                    child: Container(
                      height: 80.0,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        shadowColor: Colors.black87,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              "AUTHENTIFICATION",
                              style: GoogleFonts.lato(
                                  color: primaryColor,
                                  fontSize: 18.0,
                                  shadows: [
                                    Shadow(
                                        blurRadius: 12.0,
                                        color: Colors.grey.withOpacity(.4),
                                        offset: const Offset(0, 3))
                                  ],
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.50),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
