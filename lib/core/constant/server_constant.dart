import 'dart:io';

class ServerConstant {
  ServerConstant._();

  static const bool isPhysicalDevice = false;

  static String serverUrl = isPhysicalDevice
      ? "http://10.129.170.163:8000"
      : Platform.isAndroid
      ? "http://10.0.2.2:8000"
      : "http://127.0.0.1:8000";
}
