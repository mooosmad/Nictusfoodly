import 'package:equatable/equatable.dart';
import 'package:nictusfood/services/api_services.dart';

class Product extends Equatable {
  // equatable est important ici pour distinguer les produits avec getx
  final int? productId;
  final String? productName;
  final String? productDesc;
  final String? status;
  final String? price;
  final String? regularPrice;
  final List? produitSuggere;
  final List? categories;
  final String? categorieName;
  final List<Imageproduct>? images;

  const Product({
    this.images,
    this.price,
    this.productDesc,
    this.productId,
    this.productName,
    this.regularPrice,
    this.status,
    this.produitSuggere,
    this.categories,
    this.categorieName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json["id"] ?? 0,
      productName: json["name"] ?? "",
      productDesc: json["description"] ?? "",
      price: json["price"].toString(),
      regularPrice: json["regular_price"] ?? "",
      status: json["status"] ?? "",
      produitSuggere: json["upsell_ids"] != null
          ? json["upsell_ids"].map((e) async {
              var r = await APIService().getProductById(e);
              return r;
            }).toList()
          : [],
      categories: json["categories"] ?? [],
      categorieName:
          json["categories"] != null ? json["categories"][0]["name"] : "",
      images: json["images"] != null
          ? json["images"]
              .map(
                (element) {
                  return Imageproduct.fromMap(element);
                },
              )
              .toList()
              .cast<Imageproduct>()
          : [],
    );
  }

  @override
  List<Object> get props => [
        productId!,
        productDesc!,
        productName!,
        images!,
        price!,
        regularPrice!,
        status!,
      ];
}

class Imageproduct extends Equatable {
  final int? id;
  final String? dateCreated;
  final String? dateModified;
  final String? srcPath;
  const Imageproduct(
      {this.dateCreated, this.id, this.dateModified, this.srcPath});

  factory Imageproduct.fromMap(Map<String, dynamic> json) {
    return Imageproduct(
      id: json["id"],
      dateCreated: json["date_created"],
      dateModified: json["date_modified"],
      srcPath: json["src"],
    );
  }
  @override
  List<Object> get props => [
        id!,
        dateCreated!,
        dateModified!,
        srcPath!,
      ];
}
