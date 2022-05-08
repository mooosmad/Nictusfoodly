// ignore_for_file: non_constant_identifier_names

class Config {
  static String key = "ck_1bb6774c3979efcfe1378a8d9d199f1870e00ede";
  static String secret = "cs_9c89a8dbd8366786ac9d0cfcf937860a52bbff3d";
  static String url = "https://versamete.net/wp-json/wc/v3/";
  static String customerUrl = "customers";
  static String tokenUrl = "https://versamete.net/wp-json/jwt-auth/v1/token";

  String parserHTMLTAG(String input) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String output = input.replaceAll(exp, ' ');
    return output;
  }
}
