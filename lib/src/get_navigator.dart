import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin NavigatorExtension on GetMain {
  var _key = GlobalKey<NavigatorState>();
  Key get key => _key;
  NavigatorState get navigator => _key.currentState;

  Future to(Widget widget) {
    return navigator.push(MaterialPageRoute(builder: (_) => widget));
  }

  void pop<T extends Object>([T result]) {
    return navigator.pop();
  }
}
