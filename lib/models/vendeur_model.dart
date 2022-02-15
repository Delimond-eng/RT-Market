import 'package:mongo_dart/mongo_dart.dart';

class Vendeur {
  ObjectId vendeurId;
  String vendeurNom;
  String vendeurUtilisateur;
  String vendeurTelephone;
  String vendeurMotDePasse;
  String vendeurStatus;
  String vendeurRole;
  String vendeurDateCreation;
  Vendeur({
    this.vendeurId,
    this.vendeurNom,
    this.vendeurUtilisateur,
    this.vendeurTelephone,
    this.vendeurMotDePasse,
    this.vendeurStatus,
    this.vendeurRole,
    this.vendeurDateCreation,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    vendeurId = ObjectId();
    data['_id'] = vendeurId;
    data["vendeur_nom"] = vendeurNom;
    data["vendeur_utilisateur"] = vendeurUtilisateur;
    data["vendeur_telephone"] = vendeurTelephone;
    data["vendeur_motpasse"] = vendeurMotDePasse;
    data["vendeur_status"] = vendeurStatus;
    data["vendeur_role"] = vendeurRole;
    data["vendeur_date_creation"] = vendeurDateCreation;
    return data;
  }

  Vendeur.fromMap(Map<String, dynamic> map) {
    vendeurId = ObjectId.fromHexString(map["_id"]);
    vendeurNom = map["vendeur_nom"];
    vendeurUtilisateur = map["vendeur_utilisateur"];
    vendeurTelephone = map["vendeur_telephone"];
    vendeurMotDePasse = map["vendeur_motpasse"];
    vendeurRole = map["vendeur_role"];
    vendeurStatus = map["vendeur_status"];
    vendeurDateCreation = map["vendeur_date_creation"];
  }
}
