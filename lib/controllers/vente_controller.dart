import 'dart:async';

import 'package:rt_market/index.dart';
import 'package:rt_market/models/cart_model.dart';

class VenteController extends GetxController {
  static VenteController instance = Get.find();

  // ignore: deprecated_member_use, prefer_collection_literals
  var cartList = List<Cart>().obs;

  var cartTotal = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initCartTotal();
  }

  Future<void> addItemToCart({String productId}) async {
    var products = dbManagerController.productList;

    var product = products.where((s) => s.produitCode.contains(productId));
    for (var item in product) {
      Cart cart = Cart(
        productId: item.produitId.toHexString(),
        productName: item.produitTitre,
        productImage: item.produitImage,
        productPrice: item.stock[0].stockProduitPrixUnitaire,
        stock: item.stock[0].stockQte,
      );
      cartList.add(cart);
      initCartTotal();
    }
  }

  Future<void> removeItemTocart({String productId}) async {
    cartList.removeWhere((el) => el.productId == productId);
    initCartTotal();
  }

  Future<void> initCartTotal() async {
    var totalCount = streamCounter();
    totalCount.listen((updatedTotal) {
      cartTotal.value = updatedTotal ?? 0;
    });
  }

  Stream<int> streamCounter() async* {
    int total = 0;
    var controller = StreamController<int>();
    Future.delayed(const Duration(milliseconds: 500), () {
      cartList.forEach((element) {
        int t = element.total;
        total += t;
      });
      controller.add(total);
    });

    yield* controller.stream;
  }

  Future<void> cancelCartProcess() async {
    cartList.clear();
    cartTotal.value = 0;
  }
}
