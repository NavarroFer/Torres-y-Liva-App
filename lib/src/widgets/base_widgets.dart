import 'package:flutter/material.dart';

import '../pages/nuevo_pedido_page.dart';

Widget action(BuildContext context,
    {IconData icon, double size = 24.0, void onPressed(BuildContext context)}) {
  return IconButton(
      icon: Icon(
        icon,
        size: size,
      ),
      onPressed: () => onPressed(context));
}

Widget totalesVenta(
    BuildContext context, double neto, double iva, double total) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _columnaTotal(context, 'NETO', neto),
      _columnaTotal(context, 'IVA', iva),
      _columnaTotal(context, 'TOTAL', total),
    ],
  );
}



void mostrarSnackbar(String mensaje, BuildContext c) {
  final snackbar = SnackBar(
    content: Text(mensaje),
    duration: Duration(milliseconds: 1500),
  );
}

Widget _columnaTotal(BuildContext context, String titulo, double importe) {
  final size = MediaQuery.of(context).size;

  return Column(
    children: [
      Text(titulo),
      SizedBox(
        height: size.height * 0.01,
      ),
      Text(
        "\$ ${importe.toStringAsFixed(2)}",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  );
}
