import 'package:flutter/material.dart';

Widget action(BuildContext context,
    {IconData icon, double size = 24.0, void onPressed(BuildContext context)}) {
  return IconButton(icon: Icon(icon, size: size,), onPressed: () => onPressed(context));
}
