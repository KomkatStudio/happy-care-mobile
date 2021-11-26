import 'package:get/get.dart';
import 'package:happy_care/data/models/specialization.dart';
import 'package:happy_care/data/models/user.dart';
import 'package:happy_care/modules/main_screen/controller/doctor_controller.dart';
import 'package:happy_care/modules/main_screen/controller/spec_controller.dart';

class ChatSearchController extends GetxController {
  var status = Status.idle.obs;
  final SpecController _specController = Get.find();
  final DoctorController doctorController = Get.find();
  List<Specialization> listSpec = [];
  Specialization? selected;
  List<User> listDoctor = [];

  @override
  void onInit() {
    listSpec = [
      Specialization(id: null, name: "Tất cả"),
      ..._specController.listSpec
    ];
    listDoctor = doctorController.listDoctor;
    super.onInit();
  }

  categorySelected(Specialization value) async {
    selected = value;
    listDoctor = await doctorController.getDoctorMaybeBySpecId(id: value.id);
    update();
  }
}
