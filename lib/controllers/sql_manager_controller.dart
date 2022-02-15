import 'package:get/get.dart';
import 'package:rt_market/models/sql/stock.dart';
import 'package:rt_market/models/sql/unite.dart';
import 'package:rt_market/models/sql/user.dart';

import '../index.dart';

class SqlManagerController extends GetxController {
  static SqlManagerController instance = Get.find();

  var loggedUser = User().obs;

  var stocks = <Stocks>[].obs;
  var unites = <Unite>[].obs;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  initData() async {
    stocks.clear();
    unites.clear();
    try {
      var stocksJsonData = await SqliteDbHelper.rawQuery(
          "SELECT * FROM stocks INNER JOIN produits ON stocks.produit_id = produits.produit_id");

      stocksJsonData.forEach((e) {
        stocks.add(Stocks.fromMap(e));
      });
      var uniteJsonData = await SqliteDbHelper.query(table: "unites");
      uniteJsonData.forEach((e) {
        unites.add(Unite.fromMap(e));
      });
    } catch (e) {
      print("error from init data ::=> $e");
    }
  }
}
