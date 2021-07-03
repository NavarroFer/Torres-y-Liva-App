import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:torres_y_liva/src/utils/globals.dart';

class DatabaseHelper {
  static final _databaseName = "torres-y-liva.db";
  static final _databaseVersion = 1;

//productos
  static final tableProductos = 'productos';

  static final idProducto = 'primaryKey';
  static final code = 'codigo';
  static final categoriaID = 'categoriaID';
  static final descripcion = 'descripcion';
  static final stock = 'cantidad';
  static final precio = 'precio';
  static final priceL2 = 'precio_l2';
  static final priceL3 = 'precio_l3';
  static final priceL4 = 'precio_l4';
  static final priceL5 = 'precio_l5';
  static final priceL6 = 'precio_l6';
  static final priceL7 = 'precio_l7';
  static final priceL8 = 'precio_l8';
  static final priceL9 = 'precio_l9';
  static final priceL10 = 'precio_l10';
  static final descuento = 'descuento';
  static final cantidadPack = 'cantidadPack';
  static final ventaFraccionada = 'ventaFraccionada';
  static final bloqueado = 'bloqueado';
  static final imagenURL = 'imagenURL';
  static final noPermiteRemito = 'noPermiteRemito';
  static final iva = 'tasaIva';
  static final disabled = 'disabled';
  static final proveedorID = 'proveedorID';
  static final proveedorNombre = 'proveedorNombre';
  static final marcaID = 'marcaID';
  static final marcaNombre = 'marcaNombre';
  static final presentacion = 'presentacion';
  static final observacionVentas = 'observacionVentas';
  static final fechaUltimaCompraProducto = 'fechaUltimaCompra';
  static final fechaModificadoProducto = 'fechaModificado';
  static final listaPreciosDefault = 'listaPreciosDefault';

//productos//

//categorias
  static final tableCategorias = 'categorias';

  static final catID = 'categoriaID';
  static final catDescripcion = 'descripcion';
  static final lineaItemParent = 'lineaItemParent';
  static final nivel = 'nivel';
//categorias//

//cliente
  static final tableClientes = 'clientes';

  static final clienteID = 'primaryKey'; //primaryKey
  static final cliID = 'clienteID'; //clientId
  static final userIdCliente = 'usuarioWebID';
  static final clienteDomicilioID = 'domicilioClienteID';
  static final codigoGestion = 'codigoGestion';
  static final nombre = 'nombre';
  static final ciudad = 'localidad';
  static final tipoCuitID = 'tipoCuitID';
  static final cuit = 'cuit';
  static final email = 'email';
  static final domicilio = 'domicilio';
  static final telefono = 'telefono';
  static final telefonoCel = 'telefonoCel';
  static final fechaUltimaCompra = 'fechaUltimaCompra';
  static final clientePriceList = 'lista_precios';
  static final formaPago = 'formaPago';
  static final razonSocial = 'razonSocial';
  static final clienteDescuento = 'descuento';
  static final saldo = 'saldo';
  static final credito = 'credito';
  static final clienteObservaciones = 'observaciones';
  static final clienteLatitud = 'latitud';
  static final clienteLongitud = 'longitud';
  static final reba = 'reba';
  static final priceListAux = 'listaPrecios';
  static final geoReferenced = 'geoReferenciado';
//cliente//

//codigo barra
  static final tableCodigoBarra = 'codigoBarra';

  static final itemIDCodBarra = 'itemID';
  static final codigoBarra = 'codigoBarra';
//codigo barra//

//pedidos
  static final tablePedidos = 'pedidos';

  static final estado = 'estado';
  static final idPedido = 'primaryKey';
  static final usuarioWebId = 'usuarioWebID';
  static final clienteIDPedido = 'clienteID';
  static final domicilioClienteID = 'domicilioClienteID';
  static final operadorID = 'operadorID';
  static final totalPedido = 'totalPedido';
  static final netoPedido = 'netoPedido';
  static final ivaPedido = 'ivaPedido';
  static final descuentoPedido = 'descuento';
  static final fechaPedido = 'fechaPedido';
  static final obsPedido = 'observacion';
  static final domicilioDespacho = 'domicilioDespacho';
  static final latitudPedido = 'latitud';
  static final longitudPedido = 'longitud';
  static final listaPrecios = 'listaPrecios';
  static final idFormaPago = 'idFormaPago';
//pedidos//

//item pedido
  static final tableItemsPedido = 'itemsPedidos';

  static final idItemPedido = 'itemID';
  static final cantidadItemPedido = 'cantidad';
  static final precioItemPedido = 'precio';
  static final descuentoItemPedido = 'descuento';
  static final precioTotalItemPedido = 'precioTotal';
  static final obsItemPedido = 'observacion';
  static final detalleItemPedido = 'detalle';
  static final fraccionItemPedido = 'fraccion';
  static final ivaItemPedido = 'iva';
  static final listaPreciosItemPedido = 'listaPrecios';
  static final productoIDItemPedido = 'productoID';
  static final pedidoIDItemPedido = 'pedidoid';
//item pedido//

//img productos//
  static final tableImgProductos = 'imagenesProductos';

  static final idProductoImg = 'code';
  static final fechaDescarga = 'date_modification';
  static final downloaded = 'downloaded';
  static final extension = 'extension';
//img productos//

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    if (dbInicializada == false) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, _databaseName);
      deleteDatabase(path);
      // _database = await _initDatabase();
    }
    _database = await _initDatabase();

    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onConfigure: _onConfigure);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await _createTableCategorias(db);
    await _createTableClientes(db);
    await _createTableProductos(db);
    await _createTableImgProductos(db);
    await _createTableCodigoBarras(db);
    await _createTablePedidos(db);
    await _createTableItemsPedidos(db);
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;

    final res = await db.transaction<int>((txn) {
      return txn
          .insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace)
          .onError((error, stackTrace) {
        print(error);
        return -1;
      }).then((value) {
        return value;
      });
    });

    return res;
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String table,
      {List<String> cols, int limit}) async {
    Database db = await instance.database;

    var res;

    await db.transaction((txn) async {
      res = await txn.query(table, columns: cols, limit: limit);
    });

    return res;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(
      Map<String, dynamic> row, String table, String nombreColumnId) async {
    Database db = await instance.database;
    var id = row[nombreColumnId];
    String value;
    if (id is String) {
      value = "'$id'";
    } else if (id is int) {
      value = id.toString();
    }

    return await db.transaction((txn) => txn.update(table, row,
            where: '$nombreColumnId = ?',
            whereArgs: [value]).onError((error, stackTrace) {
          print('Error en update: $error, ID: ');
          return -1;
        }).then((value) {
          return value;
        }));
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(String table, {int id, String nombreColumnId}) async {
    Database db = await instance.database;
    if (nombreColumnId != null && nombreColumnId != '')
      return await db.transaction((txn) =>
          txn.delete(table, where: '$nombreColumnId = ?', whereArgs: [id]));
    else
      return await db.transaction((txn) => txn.delete(table));
  }

  Future<bool> exists(String table, var id, String nombreColumnId) async {
    List<Map<String, dynamic>> res = await queryRows(table, nombreColumnId, id)
        .onError((error, stackTrace) => []);
    return res.length > 0;
  }

  Future<List<Map<String, dynamic>>> queryRows(
      String table, String nombreColumnId, var id,
      {String descLike, List<String> cols}) async {
    Database db = await instance.database;

    var res;

    if (descLike != null) {
      res = await db.rawQuery(
          "SELECT * FROM $table where $nombreColumnId like '%$descLike%'");
    } else {
      String value;
      if (id is String) {
        value = "'$id'";
      } else if (id is int) {
        value = id.toString();
      }

      res = await db.query(table,
          columns: cols, where: '$nombreColumnId = $value');
    }
    return res;
  }

  Future _createTableClientes(Database db) async {
    return await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableClientes (
            $clienteID INTEGER PRIMARY KEY,
            $cliID INTEGER,
            $userIdCliente INTEGER,
            $clienteDomicilioID INTEGER,
            $codigoGestion TEXT,
            $nombre TEXT,
            $ciudad TEXT,
            $tipoCuitID INTEGER,
            $cuit TEXT,
            $email TEXT,
            $domicilio TEXT,
            $telefono TEXT,
            $telefonoCel TEXT,
            $fechaUltimaCompra TEXT,
            $clientePriceList INTEGER,
            $formaPago TEXT,
            $razonSocial TEXT,
            $clienteDescuento REAL,
            $saldo REAL,
            $credito REAL,
            $clienteObservaciones TEXT,
            $clienteLatitud TEXT,
            $clienteLongitud TEXT,
            $reba TEXT,
            $priceListAux INTEGER,
            $geoReferenced INTEGER
          )
          ''');
  }

  Future _createTableCategorias(Database db) async {
    return await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableCategorias (
            $catID TEXT PRIMARY KEY,
            $catDescripcion TEXT,
            $lineaItemParent INTEGER,
            $nivel INTEGER
          )
          ''');
  }

  Future _createTableProductos(Database db) async {
    return await db.execute('''
     CREATE TABLE IF NOT EXISTS $tableProductos (
            $idProducto INTEGER PRIMARY KEY,
            $code TEXT,
            $categoriaID TEXT,
            $descripcion TEXT,
            $stock REAL,
            $precio REAL,
            $priceL2 REAL,
            $priceL3 REAL,
            $priceL4 REAL,
            $priceL5 REAL,
            $priceL6 REAL,
            $priceL7 REAL,
            $priceL8 REAL,
            $priceL9 REAL,
            $priceL10 REAL,
            $descuento REAL,
            $cantidadPack REAL,
            $ventaFraccionada INTEGER,
            $bloqueado INTEGER,
            $imagenURL TEXT,
            $noPermiteRemito INTEGER,
            $iva REAL,
            $disabled INTEGER,
            $proveedorID INTEGER,
            $proveedorNombre TEXT,
            $marcaID INTEGER,
            $marcaNombre TEXT,
            $presentacion INTEGER,
            $observacionVentas TEXT,
            $fechaUltimaCompraProducto TEXT,
            $fechaModificadoProducto TEXT,
            $listaPreciosDefault INTEGER
          )
    ''');
  }

  Future _createTableCodigoBarras(Database db) async {
    return await db.execute('''
     CREATE TABLE IF NOT EXISTS $tableCodigoBarra (
            $itemIDCodBarra INTEGER PRIMARY KEY,
            $codigoBarra TEXT,
            FOREIGN KEY($itemIDCodBarra) REFERENCES ${DatabaseHelper.tableProductos}(${DatabaseHelper.idProducto}) ON DELETE CASCADE
          )
    ''');
  }

  Future _createTablePedidos(Database db) async {
    return await db.execute('''
          CREATE TABLE IF NOT EXISTS $tablePedidos (
            $idPedido INTEGER PRIMARY KEY,
            $estado INTEGER,
            $usuarioWebId INTEGER,
            $clienteIDPedido INTEGER,
            $domicilioClienteID INTEGER,
            $operadorID INTEGER,
            $totalPedido REAL,
            $netoPedido REAL,
            $ivaPedido REAL,
            $descuentoPedido REAL,
            $fechaPedido TEXT,
            $obsPedido TEXT,
            $domicilioDespacho TEXT,
            $latitudPedido TEXT,
            $longitudPedido TEXT,
            $listaPrecios INTEGER,
            $idFormaPago INTEGER
          )
          ''');
  }

  FutureOr<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createTableItemsPedidos(Database db) async {
    return await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableItemsPedido (
            $idItemPedido INTEGER,
            $cantidadItemPedido REAL,
            $precioItemPedido REAL,
            $descuentoItemPedido REAL,
            $precioTotalItemPedido REAL,
            $obsItemPedido TEXT,
            $detalleItemPedido TEXT,
            $fraccionItemPedido REAL,
            $ivaItemPedido REAL,
            $listaPreciosItemPedido INTEGER,
            $productoIDItemPedido INTEGER,
            $pedidoIDItemPedido INTEGER,
            FOREIGN KEY($productoIDItemPedido) REFERENCES ${DatabaseHelper.tableProductos}(${DatabaseHelper.idProducto}) ON DELETE CASCADE,
            FOREIGN KEY($pedidoIDItemPedido) REFERENCES ${DatabaseHelper.tablePedidos}(${DatabaseHelper.idPedido}) ON DELETE CASCADE,
            PRIMARY KEY ($pedidoIDItemPedido, $idItemPedido)
            
          )
          ''');
  }

  Future<int> getLastID(String table, String columnId, String orderBy) async {
    Database db = await instance.database;

    final rowLastId = await db.rawQuery('SELECT MAX($columnId) FROM $table');

    if (rowLastId.length == 0) return 0;

    int id = rowLastId[0]['MAX($columnId)'];

    return id;
  }

  Future _createTableImgProductos(Database db) async {
    return await db.execute('''
     CREATE TABLE IF NOT EXISTS $tableImgProductos (
            $idProductoImg INTEGER PRIMARY KEY,
            $fechaDescarga TEXT,
            $downloaded INTEGER,
            $extension TEXT,
            FOREIGN KEY($idProductoImg) REFERENCES ${DatabaseHelper.tableProductos}(${DatabaseHelper.idProducto})            
          )
    ''');
  }
}
