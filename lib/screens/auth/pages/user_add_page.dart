import 'package:flutter/cupertino.dart';
import 'package:rt_market/global/modal.dart';
import 'package:rt_market/models/sql/user.dart';
import 'package:rt_market/widgets/custom_dropdown.dart';

import '../../../index.dart';

class UserAddPage extends StatefulWidget {
  const UserAddPage({Key key}) : super(key: key);

  @override
  _UserAddPageState createState() => _UserAddPageState();
}

class _UserAddPageState extends State<UserAddPage> {
  final textNom = TextEditingController();
  final textUserName = TextEditingController();
  final textPass = TextEditingController();
  final textPhone = TextEditingController();
  String selectedRole;

  final textAuth = TextEditingController();

  List<User> users = [];
  Future<void> viewUsers() async {
    users.clear();
    var usersJsonDatas = await SqliteDbHelper.query(table: "users");
    if (usersJsonDatas.isNotEmpty) {
      usersJsonDatas.forEach((e) {
        setState(() {
          users.add(User.fromMap(e));
        });
      });
    }
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("création vendeurs"),
        actions: const [UserBox(color: Colors.deepPurpleAccent)],
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/market2.jpg"),
                fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(.85)),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    // ignore: deprecated_member_use
                    overflow: Overflow.visible,
                    children: [
                      Container(
                        height: 280.0,
                        width: _size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 12.0,
                                color: Colors.grey.withOpacity(.4),
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 40.0, bottom: 20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: InputText(
                                      title: "Nom complet",
                                      color: Colors.deepPurpleAccent,
                                      isRequired: true,
                                      controller: textNom,
                                      hintText:
                                          "Entrez le nom complet du vendeur...",
                                      icon: Icons.assignment_ind_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Flexible(
                                    child: InputText(
                                      color: Colors.deepPurpleAccent,
                                      title: "Nom d'utilisateur",
                                      controller: textUserName,
                                      isRequired: true,
                                      hintText:
                                          "Entrez le nom d'utilisateur du vendeur... ex: @gaston",
                                      icon: CupertinoIcons.person,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: InputText(
                                      title: "Mot de passe",
                                      color: Colors.deepPurpleAccent,
                                      isRequired: true,
                                      isPassword: true,
                                      controller: textPass,
                                      hintText:
                                          "Entrez le mot de passe de connexion du vendeur...",
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Flexible(
                                    child: Container(
                                      height: 50.0,
                                      width: _size.width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue[900],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: CustomDropdown(
                                        hintText:
                                            "Selectionnez un rôle d'utilisateur",
                                        items: const [
                                          "administrateur",
                                          "vendeur"
                                        ],
                                        selectedValue: selectedRole,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedRole = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60.0,
                                    width: 300.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton.icon(
                                      elevation: 10.0,
                                      color: Colors.green[700],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      onPressed: () => saveUser(context),
                                      icon: const Icon(Icons.add,
                                          color: Colors.white),
                                      label: Text(
                                        "Ajouter",
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Container(
                                    height: 60.0,
                                    width: 300.0,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton.icon(
                                      elevation: 10.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      color: Colors.grey,
                                      onPressed: () async {
                                        clean();
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 15.0,
                                      ),
                                      label: Text(
                                        "Annuler",
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -15,
                        right: -10,
                        child: Container(
                          height: 40.0,
                          // ignore: deprecated_member_use
                          child: RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            color: Colors.deepPurpleAccent,
                            onPressed: () async {
                              textAuth.text = "";
                              if (isExpanded) {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              } else {
                                Modal.show(
                                  context,
                                  height: 200.0,
                                  width: 500,
                                  icon: CupertinoIcons.lock_fill,
                                  title: "Authentification",
                                  modalContent: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Input(
                                        controller: textAuth,
                                        onPressed: () async {
                                          var logged =
                                              await SqliteDbHelper.rawQuery(
                                                  "SELECT * FROM users WHERE user_name='${sqlManagerController.loggedUser.value.userName}' AND user_pass='${textAuth.text}'");

                                          if (logged.isNotEmpty) {
                                            Get.back();
                                            setState(() {
                                              isExpanded = !isExpanded;
                                            });
                                            users.clear();
                                            await viewUsers();
                                          } else {
                                            Get.back();
                                            XDialog.showErrorMessage(
                                              context,
                                              color: Colors.amber[900],
                                              title:
                                                  "Echec de l'authentification !",
                                              message:
                                                  "vous n'avez pas le droit d'effectuer cette opération !",
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              (isExpanded)
                                  ? CupertinoIcons.square_arrow_up_fill
                                  : CupertinoIcons.square_arrow_down_fill,
                              color: Colors.white,
                            ),
                            label: Text(
                              (isExpanded) ? "Fermer" : "Afficher",
                              style: GoogleFonts.lato(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: -12,
                        left: -12,
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 12.0,
                                    color: Colors.grey.withOpacity(.4),
                                    offset: const Offset(0, 4))
                              ],
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurpleAccent,
                                  Colors.purple[900]
                                ],
                              )),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.person_add_solid,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  if (isExpanded) ...[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12.0,
                              color: Colors.grey.withOpacity(.4),
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Scrollbar(
                          hoverThickness: 10,
                          isAlwaysShown: true,
                          thickness: 10,
                          child: GridView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 3,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: users.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              var data = users[index];
                              return Stack(
                                children: [
                                  Container(
                                    width: _size.width,
                                    height: _size.height,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[500],
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 12.0,
                                          color: Colors.black.withOpacity(.1),
                                          offset: const Offset(0, 10),
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 150.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                              left: Radius.circular(10.0),
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.deepPurpleAccent,
                                                Colors.blue[400],
                                              ],
                                            ),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                                CupertinoIcons.person_fill),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Nom d'utilisateur",
                                              style: GoogleFonts.lato(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(data.userName,
                                                style: GoogleFonts.lato(
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                    fontSize: 18.0)),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Rôle utilisateur",
                                                      style: GoogleFonts.lato(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      data.userRole,
                                                      style: GoogleFonts.lato(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Colors.white,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 15.0,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Mot de passe",
                                                      style: GoogleFonts.lato(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      data.userPass,
                                                      style: GoogleFonts.lato(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 18.0,
                                                        color: Colors.amber,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: Container(
                                      child: Center(
                                        child: IconButton(
                                          onPressed: () {
                                            XDialog.show(
                                                context: context,
                                                icon: Icons.help,
                                                title: "Suppression",
                                                content:
                                                    "Etes-vous sûr de vouloir supprimer cet utilisateur ?",
                                                onValidate: () async {
                                                  if (users.length == 1) {
                                                    XDialog.showErrorMessage(
                                                        context,
                                                        color:
                                                            Colors.amber[800],
                                                        title: "Avertissemet",
                                                        message:
                                                            "vous ne pouvez pas supprimer tous les utilisateurs,\nAu moins un utilisateur est requis!");
                                                    return;
                                                  } else {
                                                    var lastDeletedUser =
                                                        await SqliteDbHelper
                                                            .delete(
                                                      tableName: "users",
                                                      where: "user_id",
                                                      whereArgs: [data.userId],
                                                    );

                                                    print(lastDeletedUser);
                                                    viewUsers();
                                                  }
                                                });
                                          },
                                          icon: const Icon(
                                            CupertinoIcons.trash,
                                            color: Colors.pink,
                                            size: 15.0,
                                          ),
                                        ),
                                      ),
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: BoxDecoration(
                                        color: Colors.pink[50],
                                        border: Border.all(color: Colors.pink),
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveUser(context) async {
    try {
      if (textNom.text.isEmpty) {
        Get.snackbar(
            "Avertissement !", "vous devez entrer le nom de l'utilisateur!",
            snackPosition: SnackPosition.TOP,
            colorText: Colors.redAccent[100],
            backgroundColor: Colors.black45,
            maxWidth: 1000,
            borderRadius: 2);
        return;
      }

      if (textUserName.text.isEmpty) {
        Get.snackbar("Avertissement !",
            "vous devez entrer le nom d'identification pour l'utilisateur!",
            snackPosition: SnackPosition.TOP,
            colorText: Colors.redAccent[100],
            backgroundColor: Colors.black45,
            maxWidth: 1000,
            borderRadius: 2);
        return;
      }
      if (textPass.text.isEmpty) {
        Get.snackbar("Avertissement !",
            "vous devez entrer le mot de passe l'utilisateur!",
            snackPosition: SnackPosition.TOP,
            colorText: Colors.redAccent[100],
            backgroundColor: Colors.black45,
            maxWidth: 1000,
            borderRadius: 2);
        return;
      }

      if (selectedRole == null) {
        Get.snackbar("Avertissement !",
            "vous devez sélectionner le rôle de l'utilisateur!",
            snackPosition: SnackPosition.TOP,
            colorText: Colors.redAccent[100],
            backgroundColor: Colors.black45,
            maxWidth: 1000,
            borderRadius: 2);
        return;
      }
      if (!textUserName.text.contains("@")) {
        XDialog.showErrorMessage(context,
            color: Colors.black54,
            message: "Le nom d'utilisateur doit commencer par '@' ",
            title: "@ obligatoire");
        return;
      }

      User user = User(
        userName: textUserName.text,
        userPass: textPass.text,
        userRole: selectedRole,
      );

      var lastInsertedUser = await SqliteDbHelper.insert(
        tableName: "users",
        values: user.toMap(),
      );
      print(lastInsertedUser);

      XDialog.showSuccessAnimation(context);
      await viewUsers();
      clean();
    } catch (err) {
      print("error from saving user statement $err");
    }
  }

  clean({String role}) {
    setState(() {
      textNom.text = "";
      textPass.text = "";
      textPhone.text = "";
      selectedRole = role;
      textUserName.text = "";
    });
  }
}

class Input extends StatelessWidget {
  final TextEditingController controller;
  final Function onPressed;
  const Input({
    this.controller,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.8),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Flexible(
            child: TextField(
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  fontSize: 18.0,
                  color: Colors.deepPurple[900],
                  fontWeight: FontWeight.w900),
              keyboardType: TextInputType.number,
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Entrez votre mot de passe",
                contentPadding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                hintStyle: GoogleFonts.lato(
                    color: Colors.grey[600],
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
          Container(
            height: 50.0,
            width: 100.0,
            // ignore: deprecated_member_use
            child: RaisedButton(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                ),
              ),
              color: Colors.deepPurpleAccent,
              child: const Icon(CupertinoIcons.lock_open_fill,
                  color: Colors.white),
              onPressed: onPressed,
            ),
          )
        ],
      ),
    );
  }
}
