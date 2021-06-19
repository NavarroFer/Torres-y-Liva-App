import 'package:torres_y_liva/src/utils/database_helper.dart';

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
    this.codigoBarra = json[DatabaseHelper.codigoBarra] ?? '';
    this.itemID = json[DatabaseHelper.itemIDCodBarra] ?? 0;
  }
}
