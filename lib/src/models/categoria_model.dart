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
  int categoriaID;
  String descripcion;
  int lineaItemParent;
  int nivel;

  Categoria(
      {this.categoriaID, this.descripcion, this.lineaItemParent, this.nivel});

  Categoria.fromJsonMap(Map<String, dynamic> json) {
    this.categoriaID = int.tryParse(json['categoriaID']) ?? -1;
    this.descripcion = json['descripcion'];
    this.lineaItemParent = int.tryParse(json['lineaItemParent']) ?? -1;
    this.nivel = int.tryParse(json['nivel']) ?? -1;    
  }
}
