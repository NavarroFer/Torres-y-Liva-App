class Productos {
  static List<Producto> productos = [];

  Productos.fromJsonList(List<dynamic> jsonList) {
    productos = [];

    jsonList?.forEach((jsonItem) {
      final producto = new Producto.fromJsonMap(jsonItem);
      productos?.add(producto);
    });
  }
}

class Producto {
  String code; //
  String descripcion; //
  String nombre;
  int id; //
  double precio; //
  bool disabled;
  DateTime lastUpdate;
  DateTime priceChangeDate;
  double stock; //
  bool hasAsterisk;
  int prv;
  int cxb;
  DateTime lastBuyDate;
  List<String> barCodes;
  double iva;
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
  String categoriaID;
  double cantidadPack;
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

  Producto.fromJsonMap(Map<String, dynamic> json) {
    this.id = json['primaryKey'];
    this.code = json['codigo'];
    this.categoriaID = json['categoriaID'];
    this.descripcion = json['descripcion'];
    this.stock = json['cantidad'];
    this.precio = json['precio'];
    this.priceL2 = json['precio_l2'];
    this.priceL3 = json['precio_l3'];
    this.priceL4 = json['precio_l4'];
    this.priceL5 = json['precio_l5'];
    this.priceL6 = json['precio_l6'];
    this.priceL7 = json['precio_l7'];
    this.priceL8 = json['precio_l8'];
    this.priceL9 = json['precio_l9'];
    this.priceL10 = json['precio_l10'];
    this.descuento = json['descuento'];
    this.cantidadPack = json['cantidadPack'];
    this.ventaFraccionada = json['ventaFraccionada'];
    this.bloqueado = json['bloqueado'];
    this.imagenURL = json['imagenURL'];
    this.noPermiteRemito = json['noPermiteRemito'];
    this.iva = json['tasaIVA'];
  }
}
