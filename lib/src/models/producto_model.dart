class Producto {
  int code; //
  String descripcion; //
  String nombre;
  int id; //
  double precio; //
  bool disabled;
  DateTime lastUpdate;
  DateTime priceChangeDate;
  int stock; //
  bool hasAsterisk;
  int prv;
  int cxb;
  DateTime lastBuyDate;
  List<String> barCodes;
  double iva;
  double price_l2; //
  double price_l3; //
  double price_l4; //
  double price_l5; //
  double price_l6; //
  double price_l7; //
  double price_l8; //
  double price_l9; //
  double price_l10; //
  double descuento; //
  int categoriaID;
  int cantidadPack;
  bool ventaFraccionada;
  bool bloqueado;
  String imagenURL;
  bool noPermiteRemito;

  Producto(
      {this.id,
      this.precio,
      this.categoriaID,
      this.nombre,
      this.barCodes,
      this.code,
      this.cxb,
      this.descripcion,
      this.disabled,
      this.descuento,
      this.hasAsterisk,
      this.iva,
      this.lastBuyDate,
      this.lastUpdate,
      this.priceChangeDate,
      this.price_l10,
      this.price_l2,
      this.price_l3,
      this.price_l4,
      this.price_l5,
      this.price_l6,
      this.price_l7,
      this.price_l8,
      this.price_l9,
      this.prv,
      this.stock,
      this.cantidadPack,
      this.ventaFraccionada,
      this.bloqueado,
      this.imagenURL,
      this.noPermiteRemito});

  double getPriceFromList(int clientPriceList) {
    double priceClient;

    switch (clientPriceList) {
      case 2:
        priceClient = price_l2;
        break;
      case 3:
        priceClient = price_l3;
        break;
      case 4:
        priceClient = price_l4;
        break;
      case 5:
        priceClient = price_l5;
        break;
      case 6:
        priceClient = price_l6;
        break;
      case 7:
        priceClient = price_l7;
        break;
      case 8:
        priceClient = price_l8;
        break;
      case 9:
        priceClient = price_l9;
        break;
      case 10:
        priceClient = price_l10;
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

  Producto.fromJsonMap(Map<String, dynamic> json) {
    this.id = json['primaryKey'];
    this.code = json['codigo'];
    this.categoriaID = int.tryParse(json['categoriaID']) ?? -1;
    this.descripcion = json['descripcion'];
    this.stock = int.tryParse(json['cantidad']) ?? 0;
    this.precio = double.tryParse(json['precio']) ?? 0.0;
    this.price_l2 = double.tryParse(json['precio_l2']) ?? 0.0;
    this.price_l3 = double.tryParse(json['precio_l3']) ?? 0.0;
    this.price_l4 = double.tryParse(json['precio_l4']) ?? 0.0;
    this.price_l5 = double.tryParse(json['precio_l5']) ?? 0.0;
    this.price_l6 = double.tryParse(json['precio_l6']) ?? 0.0;
    this.price_l7 = double.tryParse(json['precio_l7']) ?? 0.0;
    this.price_l8 = double.tryParse(json['precio_l8']) ?? 0.0;
    this.price_l9 = double.tryParse(json['precio_l9']) ?? 0.0;
    this.price_l10 = double.tryParse(json['precio_l10']) ?? 0.0;
    this.descuento = double.tryParse(json['descuento']) ?? 0.0;
    // this.nombre = json[''];
    this.cantidadPack = int.tryParse(json['cantidadPack']) ?? 0;
    this.ventaFraccionada = json['ventaFraccionada'];
    this.bloqueado = json['bloqueado'];
    this.imagenURL = json['imagenURL'];
    this.noPermiteRemito = json['noPermiteRemito'];
    this.iva = double.tryParse(json['tasaIVA']) ?? 0.0;
  }
}

class CodigoBarra {
  int itemID;
  String codigoBarra;
}
