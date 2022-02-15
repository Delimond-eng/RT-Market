import 'package:mongo_dart/mongo_dart.dart';
import 'package:rt_market/global/style.dart';

class Vente {
  ObjectId venteId;
  ObjectId venteProduitId;
  int venteQte;
  String venteUnite;
  ObjectId venteVendeurId;
  String venteDate;
  String venteStatus;
  Vente({
    this.venteId,
    this.venteProduitId,
    this.venteQte,
    this.venteVendeurId,
    this.venteDate,
    this.venteStatus,
    this.venteUnite,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    venteId = ObjectId();
    data["_id"] = venteId;
    data["vente_produit_id"] = venteProduitId;
    data["vente_qte"] = venteQte;
    if (venteUnite != null) {
      data["vente_unite"] = venteUnite;
    }
    data["vente_vendeur_id"] = venteVendeurId;
    data["vente_date"] = dateFromString(DateTime.now());
    data["vente_status"] = venteStatus;
    return data;
  }

  Vente.fromMap(Map<String, dynamic> map) {
    venteId = ObjectId.fromHexString(map["_id"]);
    venteProduitId = ObjectId.fromHexString(map["vente_produit_id"]);
    venteQte = map["vente_qte"];
    if (map["vente_unite"] != null) {
      venteUnite = map["vente_unite"];
    }
    venteVendeurId = ObjectId.fromHexString(map["vente_vendeur_id"]);
    venteDate = map["vente_date"];
    venteStatus = map["vente_status"];
  }
}
