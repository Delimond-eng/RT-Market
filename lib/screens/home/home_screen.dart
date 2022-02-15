import 'package:flutter/cupertino.dart';
import '../../index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("RT Market"),
        actions: const [
          UserBox(
            color: Colors.purple,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/market2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(.85)),
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                child: Container(
                  width: _size.width,
                  margin: const EdgeInsets.only(right: 30.0, left: 30.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: MenuBtn(
                          color: Colors.deepPurpleAccent,
                          icon: CupertinoIcons.person_badge_plus_fill,
                          title: "Création vendeurs",
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: const UserAddPage(),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      Flexible(
                        child: MenuBtn(
                          color: primaryColor,
                          icon: CupertinoIcons.bag_fill_badge_plus,
                          title: "Ajout produits",
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: const ProductAddPage(),
                                type: PageTransitionType.rightToLeftWithFade,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 40.0),
                      Flexible(
                        child: MenuBtn(
                          color: Colors.teal,
                          icon: CupertinoIcons.add,
                          title: "Ajout stock",
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: const StockAddPage(),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 40.0),
                      Flexible(
                        child: MenuBtn(
                          color: Colors.blue[900],
                          icon: CupertinoIcons.doc_chart_fill,
                          title: "Inventaire",
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                child: const InventoryPage(),
                                type: PageTransitionType.bottomToTop,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                return sqlManagerController.stocks.isEmpty
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12.0,
                              color: Colors.grey.withOpacity(.3),
                              offset: const Offset(0, 3),
                            ),
                          ],
                          color: Colors.blue[900],
                        ),
                        height: 60.0,
                        width: _size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date".toUpperCase(),
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "code produit".toUpperCase(),
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Produit".toUpperCase(),
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Entrées".toUpperCase(),
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sorties".toUpperCase(),
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Stock actuel".toUpperCase(),
                                      style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
              }),
              const StockViewer()
            ],
          )),
        ),
      ),
    );
  }
}
