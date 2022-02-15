import 'package:rt_market/global/controllers.dart';

class Product {
  int produitId;
  String produitCode;
  String produitLibelle;
  String produitPhoto;
  String produitDateExp;
  String produitPrix;
  int uniteId;
  String uniteLibelle;
  int userId;
  Product({
    this.produitId,
    this.produitCode,
    this.produitLibelle,
    this.produitPhoto,
    this.produitDateExp,
    this.produitPrix,
    this.uniteId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (produitId != null) {
      data["produit_id"] = produitId;
    }
    if (produitCode != null) {
      data["produit_code"] = produitCode;
    }
    if (produitLibelle != null) {
      data["produit_libelle"] = produitLibelle;
    }
    if (produitPhoto != null) {
      data["produit_photo"] = produitPhoto;
    }
    if (produitDateExp != null) {
      data["produit_date_exp"] = produitDateExp;
    }
    if (produitPrix != null) {
      data["produit_prix"] = produitPrix;
    }
    data["user_id"] = sqlManagerController.loggedUser.value.userId;
    if (uniteId != null) {
      data["unite_id"] = uniteId;
    }

    return data;
  }

  Product.fromMap(Map<String, dynamic> map) {
    produitId = map["produit_id"];
    produitCode = map["produit_code"];
    produitLibelle = map["produit_libelle"];
    produitPhoto = map["produit_photo"];
    produitDateExp = map["produit_date_exp"];
    if (map["unite_id"] != null) {
      uniteId = map["unite_id"];
      uniteLibelle = map["unite_libelle"];
    }
    if (map["user_id"] != null) {
      userId = map["user_id"];
    }
  }
}
