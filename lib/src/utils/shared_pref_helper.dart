import 'package:shared_preferences/shared_preferences.dart';
import 'package:torres_y_liva/src/utils/globals.dart';

Future guardarDatos(Map<String, dynamic> datos) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('logged', datos['logged'] ?? false);
  await prefs.setBool('dbinit', dbInicializada);
  await prefs.setString('username', datos['username'] ?? '');
  await prefs.setString('password', datos['password'] ?? '');
  await grabaFechaGetDataIMG();
}

Future guardarFechaAltaMovil() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('fechaAltaMovil', DateTime.now().millisecondsSinceEpoch);
}

Future cargarFechaAltaMovil() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  fechaAltaMovil = prefs.getInt('fechaAltaMovil');
}

Future grabaFechaGetDataIMG() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('fechaGetDataIMG', fechaGetDataIMG ?? '');
}

Future grabaFechaUpdate() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('fechaUpdateIMG', fechaUpdateIMG ?? '');
}

Future cargarDatos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  logged = prefs.getBool('logged') ?? false;
  dbInicializada = prefs.getBool('dbinit') ?? false;
  username = prefs.getString('username') ?? '';
  password = prefs.getString('password') ?? '';
  if (dbInicializada == false)
    fechaGetDataIMG = '';
  else
    fechaGetDataIMG = prefs.getString('fechaGetDataIMG') ?? '';
  fechaUpdateIMG = prefs.getString('fechaUpdateIMG') ?? '';
  fechaAltaMovil = prefs.getInt('fechaAltaMovil') ?? 0;
}
