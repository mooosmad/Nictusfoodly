import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nictusfood/models/product.dart';
import 'package:nictusfood/screens/detailsPage.dart';

import '../services/config.dart';

class MySearch extends SearchDelegate {
  List<Product>? products;
  MySearch({required this.products});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.trim().isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> suggestions = products!.where((element) {
      var result = element.productName!.toLowerCase();
      var input = query.toLowerCase();
      return result.startsWith(input);
    }).toList();
    print("*********------------------");
    print(suggestions);
    print("*********------------------");

    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return cardProduct(suggestions[index]);
        });
  }

  Widget cardProduct(Product product) {
    return InkWell(
      onTap: () {
        Get.to(
            DetailPage(
              product: product,
            ),
            transition: Transition.rightToLeft);
      },
      child: Container(
        // color: Colors.red,
        margin: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Row(
          children: [
            Container(
              width: 99,
              height: 99,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: Offset(0.5, .5),
                    blurRadius: 2.0,
                    spreadRadius: .5,
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(product.images![0].srcPath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 100,
                // color: Colors.red,
                padding: EdgeInsets.only(top: 5, right: 5, left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.productName!,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            '${product.price!}FCFA',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Text(
                        Config().parserHTMLTAG(product.productDesc!),
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
