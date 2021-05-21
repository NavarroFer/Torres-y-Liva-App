import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:torres_y_liva/src/bloc/bloc_provider.dart';
import 'package:torres_y_liva/src/bloc/login_bloc.dart';
import 'package:torres_y_liva/src/pages/home_page.dart';
import 'package:torres_y_liva/src/pages/utils/size_helper.dart';

class LoginPage extends StatelessWidget {
  static final String route = 'login';
  @override
  Widget build(BuildContext context) {
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
              Icon(
                Icons.not_listed_location,
                size: 100.0,
                color: Colors.white,
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
                height: 60.0,
              ),
              _crearUsuario(bloc),
              SizedBox(
                height: 30.0,
              ),
              _crearPassword(bloc),
              SizedBox(
                height: 30.0,
              ),
              _crearBoton(bloc),
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
            obscureText: true,
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
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: sizeSegunOrientation(context, 0.02, 0.45),
                vertical: sizeSegunOrientation(context, 0.035, 0.035)),
            child: Text(
              'INGRESAR',
              textScaleFactor: sizeSegunOrientation(context, 0.0035, 0.003),
            ),
          ),
        );
        // RaisedButton(
        //   //el container es para poder darle padding
        //   child: Container(
        //     padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        //     child: Text(
        //       'INGRESAR',
        //     ),
        //   ),
        //   onPressed:
        //   elevation: 0.0,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(5.0),
        //   ),
        //   color: Colors.red,
        //   textColor: Colors.white,
        //   disabledColor: Colors.grey[400],
        // );
      },
    );
  }

  void _login(LoginBloc bloc, BuildContext context) {
    print('==================');
    print('Email: ${bloc.usuario}');
    print('Password: ${bloc.password}');
    print('==================');
    Navigator.of(context).pushReplacementNamed(HomePage.route);
  }
}
