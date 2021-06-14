import 'package:torres_y_liva/src/utils/database_helper.dart';

class DataImage {
  String code;
  String extension;
  String dateMod;
  int downloaded;

  DataImage({this.code, this.extension, this.dateMod, this.downloaded});

  DataImage.fromJsonMap(Map<String, dynamic> json) {
    this.code = json[DatabaseHelper.idProductoImg].toString() ?? '';
    this.extension = json[DatabaseHelper.extension] ?? '';
    this.dateMod = json[DatabaseHelper.fechaDescarga] ?? '';
    this.downloaded = json[DatabaseHelper.downloaded] ?? 0;
  }
}
