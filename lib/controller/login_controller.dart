import 'package:get/get.dart';

import '../view/components/chat_page.dart';
import '../view/components/person_page.dart';



class LoginController extends GetxController {
  final isHidden =  true.obs;

  void toggle() {
    isHidden.value = !isHidden.value;
  }
}

class BottomNavController extends GetxController {
  var index = 0.obs;

  void changeIndex(int value) {
    index.value = value;
  }

  void navigateToPage(int index) {
    switch(index){
      case 0:
        Get.to(ChatPage());
        break;
      case 2:
        Get.to(PersonPage());
        break;
      default:
        Get.to(ChatPage());
    }
  }
}