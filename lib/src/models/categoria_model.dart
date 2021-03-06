import 'package:torres_y_liva/src/utils/database_helper.dart';

class Categorias {
  static List<Categoria> categorias;

  Categorias.fromJsonList(List<dynamic> jsonList) {
    categorias = [];

    jsonList.forEach((jsonItem) {
      final categoria = new Categoria.fromJsonMap(jsonItem);
      categorias?.add(categoria);
    });
  }

  static List<Categoria> fromJson(List<dynamic> jsonList) {
    List<Categoria> lista = [];

    jsonList.forEach((jsonItem) {
      final producto = new Categoria.fromJsonMap(jsonItem);
      lista?.add(producto);
    });

    return lista;
  }

  static Future<List<Categoria>> getCategorias() async {
    final dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> list;
    list = await dbHelper.queryAllRows(DatabaseHelper.tableCategorias);
    final listObject = Categorias.fromJson(list);

    return listObject;
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

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.catID: this.categoriaID ?? '',
      DatabaseHelper.catDescripcion: this.descripcion ?? '',
      DatabaseHelper.lineaItemParent: this.lineaItemParent ?? 0,
      DatabaseHelper.nivel: this.nivel ?? -1,
    };
  }

  Categoria.fromJsonMap(Map<String, dynamic> json) {
    this.categoriaID = json[DatabaseHelper.catID];
    this.descripcion = json[DatabaseHelper.catDescripcion];
    this.lineaItemParent = json[DatabaseHelper.lineaItemParent];
    this.nivel = json[DatabaseHelper.nivel];
  }

  insertOrUpdate() async {
    final dbHelper = DatabaseHelper.instance;

    await dbHelper.insert(this.toMap(), DatabaseHelper.tableCategorias);
  }
}
