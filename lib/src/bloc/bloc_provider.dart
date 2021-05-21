import 'package:flutter/material.dart';
import 'package:torres_y_liva/src/bloc/login_bloc.dart';

//puede manejar multiples instancias de bloc, puede manejar todo acá
class BlocProvider extends InheritedWidget {
  static BlocProvider _instancia;

  factory BlocProvider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new BlocProvider._internal(key: key, child: child);
    }
    return _instancia;
  }

  BlocProvider._internal({Key key, Widget child})
      : super(key: key, child: child);

  final loginBloc = LoginBloc();
  //final Bloc2 = Bloc2();
  //final Bloc3 = Bloc3();
  //final AlgoGlobal = AlgoGlobal();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    //busca en el arbol, y me retorna la instancia del bloc, basado en el contexto
    return context.dependOnInheritedWidgetOfExactType<BlocProvider>().loginBloc;
  }
}
