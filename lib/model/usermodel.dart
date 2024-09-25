class ClientUserModel {
  String? cid;
  String? email;
  String? name;

  ClientUserModel(
      {this.cid, this.email, this.name,}
      );

  // receiving data from server
  factory ClientUserModel.fromMap(map) {
    return ClientUserModel(
      cid: map['cid'],
      email: map['email'],
      name: map['name'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'cid': cid,
      'email': email,
      'name': name,
    };
  }
}
