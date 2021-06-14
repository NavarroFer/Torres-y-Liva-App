import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:torres_y_liva/src/bloc/bloc_provider.dart';
import 'package:torres_y_liva/src/bloc/login_bloc.dart';
import 'package:torres_y_liva/src/models/categoria_model.dart';
import 'package:torres_y_liva/src/models/cliente_model.dart';
import 'package:torres_y_liva/src/models/producto_model.dart';
import 'package:torres_y_liva/src/pages/home_page.dart';
import 'package:torres_y_liva/src/pages/utils/size_helper.dart';
import 'package:torres_y_liva/src/providers/clientes_provider.dart';
import 'package:torres_y_liva/src/providers/productos_providers.dart';
import 'package:torres_y_liva/src/providers/usuario_provider.dart';
import 'package:torres_y_liva/src/utils/database_helper.dart';
import 'package:torres_y_liva/src/utils/globals.dart';
import 'package:torres_y_liva/src/utils/shared_pref_helper.dart';
import 'package:image_downloader/image_downloader.dart';

class LoginPage extends StatefulWidget {
  static final String route = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _ingresando = false;

  FocusNode passwordFocusNode = new FocusNode();

  String _msgEstadoActual = '';

  TextEditingController _controllerUsuario = TextEditingController();

  TextEditingController _controllerPassword = TextEditingController();

  int _progress;

  Image img;

  @override
  void initState() {
    super.initState();
    _cargarDatos();

    ImageDownloader.callback(onProgressUpdate: (String imageId, int progress) {
      setState(() {
        _progress = progress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (logged && _priveraVezLogin == false) {
    //   _priveraVezLogin = true;
    //   final bloc = BlocProvider.of(context);
    //   bloc.changePassword(password);
    //   bloc.changeUsuario(username);
    //   _login(bloc, context);
    // }
    return Scaffold(
      body: Stack(
        children: [
          _crearFondo(context), // contiene todo lo que no es el formulario
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondo = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.red[600],
          Colors.red[900],
        ],
      )),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromARGB(30, 255, 255, 255),
      ),
    );

    return new Stack(
      children: [
        fondo,
        Positioned(
          child: circulo,
          top: 90.0,
          left: 30.0,
        ),
        Positioned(
          child: circulo,
          top: -40.0,
          right: -30.0,
        ),
        Positioned(
          child: circulo,
          bottom: -50.0,
          right: -10.0,
        ),
        Positioned(
          child: circulo,
          bottom: 120.0,
          right: 20.0,
        ),
        Positioned(
          child: circulo,
          bottom: -50.0,
          left: -20.0,
        ),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              // Icon(
              //   Icons.not_listed_location,
              //   size: 100.0,
              //   color: Colors.white,
              // ),
              Image.asset(
                'assets/img/ic_launcher_round.png',
                height: size.height * 0.2,
              ),
              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = BlocProvider.of(context);

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
        child: Column(
      children: [
        SafeArea(
          child: Container(
            height: 180.0,
          ),
        ),
        Container(
          width: size.width * 0.85,
          margin: EdgeInsets.symmetric(vertical: 30.0),
          padding: EdgeInsets.symmetric(vertical: 50.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0,
                ),
              ]),
          child: Column(
            children: [
              Text(
                'Ingreso',
                textScaleFactor: sizeSegunOrientation(context, 0.006, 0.007),
              ),
              SizedBox(
                height: size.height * 0.07,
              ),
              _crearUsuario(bloc),
              SizedBox(
                height: size.height * 0.04,
              ),
              _crearPassword(bloc),
              SizedBox(
                height: size.height * 0.04,
              ),
              _crearBoton(bloc),
              _textEstadoAcual(context),
            ],
          ),
        ),
        SizedBox(
          height: 120.0,
        )
      ],
    ));
  }

  Widget _crearUsuario(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.usuarioStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final size = MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: TextField(
            controller: _controllerUsuario,
            readOnly: _ingresando,
            onSubmitted: (value) {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(MdiIcons.accountCircleOutline,
                  color: Colors.red, size: size * 0.09),
              hintText: 'Usuario',
              labelText: 'Usuario',
              errorText: snapshot.error,
            ),
            onChanged: (value) => bloc.changeUsuario(value),
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final size = MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: TextField(
            controller: _controllerPassword,
            obscureText: true,
            readOnly: _ingresando,
            focusNode: passwordFocusNode,
            onSubmitted: (v) {
              _login(bloc, context);
            },
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline,
                  color: Colors.red, size: size * 0.09),
              labelText: 'Contraseña',
              errorText: snapshot.error,
            ),
            onChanged: (value) => bloc.changePassword(value),
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    //formValidation

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          onPressed: snapshot.hasData && _ingresando == false
              ? () => _login(bloc, context)
              : null,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: sizeSegunOrientation(context, 0.02, 0.45),
                vertical: sizeSegunOrientation(context, 0.035, 0.035)),
            child: _ingresando
                ? CircularProgressIndicator()
                : Text(
                    'INGRESAR',
                    textScaleFactor:
                        sizeSegunOrientation(context, 0.0035, 0.003),
                  ),
          ),
        );
      },
    );
  }

  void _login(LoginBloc bloc, BuildContext context) async {
    setState(() {
      _ingresando = true;
    });

    final usuarioProvider = UsuariosProvider();

    await usuarioProvider
        .login(bloc.usuario, bloc.password, tokenEmpresa)
        .then((value) async {
      await _loginOK(value, bloc.usuario, bloc.password, context);
    }).onError((error, stackTrace) {
      setState(() {
        _ingresando = false;
      });
      log('${DateTime.now()} - Error en login user: $username psw: $password');
    });
  }

  Future _loginOK(bool value, String username, String password,
      BuildContext context) async {
    if (value == true) {
      logged = true;

      _msgEstadoActual = 'Obteniendo informacion de clientes';
      setState(() {});
      final clientesProvider = ClientesProvider();
      clientesDelVendedor = await clientesProvider.getClientes(
          tokenEmpresa, usuario.tokenWs, usuario.vendedorID);

      final productosProvider = ProductosProvider();
      print(dbInicializada);
      DatabaseHelper.instance;
      if (!dbInicializada) {
        // if (true) {
        await _getAndSaveCategorias(productosProvider);
        await _getAndSaveProductos(productosProvider);
        await _getAndSaveCodBarra(productosProvider);
        dbInicializada = true;
      } else {
        await _getAndSaveUpdatedProductos(productosProvider);
      }

      _ingresando = false;
      initLists();
      await guardarDatos(
          {'username': username, 'password': password, 'logged': true});

      Navigator.of(context).pushReplacementNamed(HomePage.route);
    } else {
      setState(() {
        _ingresando = false;
        logged = false;
      });
      log('${DateTime.now()} - Error en login user: $username psw: $password');
    }
  }

  Future _getAndSaveUpdatedProductos(
      ProductosProvider productosProvider) async {
    _msgEstadoActual = 'Obteniendo informacion de productos';
    setState(() {});
    Productos.productos = await productosProvider.getProductosActualizados(
        tokenEmpresa, usuario.tokenWs);
    await updateProductTable();
    await productosProvider.ackUpdateProductos(tokenEmpresa, usuario.tokenWs);
  }

  Future _getAndSaveCodBarra(ProductosProvider productosProvider) async {
    _msgEstadoActual = 'Obteniendo informacion de codigo de barras';
    setState(() {});
    await productosProvider.getCodigosBarra(tokenEmpresa, usuario.tokenWs);
    await updateCodigosBarraTable();
  }

  Future _getAndSaveProductos(ProductosProvider productosProvider) async {
    _msgEstadoActual = 'Obteniendo informacion de productos';
    setState(() {});
    Productos.productos =
        await productosProvider.getProductos(tokenEmpresa, usuario.tokenWs);
    await updateProductTable();
    await productosProvider.ackUpdateProductos(tokenEmpresa, usuario.tokenWs);
  }

  Future _getAndSaveCategorias(ProductosProvider productosProvider) async {
    _msgEstadoActual = 'Obteniendo informacion de categorias';
    setState(() {});
    await productosProvider.getCategorias(tokenEmpresa, usuario.tokenWs);
    await updateCategoriasTable();
  }

  Future<bool> updateProductTable() async {
    for (var producto in Productos.productos) {
      await producto.insertOrUpdate();
    }
    log('${DateTime.now()} - Tabla productos actualizada',
        time: DateTime.now());
    return true;
  }

  _textEstadoAcual(BuildContext context) {
    if (_ingresando) {
      final size = MediaQuery.of(context).size;
      return Column(
        children: [
          SizedBox(
            height: size.height * 0.05,
          ),
          AutoSizeText(_msgEstadoActual,
              maxLines: 3,
              overflow: TextOverflow.fade,
              minFontSize: (size.width * 0.05).roundToDouble(),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center)
        ],
      );
    } else
      return Container();
  }

  Future _cargarDatos() async {
    await cargarDatos();
    if (logged) {
      setState(() {
        _controllerUsuario.text = username;
        _controllerPassword.text = password;
      });
      await _loginSinBloc(username, password);
    }
  }

  Future _loginSinBloc(String username, String password) async {
    final usuarioProvider = UsuariosProvider();
    setState(() {
      _ingresando = true;
    });
    await usuarioProvider
        .login(username, password, tokenEmpresa)
        .then((value) async {
      final datos = {
        'username': username,
        'password': password,
        'logged': true
      };
      guardarDatos(datos);
      await _loginOK(value, username, password, context);
    }).onError((error, stackTrace) {
      setState(() {
        _ingresando = false;
      });
      log('${DateTime.now()} - Error en login user: $username psw: $password');
    });
  }

  Future<bool> updateCategoriasTable() async {
    for (var categoria in Categorias.categorias) {
      await categoria.insertOrUpdate();
    }
    log('${DateTime.now()} - Tabla categorias actualizada',
        time: DateTime.now());
    return true;
  }

  initLists() async {
    final dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> list;
    list = await dbHelper.queryAllRows(DatabaseHelper.tableClientes);
    Clientes.fromJsonList(list);

    list = await dbHelper.queryAllRows(DatabaseHelper.tableProductos);
    Productos.fromJsonList(list);
  }

  updateCodigosBarraTable() {}
}
