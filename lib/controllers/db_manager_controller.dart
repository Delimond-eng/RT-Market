import 'dart:convert';

import 'package:rt_market/index.dart';

class DBManagerController extends GetxController {
  static DBManagerController instance = Get.find();

  // ignore: deprecated_member_use, prefer_collection_literals
  var userList = List<Vendeur>().obs;

  // ignore: deprecated_member_use, prefer_collection_literals
  var productList = List<Produit>().obs;

  var logUser = Vendeur().obs;

  @override
  void onInit() {
    super.onInit();
    getDatas();
  }

  Future<void> getDatas() async {
    try {
      await DBHelper.mongoGetAll(collectionName: 'utilisateurs').then((list) {
        var json = jsonEncode(list);
        Iterable i = jsonDecode(json);
        List<Vendeur> users =
            List<Vendeur>.from(i.map((model) => Vendeur.fromMap(model)));
        userList.value = users;
      });

      await DBHelper.getInnerProductStock().then(
        (list) {
          var json = jsonEncode(list);
          Iterable i = jsonDecode(json);
          List<Produit> p =
              List<Produit>.from(i.map((model) => Produit.fromMap(model)));
          if (p.isEmpty || p == null) {
            productList.value = [];
          } else {
            productList.value = p;
          }
        },
      );
    } catch (err) {
      print("error from mongo getData $err");
    }
  }
}
