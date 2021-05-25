class Usuario {
  int usuarioWebID;
  int vendedorID;
  String nombre;
  String domicilio;
  String telefono;
  String ciudad;
  String email;
  String rutas;
  String tokenWs;

  Usuario(
      {this.ciudad,
      this.domicilio,
      this.email,
      this.nombre,
      this.rutas,
      this.telefono,
      this.tokenWs,
      this.usuarioWebID,
      this.vendedorID});

  Usuario.fromJsonMap(Map<String, dynamic> json) {
    this.usuarioWebID = json['usuarioWebID'];
    this.vendedorID = json['vendedorId'];
    this.nombre = json['nombre'];
    this.domicilio = json['domicilio'];
    this.ciudad = json['ciudad'];
    this.email = json['email'];
    this.rutas = json['rutas'];
    this.tokenWs = json['tokenWs'];
  }
}
