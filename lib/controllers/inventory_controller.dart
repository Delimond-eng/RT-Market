import 'dart:convert';

import 'package:rt_market/index.dart';
import 'package:rt_market/models/inventory_model.dart';

class InventoryController extends GetxController {
  static InventoryController instance = Get.find();
  // ignore: deprecated_member_use, prefer_collection_literals
  RxList<Inventory> inventories = List<Inventory>().obs;
  RxInt currentTotal = 0.obs;
  RxInt currentItemsVenduQte = 0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshDatas();
  }

  Future<void> refreshDatas() async {
    try {
      var list = await DBHelper.inventories();
      if (list != null) {
        var json = jsonEncode(list);
        Iterable i = jsonDecode(json);
        List<Inventory> data =
            List<Inventory>.from(i.map((model) => Inventory.fromMap(model)));
        if (data.isEmpty || data == null) {
          inventories.value = [];
        } else {
          inventories.value = data;
          int currentTt = 0;
          int currentSellQty = 0;
          inventories.forEach((i) {
            currentTt += i.totalVentes;
            currentSellQty += i.stockSorty;
          });
          currentTotal.value = currentTt;
          currentItemsVenduQte.value = currentSellQty;
        }
      }
    } catch (err) {
      print("error from inventory refreshing data $err");
    }
  }
}
