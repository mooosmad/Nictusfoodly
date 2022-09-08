class Category {
  int? categoryId;
  String? categoryName;
  String? slug;
  String? categoryDesc;
  int? parent;
  String? image;

  Category({
    required this.slug,
    this.categoryId,
    this.categoryName,
    this.categoryDesc,
    this.image,
  });

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json["id"];
    categoryName = json["name"];
    slug = json["slug"];
    categoryDesc = json["description"];
    parent = json["parent"];
    image = json["image"] != null
        ? json["image"]["src"]
        : "https://img.cuisineaz.com/680x357/2016/09/23/i51334-recettes-africaines.jpg";
  }
}
