class Customer {
  final int? id;
  final String? dateCreated;
  final String? email;
  final String? nom;
  final String? prenom;
  final String? urlPic;
  final String? adresse;
  final String? ville;
  final String? phone;

  const Customer({
    this.dateCreated,
    this.email,
    this.id,
    this.nom,
    this.prenom,
    this.urlPic,
    this.adresse,
    this.phone,
    this.ville,
  });

  factory Customer.fromMap(Map json) {
    return Customer(
      id: json["id"],
      dateCreated: json["date_created"],
      email: json["email"],
      nom: json["first_name"],
      prenom: json["last_name"],
      urlPic: json["avatar_url"],
      adresse: json["billing"]["address_1"],
      ville: json["billing"]["city"],
      phone: json["billing"]["phone"],
    );
  }
}
