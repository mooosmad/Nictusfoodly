import "package:hive/hive.dart";
part "customer.g.dart";

@HiveType(typeId: 0)
class Customer {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? dateCreated;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? nom;

  @HiveField(4)
  final String? prenom;

  @HiveField(5)
  String? urlPic;

  @HiveField(6)
  final String? adresse;

  @HiveField(7)
  final String? ville;

  @HiveField(8)
  final String? phone;

  Customer({
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

  Customer changeNumber(String newnumber) {
    return Customer(
      id: id,
      dateCreated: dateCreated,
      email: email,
      nom: nom,
      prenom: prenom,
      urlPic: urlPic,
      adresse: adresse,
      ville: ville,
      phone: newnumber,
    );
  }
}
