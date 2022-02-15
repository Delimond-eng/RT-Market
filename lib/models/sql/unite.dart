class Unite {
  int uniteId;
  String uniteLibelle;
  Unite({
    this.uniteId,
    this.uniteLibelle,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    if (uniteId != null) {
      data["unite_id"] = uniteId;
    }
    data["unite_libelle"] = uniteLibelle;
    return data;
  }

  Unite.fromMap(Map<String, dynamic> map) {
    uniteId = map["unite_id"];
    uniteLibelle = map["unite_libelle"];
  }
}
