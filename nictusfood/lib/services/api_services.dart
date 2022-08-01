// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nictusfood/controller/cart_state.dart';
import 'package:nictusfood/models/categorie.dart';
import 'package:nictusfood/models/customer.dart';
import 'package:nictusfood/models/customermodel.dart';
import 'package:nictusfood/models/ordermodel.dart';
import 'package:nictusfood/models/product.dart';
import 'package:nictusfood/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  final controller = Get.put(MyCartController());
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<Customer?> getUser(int id) async {
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}"),
    );
    try {
      var response = await Dio().get(
        "${Config.url}customers/$id",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return Customer.fromMap(response.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e.response);

      return null;
    }
  }

  Future<bool> updateUser(Map<String, dynamic> newmodel, int idUser) async {
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}"),
    );
    try {
      var response = await Dio().post(
        "${Config.url}customers/$idUser",
        data: newmodel,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      print("UPDATE USER  : ${response.statusCode}");

      if (response.statusCode == 200) {
        //get customer and update in box
        var customer = await APIService().getUser(idUser);
        var box = await Hive.openBox<Customer>('boxCustomer');
        box.put("customer", customer!);
        //end
        print("--------------");
        print(response.data);
        Fluttertoast.showToast(msg: "Information modifier avec succes");

        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
      print(e.response);
      Fluttertoast.showToast(
        msg: Config().parserHTMLTAG(e.response!.data["message"]),
      );
      return false;
    }
  }

  Future<List<dynamic>?> createCustomer(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}"),
    );

    List<dynamic>? ret;

    try {
      var response = await Dio().post(
        Config.url + Config.customerUrl,
        data: model.toJson(),
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("idUser", response.data["id"].toString());
        var customer =
            await APIService().getUser(int.parse(prefs.getString("idUser")!));
        var box = await Hive.openBox<Customer>('boxCustomer');
        box.put("customer", customer!);
        print("--------------");
        print(response.data);
        ret = [true, "reussi"];
      }
    } on DioError catch (e) {
      print(e);
      print(e.response);
      ret = [false, "erreur"];
      Fluttertoast.showToast(
        msg: Config().parserHTMLTAG(e.response!.data["message"]),
      );
    }
    return ret;
  }

  Future<bool?> socialLogin(String username, urlPicToAccount) async {
    try {
      var response = await Dio().post(
        Config.tokenUrl,
        data: {"username": username, "social_login": "true"},
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
          },
        ),
      );
      if (response.statusCode == 200) {
        var res = response.data;
        print(res);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("idUser", res["data"]["id"].toString());
        var customer =
            await APIService().getUser(int.parse(prefs.getString("idUser")!));
        customer!.urlPic = urlPicToAccount;
        var box = await Hive.openBox<Customer>('boxCustomer');
        box.put("customer", customer);

        print("--------------");
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e.response);

      Fluttertoast.showToast(
        msg: e.response!.data["message"],
      );
      return false;
    }
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("idUser", "-1");
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    Fluttertoast.showToast(msg: "Deconnexion effectué");
    controller.cart.clear();

    //delete in box
    var box = await Hive.openBox<Customer>('boxCustomer');
    box.delete("customer");
    //end
  }

  Future<bool?> loginCustomer(String username, String password) async {
    try {
      var response = await Dio().post(
        Config.tokenUrl,
        data: {"username": username, "password": password},
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        var res = response.data;

        print(response.data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("idUser", res["data"]["id"].toString());
        //get customer and add in box
        var customer =
            await APIService().getUser(int.parse(prefs.getString("idUser")!));
        var box = await Hive.openBox<Customer>('boxCustomer');
        box.put("customer", customer!);
        //end
        Fluttertoast.showToast(msg: "Connexion effectué");
        return res["success"];
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e.response);

      Fluttertoast.showToast(
        msg: e.response!.data["message"],
      );
      return false;
    }
  }

  Future<List<Category>?> getCategorie() async {
    List<Category> res = [];
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}"),
    );
    print("---GET CATEGORIES----");
    try {
      var response = await Dio().get(
        "https://versamete.net/wp-json/wc/v2/products/categories",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      response.data.forEach((element) {
        res.add(Category.fromJson(element));
      });
      res.removeWhere(
          (element) => element.categoryName!.toUpperCase() == 'NON CLASSÉ');
      print("---END GET CATEGORIES----");

      return res;
    } on DioError catch (e) {
      if (e.type == DioErrorType.other) {
        print("$e error in get categorie");
        Fluttertoast.showToast(
          msg: "Une erreur c'est produite veuillez réessayer",
        );
      } else {
        print("$e error in get categorie");

        Fluttertoast.showToast(
          msg: Config().parserHTMLTAG(e.toString()),
        );
      }

      return null;
    }
  }

  Future<List<Product>>? getProductByCategorie(int idCategory) async {
    List<Product>? res = [];
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}"),
    );
    try {
      var response = await Dio().get(
        "https://versamete.net/wp-json/wc/v2/products?category=$idCategory",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      response.data.forEach((element) {
        res.add(Product.fromJson(element));
      });
      return res;
    } on DioError catch (e) {
      print(e.message);

      Fluttertoast.showToast(
        msg: Config().parserHTMLTAG(
            "Une erreur est survenue veuillez verifier votre connection internet"),
      );
      return [];
    }
  }

  Future<Product?> getProductById(int idProduct) async {
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}"),
    );
    try {
      var response = await Dio().get(
        "https://versamete.net/wp-json/wc/v3/products/$idProduct",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      var res = Product.fromJson(response.data);
      return res;
    } on DioError catch (e) {
      print(e.message);

      Fluttertoast.showToast(
        msg: Config().parserHTMLTAG(
            "Une erreur est survenue veuillez verifier votre connection internet"),
      );
      return null;
    }
  }

  Future<List<dynamic>>? createCommande(
      String name,
      String adresseDeLivraison,
      String city,
      String email,
      String phone,
      List<Map<String, dynamic>> products,
      int idUser) async {
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}"),
    );
    var data = {
      "payment_method": "",
      "payment_method_title": "",
      "set_paid": true,
      "customer_id": idUser,
      "billing": {
        "first_name": name,
        "last_name": "",
        "address_1": adresseDeLivraison,
        "address_2": "",
        "city": city,
        "state": "",
        "postcode": "225",
        "country": "CI", // "CI or US"
        "email": email,
        "phone": phone,
      },
      "shipping": {
        "first_name": name,
        "last_name": "",
        "address_1": adresseDeLivraison,
        "address_2": "",
        "city": city,
        "state": "",
        "postcode": "225",
        "country": "",
      },
      "line_items": products,
      "shipping_lines": [
        {
          "method_id": "flat_rate",
          "method_title": "Flat Rate",
          "total": "1000.00"
        }
      ]
    };
    try {
      var response = await Dio().post(
        "https://versamete.net/wp-json/wc/v3/orders",
        data: data,
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        final res = Order.fromJson(response.data);
        return [true, res];
      }
      return [false];
    } on DioError catch (e) {
      print(e.toString());
      return [false];
    }
  }

  Future<List<Order>?> getOrder(int idUser) async {
    //not work
    print(idUser);
    var authToken = base64.encode(
      utf8.encode("${Config.key}:${Config.secret}"),
    );
    try {
      var response = await Dio().get(
        "https://versamete.net/wp-json/wc/v3/orders?customer=$idUser",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print("-------------RECUPERATION DES COMMANDES--------------");
        final res = response.data;
        List<Order> result = res
            .map((element) {
              return Order.fromJson(element);
            })
            .toList()
            .cast<Order>();
        return result;
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e.response);
      if (e.type == DioErrorType.other) {
        Fluttertoast.showToast(
          msg: Config().parserHTMLTAG("Aucune connexion internet"),
        );
      } else {
        Fluttertoast.showToast(
          msg: Config().parserHTMLTAG(e.response.toString()),
        );
      }

      return null;
    }
  }
}
