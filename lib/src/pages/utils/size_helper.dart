import 'package:flutter/material.dart';

double sizeSegunOrientation(
    BuildContext context, double sizePortrait, double sizeLandscape) {
  return MediaQuery.of(context).orientation == Orientation.portrait
      ? MediaQuery.of(context).size.width * sizePortrait
      : MediaQuery.of(context).size.height * sizeLandscape;
}
