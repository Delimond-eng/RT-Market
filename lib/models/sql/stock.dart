import 'package:rt_market/global/controllers.dart';
import 'package:rt_market/global/style.dart';

class Stocks {
  int stockId;
  int stockQteEntree;
  int stockQteSortie;
  String stockDateRef;

  //unite
  int uniteId;
  String uniteLibelle;
  //produit
  int produitId;
  String produitLibelle;
  String produitCode;
  String produitPhoto;
  String produitPrix;
  int userId;
  Stocks({
    this.stockId,
    this.stockQteEntree,
    this.stockQteSortie,
    this.stockDateRef,
    this.uniteId,
    this.produitId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (stockId != null) {
      data["stock_id"] = stockId;
    }
    data["stock_date_ref"] = dateFromString(DateTime.now());
    if (stockQteEntree != null) {
      data["stock_qte_entree"] = stockQteEntree;
    }
    if (stockQteSortie != null) {
      data["stock_qte_sortie"] = stockQteSortie;
    }
    data["user_id"] = sqlManagerController.loggedUser.value.userId;

    if (uniteId != null) {
      data["unite_id"] = uniteId;
    }
    if (produitId != null) {
      data["produit_id"] = produitId;
    }
    return data;
  }

  Stocks.fromMap(Map<String, dynamic> map) {
    stockId = map["stock_id"];
    stockQteEntree = map["stock_qte_entree"];
    stockQteSortie = map["stock_qte_sortie"];
    stockDateRef = map["stock_date_ref"];
    if (map["unite_id"] != null) {
      uniteId = map["unite_id"];
      uniteLibelle = map["unite_libelle"];
    } else {
      uniteLibelle = "";
    }
    if (map["produit_id"] != null) {
      produitId = map["produit_id"];
      produitLibelle = map["produit_libelle"];
      produitCode = map["produit_code"];
      produitPhoto = map["produit_photo"];
      produitPrix = map["produit_prix"];
    }
    if (map["user_id"] != null) {
      userId = map["user_id"];
    }
  }
}
