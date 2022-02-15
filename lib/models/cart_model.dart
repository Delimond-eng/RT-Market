import 'package:rt_market/index.dart';

class Cart {
  String productName;
  String productImage;
  int productPrice;
  String productId;
  TextEditingController controller = TextEditingController();
  TextEditingController unite = TextEditingController();
  int stock;

  int get total => int.parse(controller.text) * productPrice;
  int get quantity => int.parse(controller.text);

  Cart({
    this.productName,
    this.productImage,
    this.productPrice,
    this.productId,
    this.stock,
  });
}
