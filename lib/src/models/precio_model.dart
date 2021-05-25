class Precios {
  static List<Precio> precios;

  Precios.fromJsonList(List<dynamic> jsonList) {
    precios = [];

    jsonList.forEach((jsonItem) {
      final precio = new Precio.fromJsonMap(jsonItem);
      precios?.add(precio);
    });
  }
}

class Precio {
  int itemId; //id del producto
  String lista; //Alfanumérico que representa la lista de precios (L1 a L10)
  int listaPrecios; //Código numérico de la lista de precios (1 a 10)
  double
      precio; //Precio del producto (con o sin IVA, de acuerdo a lo solicitado en el WS)

  Precio({this.itemId, this.lista, this.listaPrecios, this.precio});

  Precio.fromJsonMap(Map<String, dynamic> json) {
    this.itemId = int.tryParse(json['']) ?? -1;
    this.lista = json[''];
    this.listaPrecios = int.tryParse(json['']) ?? -1;
    this.precio = double.tryParse(json['']) ?? 0.0;
  }
}
