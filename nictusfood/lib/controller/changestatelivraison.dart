import 'package:get/get.dart';

class StateLivraison extends GetxController {
  var groupValue = "emporter".obs;

  changeValue(var newgroupValue) {
    groupValue.value = newgroupValue;
  }
}
