import 'package:flutter/material.dart';
import 'package:torres_y_liva/src/widgets/dialog_box_widget.dart';

Widget action(BuildContext context,
    {IconData icon, double size = 24.0, void onPressed(BuildContext context)}) {
  return IconButton(
      icon: Icon(
        icon,
        size: size,
      ),
      onPressed: () => onPressed(context));
}

void showError(String s, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: 'Error',
          descriptions: s ?? '',
          textBtn1: "Aceptar",
          icon: Icons.warning,
          alert: true,
        );
      });
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
  ScaffoldMessenger.of(c).showSnackBar(SnackBar(
    content: Text(mensaje),
    duration: Duration(milliseconds: 2200),
  ));
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
