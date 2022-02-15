import 'package:rt_market/global/style.dart';

class Ventes {
  int venteId;
  int venteQte;
  String venteDate;
  //produit
  int produitId;
  String produitLibelle;
  //unite
  int uniteId;
  String uniteLibelle;

  //user
  int userId;
  String userName;
  Ventes({
    this.venteId,
    this.venteQte,
    this.produitId,
    this.uniteId,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (venteId != null) {
      data["vente_id"] = venteId;
    }
    data["vente_qte"] = venteQte;
    data["vente_date"] = dateFromString(DateTime.now());
    data["produit_id"] = produitId;
    if (uniteId != null) {
      data["unite_id"] = uniteId;
    }
    data["user_id"] = userId;
    return data;
  }

  Ventes.fromMap(Map<String, dynamic> map) {
    venteId = map["vente_id"];
    venteQte = map["vente_qte"];
    venteDate = map["vente_date"];
    if (map["produit_id"] != null) {
      produitId = map["produit_id"];
      produitLibelle = map["produit_libelle"];
    }
    if (map["user_id"] != null) {
      userId = map["user_id"];
      userName = map["user_name"];
    }
    if (map["unite_id"] != null) {
      uniteId = map["unite_id"];
      uniteLibelle = map["unite_libelle"];
    }
  }
}
