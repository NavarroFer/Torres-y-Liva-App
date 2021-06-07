import 'package:sqflite/sqflite.dart';
import 'package:torres_y_liva/src/utils/database_helper.dart';
import 'package:torres_y_liva/src/utils/globals.dart';

class Productos {
  static List<Producto> productos = [];

  Productos.fromJsonList(List<dynamic> jsonList) {
    productos = [];

    productosCargados = false;

    jsonList?.forEach((jsonItem) async {
      final producto = new Producto.fromJsonMap(jsonItem);
      productos?.add(producto);
    });

    productosCargados = true;
  }

  static List<Producto> fromJson(List<dynamic> jsonList) {
    List<Producto> lista = [];

    jsonList.forEach((jsonItem) {
      final producto = new Producto.fromJsonMap(jsonItem);
      lista?.add(producto);
    });

    return lista;
  }

  static List<Producto> getSuggestions(String input) {
    List<Producto> prod = [];

    productos.forEach((element) {
      if (element.descripcion.toUpperCase().contains(input.toUpperCase())) {
        prod.add(element);
      }
    });
    return prod;
  }

  static Future<List<Producto>> getSuggesttionsDB(String input) async {
    List<Producto> prod = [];
    final dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> list;
    list = await dbHelper.queryRows(
        DatabaseHelper.tableProductos, DatabaseHelper.descripcion, input,
        descLike: input);
    final listObject = Productos.fromJson(list);

    return listObject;
  }
}

class Producto {
  int id; //
  String code; //
  String categoriaID;
  String descripcion = ''; //
  double stock; //
  double precio = 0; //
  double priceL2; //
  double priceL3; //
  double priceL4; //
  double priceL5; //
  double priceL6; //
  double priceL7; //
  double priceL8; //
  double priceL9; //
  double priceL10; //
  double descuento; //
  double cantidadPack;
  bool ventaFraccionada;
  bool bloqueado;
  String imagenURL;
  bool noPermiteRemito;
  double iva;
  bool disabled;
  DateTime lastUpdate;
  DateTime priceChangeDate;
  bool hasAsterisk;
  int prv;
  DateTime lastBuyDate;
  List<String> barCodes;
  bool checked = false;

  Producto(
      {this.id,
      this.precio,
      this.categoriaID,
      this.barCodes,
      this.code,
      this.descripcion,
      this.disabled,
      this.descuento,
      this.hasAsterisk,
      this.iva,
      this.lastBuyDate,
      this.lastUpdate,
      this.priceChangeDate,
      this.priceL10,
      this.priceL2,
      this.priceL3,
      this.priceL4,
      this.priceL5,
      this.priceL6,
      this.priceL7,
      this.priceL8,
      this.priceL9,
      this.prv,
      this.stock,
      this.cantidadPack,
      this.ventaFraccionada,
      this.bloqueado,
      this.imagenURL,
      this.noPermiteRemito});

  String getInfoFormatted() {
    int listaPrecios = 0;

    if (idCliente != null) {
      listaPrecios = clientesDelVendedor
          ?.firstWhere((element) => element.clientId == idCliente)
          ?.priceList;
    }
    return "COD: ${this.id} - STK: ${this.stock} - S/IVA: \$ ${this.getPriceFromList(listaPrecios)}";
  }

  Future<int> insertOrUpdate() async {
    final dbHelper = DatabaseHelper.instance;
    final existe = await dbHelper.exists(
        DatabaseHelper.tableProductos, this.id, DatabaseHelper.idProducto);
    if (existe) {
      await dbHelper.update(this.toMap(), DatabaseHelper.tableProductos,
          DatabaseHelper.idProducto);
    } else {
      await dbHelper.insert(this.toMap(), DatabaseHelper.tableProductos);
    }
    return existe ? 0 : 1;
  }

  double getPriceFromList(int clientPriceList) {
    double priceClient;

    switch (clientPriceList) {
      case 2:
        priceClient = priceL2;
        break;
      case 3:
        priceClient = priceL3;
        break;
      case 4:
        priceClient = priceL4;
        break;
      case 5:
        priceClient = priceL5;
        break;
      case 6:
        priceClient = priceL6;
        break;
      case 7:
        priceClient = priceL7;
        break;
      case 8:
        priceClient = priceL8;
        break;
      case 9:
        priceClient = priceL9;
        break;
      case 10:
        priceClient = priceL10;
        break;
      default:
        priceClient = precio;
        break;
    }
    return priceClient;
  }

  double getPriceForClient(
      double generalDiscount, double price, bool includeIva, double iva) {
    double priceClient = price - (price * generalDiscount / 100);
    priceClient = priceClient + (includeIva ? priceClient * iva : 0);
    return priceClient;
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.idPedido: this.id,
      DatabaseHelper.code: this.code ?? '',
      DatabaseHelper.categoriaID: this.categoriaID ?? '',
      DatabaseHelper.descripcion: this.descripcion ?? '',
      DatabaseHelper.stock: this.stock ?? 0.0,
      DatabaseHelper.precio: this.precio ?? 0.0,
      DatabaseHelper.priceL2: this.priceL2 ?? 0.0,
      DatabaseHelper.priceL3: this.priceL3 ?? 0.0,
      DatabaseHelper.priceL4: this.priceL4 ?? 0.0,
      DatabaseHelper.priceL5: this.priceL5 ?? 0.0,
      DatabaseHelper.priceL6: this.priceL6 ?? 0.0,
      DatabaseHelper.priceL7: this.priceL7 ?? 0.0,
      DatabaseHelper.priceL8: this.priceL8 ?? 0.0,
      DatabaseHelper.priceL9: this.priceL9 ?? 0.0,
      DatabaseHelper.priceL10: this.priceL10 ?? 0.0,
      DatabaseHelper.descuento: this.descuento ?? 0.0,
      DatabaseHelper.cantidadPack: this.cantidadPack ?? 0.0,
      DatabaseHelper.ventaFraccionada: this.ventaFraccionada == null
          ? 0
          : this.ventaFraccionada
              ? 1
              : 0,
      DatabaseHelper.bloqueado: this.bloqueado == null
          ? 0
          : this.bloqueado
              ? 1
              : 0,
      DatabaseHelper.imagenURL: this.imagenURL ?? '',
      DatabaseHelper.noPermiteRemito: this.noPermiteRemito == null
          ? 0
          : this.noPermiteRemito
              ? 1
              : 0,
      DatabaseHelper.iva: this.iva ?? 0.0,
      'disabled': this.disabled == null
          ? 0
          : this.disabled
              ? 1
              : 0,
      DatabaseHelper.lastUpdate: this.lastUpdate ?? 0,
      DatabaseHelper.priceChangeDate: this.priceChangeDate ?? 0,
      'hasAsterisk': this.hasAsterisk == null
          ? 0
          : this.hasAsterisk
              ? 1
              : 0,
      DatabaseHelper.prv: this.prv ?? 0,
      DatabaseHelper.lastBuyDate: this.lastBuyDate ?? 0
    };
  }

  Producto.fromJsonMap(Map<String, dynamic> json) {
    this.id = json[DatabaseHelper.idPedido];
    this.code = json[DatabaseHelper.code];
    this.categoriaID = json[DatabaseHelper.categoriaID];
    this.descripcion = json[DatabaseHelper.descripcion];
    this.stock = json[DatabaseHelper.stock];
    this.precio = json[DatabaseHelper.precio];
    this.priceL2 = json[DatabaseHelper.priceL2];
    this.priceL3 = json[DatabaseHelper.priceL3];
    this.priceL4 = json[DatabaseHelper.priceL4];
    this.priceL5 = json[DatabaseHelper.priceL5];
    this.priceL6 = json[DatabaseHelper.priceL6];
    this.priceL7 = json[DatabaseHelper.priceL7];
    this.priceL8 = json[DatabaseHelper.priceL8];
    this.priceL9 = json[DatabaseHelper.priceL9];
    this.priceL10 = json[DatabaseHelper.priceL10];
    this.descuento = json[DatabaseHelper.descuento];
    this.cantidadPack = json[DatabaseHelper.cantidadPack];
    this.ventaFraccionada = json[DatabaseHelper.ventaFraccionada] == 1 ?? false;
    this.bloqueado = json['bloqueado'] == 1 ?? false;
    this.imagenURL = json[DatabaseHelper.imagenURL];
    this.noPermiteRemito = json[DatabaseHelper.noPermiteRemito] == 1 ?? false;
    this.iva = json[DatabaseHelper.iva];
  }
}
