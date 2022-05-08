class CustomerModel {
  final String? email;
  final String? firstname;
  final String? lastname;
  final String? password;
  final String? adresse;
  final String? ville;
  final String? phone;

  const CustomerModel(this.email, this.firstname, this.lastname, this.password,
      this.adresse, this.ville, this.phone);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.addAll({
      'email': email,
      'first_name': firstname,
      'last_name': lastname,
      'password': password,
      'username': email,
      'billing': {
        "first_name": firstname,
        "last_name": lastname,
        "company": "",
        "address_1": adresse,
        "address_2": "",
        "city": ville,
        "state": "",
        "postcode": "225",
        "country": "CI",
        "email": email,
        "phone": phone,
      },
      'shipping': {
        "first_name": firstname,
        "last_name": lastname,
        "company": "",
        "address_1": adresse,
        "address_2": "",
        "city": ville,
        "state": "",
        "postcode": "225",
        "country": "CI",
      },
      //shipping est info pour expedition (la livraison) et billing pour la facturation
    });
    return map;
  }
}
