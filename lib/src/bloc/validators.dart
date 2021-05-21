import 'dart:async';

class Validators {
  //decir que entra y que sale del stream
  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError('Debe ser mayor a 5 caracteres');
    }
  });

  final validarMail = StreamTransformer<String, String>.fromHandlers(
      handleData: (usuario, sink) {
    Pattern pattern =
        "^(?=.{8,20}\$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])\$";
    RegExp regExp = new RegExp(pattern);

    if (true) {
      sink.add(usuario);
    } else {
      sink.addError('El usuario es invalido');
    }
  });
}
