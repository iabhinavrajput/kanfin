import 'package:get/get.dart';
import 'package:kifinserv/controller/home/home_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
