import 'package:get/get.dart';

class CheckIfSignGoogle extends GetxController {
  var islogin = false.obs;

  changeStatut(bool newStatus) {
    islogin.value = newStatus;
  }
}
