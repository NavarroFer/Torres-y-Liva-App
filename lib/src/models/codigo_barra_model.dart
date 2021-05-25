class CodigosBarra {
  static List<CodigoBarra> codigos;

  CodigosBarra.fromJsonList(List<dynamic> jsonList) {
    codigos = [];

    jsonList.forEach((jsonItem) {
      final codigo = new CodigoBarra.fromJsonMap(jsonItem);
      codigos?.add(codigo);
    });
  }
}

class CodigoBarra {
  int itemID;
  String codigoBarra;

  CodigoBarra.fromJsonMap(Map<String, dynamic> json) {
    this.codigoBarra = json['itemID'];
    this.itemID = int.tryParse(json['codigoBarra']) ?? -1;
  }
}
