import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:torres_y_liva/src/bloc/validators.dart';

class LoginBloc with Validators {
  final _usuarioController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recuperar los datos del stream
  Stream<String> get usuarioStream =>
      _usuarioController.stream.transform(validarMail);
  //Gracias al mixing, con with, heredamos el metodo validarPassword
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream => Rx.combineLatest2(
      usuarioStream, passwordStream, (dataEmail, dataPassword) => true);

  //Insertar valores al Stream
  Function(String) get changeUsuario => _usuarioController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  dispose() {
    _usuarioController?.close();
    _passwordController?.close();
  }

  String get usuario => _usuarioController.value;

  String get password => _passwordController.value;
}
