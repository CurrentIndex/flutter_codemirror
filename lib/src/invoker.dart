import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import 'escape.dart';

class Invoker {
  final WebViewController _controller;

  Invoker(this._controller);

  void invoke(String name, [List<dynamic>? arguments]) {
    _controller.runJavascript(_build(name, arguments));
  }

  Future<String> invokeWithReturn(String name, [List<dynamic>? arguments]) {
    return _controller.runJavascriptReturningResult(_build(name, arguments));
  }

  String _build(String name, [List<dynamic>? arguments]) {
    final source = StringBuffer();
    source.write('$name(');
    arguments ??= [];
    for (var i = 0; i < arguments.length; i++) {
      var argument = arguments[i];
      if (argument is String) {
        var s = _convertString(argument);
        source
          ..write("`")
          ..write(s)
          ..write("`");
      } else if (argument is int) {
        source.write(_convertInt(argument));
      } else if (argument is double) {
        source.write(_convertDouble(argument));
      } else if (argument is bool) {
        source.write(_convertBool(argument));
      } else if (argument is Map<String, dynamic>) {
        source.write(jsonEncode(argument));
      } else if (argument == null) {
        source.write("null");
      } else {
        throw ArgumentError("argument must be of basic data type or Map<String,dynamic>", "arguments");
      }
      if (i != arguments.length - 1) source.write(",");
    }
    source.write(');');
    return source.toString();
  }

  String _convertString(String s) {
    return jsInTempStrConvert(s);
  }

  String _convertInt(int i) {
    return i.toString();
  }

  String _convertDouble(double d) {
    return d.toString();
  }

  String _convertBool(bool b) {
    return b.toString();
  }
}
