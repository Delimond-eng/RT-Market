import '../index.dart';

class Product {
  const Product(
      {this.unite, this.n, this.productName, this.price, this.quantity});

  final int n;
  final String productName;
  final double price;
  final int quantity;
  final String unite;
  double get total => price * quantity;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return n.toString();
      case 1:
        return productName;
      case 2:
        return formatCurrency(price);
      case 3:
        return quantity.toString();
      case 4:
        return unite ?? "";
      case 5:
        return formatCurrency(total);
    }
    return '';
  }
}
