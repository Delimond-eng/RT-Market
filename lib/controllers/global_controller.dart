import '../index.dart';

class GlobalController extends GetxController {
  //init controller
  static GlobalController instance = Get.find();

  //variables
  var devise = "".obs;
  var userRole = "".obs;
}
