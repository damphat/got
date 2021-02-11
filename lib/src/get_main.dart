import 'package:get/get.dart';

class GetMain with GetContainer {
  static GetMain _main = GetMain._();
  GetMain._();
  factory GetMain() => _main;
}

// ignore: non_constant_identifier_names
final Get = GetMain();
