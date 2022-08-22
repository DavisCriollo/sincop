class CreaNuevaFotoInformeGuardias {
  int id;
  String path;

  CreaNuevaFotoInformeGuardias(
    this.id,
    this.path,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
    };
  }
}

class CreaNuevaFotoAvisoSalida {
  int id;
  String path;

  CreaNuevaFotoAvisoSalida(
    this.id,
    this.path,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
    };
  }
}
class CreaNuevaFotoausencias {
  int id;
  String path;

  CreaNuevaFotoausencias(
    this.id,
    this.path,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
    };
  }
}


class CreaNuevaFotoRealizaActividadGuardia {
  int id;
  String path;

  CreaNuevaFotoRealizaActividadGuardia(
    this.id,
    this.path,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
    };
  }
}