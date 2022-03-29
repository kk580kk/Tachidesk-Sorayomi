import 'package:get/get.dart';

import '../../../core/values/db_keys.dart';
import '../../../data/services/local_storage_service.dart';

class BrowseSettingsController extends GetxController {
  final LocalStorageService localStorageService =
      Get.find<LocalStorageService>();
  late RxBool _showNSFW;
  bool get showNSFW => _showNSFW.value;

  set showNSFW(bool value) => _showNSFW.value = value;

  @override
  void onInit() {
    _showNSFW = localStorageService.showNSFW.obs;
    localStorageService.box.listenKey(showNsfwKey, (value) {
      showNSFW = value;
    });
    super.onInit();
  }
}
