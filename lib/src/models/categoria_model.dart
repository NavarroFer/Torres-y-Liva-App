class Categorias {
  static List<Categoria> categorias;

  Categorias.fromJsonList(List<dynamic> jsonList) {
    categorias = [];

    jsonList.forEach((jsonItem) {
      final categoria = new Categoria.fromJsonMap(jsonItem);
      categorias?.add(categoria);
    });
  }
}

class Categoria {
  String categoriaID;
  String descripcion;
  int lineaItemParent;
  int nivel;

  // Para seleccionar en cotizacion
  bool checked = false;

  static const IMPORTACION = 'importacion';

  static const ULTIMAS_FOTOS = 'ULT_FOTOS';

  static const ULTIMAS_ENTRADAS = 'ULT_ENTRADAS';

  Categoria(
      {this.categoriaID, this.descripcion, this.lineaItemParent, this.nivel});

  Categoria.fromJsonMap(Map<String, dynamic> json) {
    this.categoriaID = json['categoriaID'];
    this.descripcion = json['descripcion'];
    this.lineaItemParent = json['lineaItemParent'];
    this.nivel = json['nivel'];
  }
}
