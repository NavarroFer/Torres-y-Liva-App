import 'package:shared_preferences/shared_preferences.dart';
import 'package:torres_y_liva/src/utils/globals.dart';

Future guardarDatos(String username, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('logged', logged);
  await prefs.setBool('dbinit', dbInicializada);
  await prefs.setString('username', username);
  await prefs.setString('password', password);
}

Future cargarDatos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  logged = prefs.getBool('logged') ?? false;
  dbInicializada = prefs.getBool('dbinit') ?? false;
  username = prefs.getString('username') ?? '';
  password = prefs.getString('password') ?? '';
}
