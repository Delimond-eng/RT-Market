import 'package:mongo_dart/mongo_dart.dart';
import 'package:rt_market/models/stock_model.dart';

class Produit {
  ObjectId produitId;
  String produitTitre;
  String produitImage;
  String produitCode;
  String produitUnite;
  String produitDateExp;
  String produitStatus;
  List<Stock> stock;

  Produit(
      {this.produitId,
      this.produitTitre,
      this.produitImage,
      this.produitCode,
      this.produitUnite,
      this.produitDateExp,
      this.produitStatus,
      this.stock});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    produitId = ObjectId();
    data["_id"] = produitId;
    data["produit_titre"] = produitTitre;
    data["produit_image"] = produitImage;
    data["produit_code"] = produitCode;
    data["produit_date_exp"] = produitDateExp;
    data["produit_status"] = produitStatus;

    if (produitUnite != null) {
      data["produit_unite"] = produitUnite;
    }
    if (stock != null) {
      data['stock'] = stock.map((v) => v.toMap()).toList();
    }
    return data;
  }

  Produit.fromMap(Map<String, dynamic> map) {
    produitId = ObjectId.fromHexString(map["_id"]);
    produitTitre = map["produit_titre"];
    produitImage = map["produit_image"];
    produitCode = map["produit_code"];
    produitDateExp = map["produit_date_exp"];
    produitStatus = map["produit_status"];
    if (map["produit_unite"] != null) {
      produitUnite = map["produit_unite"];
    }
    if (map["stock"] != null) {
      stock = new List<Stock>();
      map["stock"].forEach(
        (s) {
          stock.add(Stock.fromMap(s));
        },
      );
    }
  }
}
