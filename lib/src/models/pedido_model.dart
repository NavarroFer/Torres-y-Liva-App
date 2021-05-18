import 'cliente_model.dart';
import 'producto_model.dart';

class Pedido {
  int id;
  Cliente cliente;
  List<Producto> items;
  double total;
  double neto;
  double iva;
  DateTime fechaHora;
  bool checked = false;

  Pedido(
      {this.id,
      this.cliente,
      this.items,
      this.total,
      this.neto,
      this.iva,
      this.fechaHora});
}
