import 'package:mongo_dart/mongo_dart.dart';

class Stock {
  ObjectId stockId;
  ObjectId stockProduitId;
  ObjectId userId;
  int stockProduitPrixUnitaire;
  String stockPrixDevise;
  int stockQte;
  int stockEntree;
  int stockSortie;
  String stockDate;
  String stockUpdateDate;
  String stockStatus;
  Stock({
    this.stockId,
    this.userId,
    this.stockProduitId,
    this.stockProduitPrixUnitaire,
    this.stockPrixDevise,
    this.stockQte,
    this.stockEntree,
    this.stockSortie,
    this.stockDate,
    this.stockStatus,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    stockId = ObjectId();
    userId = ObjectId();
    data["_id"] = stockId;
    data["stock_user_id"] = userId;
    data["stock_produit_id"] = stockProduitId;
    data["stock_produit_pu"] = stockProduitPrixUnitaire;
    data["stock_prix_devise"] = stockPrixDevise;
    data["stock_qte"] = stockQte;
    data["stock_entrees"] = stockEntree;
    data["stock_sorties"] = stockSortie;
    data["stock_date"] = stockDate;
    data["stock_status"] = stockStatus;

    return data;
  }

  Stock.fromMap(Map<String, dynamic> map) {
    stockId = ObjectId.fromHexString(map["_id"]);
    userId = ObjectId.fromHexString(map["stock_user_id"]);
    stockProduitId = ObjectId.fromHexString(map["stock_produit_id"]);
    stockProduitPrixUnitaire = map["stock_produit_pu"];
    stockPrixDevise = map["stock_prix_devise"];
    stockQte = map["stock_qte"];
    stockEntree = map["stock_entrees"];
    stockSortie = map["stock_sorties"];
    stockDate = map["stock_date"];
    stockStatus = map["stock_status"];
  }
}
