import 'dart:async';

class Validators {
  //decir que entra y que sale del stream
  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 2) {
      sink.add(password);
    } else {
      sink.addError('Debe ser mayor a 2 caracteres');
    }
  });

  final validarMail = StreamTransformer<String, String>.fromHandlers(
      handleData: (usuario, sink) {
    // if (true) {
    sink.add(usuario);
    // } else {
    // sink.addError('El usuario es invalido');
    // }
  });
}
