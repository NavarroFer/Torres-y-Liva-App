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
    this.usuarioWebID = int.tryParse(json['usuarioWebID']) ?? 0;
    this.vendedorID = int.tryParse(json['vendedorId']) ?? 0;
    this.nombre = json['nombre'];
    this.domicilio = json['domicilio'];
    this.ciudad = json['ciudad'];
    this.email = json['email'];
    this.rutas = json['rutas'];
    this.tokenWs = json['tokenWs'];
  }
}
