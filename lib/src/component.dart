import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_assets_server/local_assets_server.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'data.dart';
import 'escape.dart';
import 'invoker.dart';

const _createItem = "\$createItem";
const _deleteItem = "\$deleteItem";
const _selectItem = "\$selectItem";
const _containItem = "\$containItem";
const _itemDoc = "\$itemDoc";
const _itemUndo = "\$itemUndo";
const _itemRedo = "\$itemRedo";
const _itemUndoDepth = "\$itemUndoDepth";
const _itemRedoDepth = "\$itemRedoDepth";
const _itemProps = "\$itemProps";

abstract class _CodeMirrorController {
  Future<bool> createItem({required String name, required CodeMirrorProps props});

  Future<bool> deleteItem({required String name});

  Future<bool> selectItem({String? name});

  Future<bool> containItem({required String name});

  Future<bool> itemUndo({required String name});

  Future<bool> itemRedo({required String name});

  Future<int> itemUndoDepth({required String name});

  Future<int> itemRedoDepth({required String name});

  Future<bool> itemProps({required String name, required CodeMirrorProps props});

  Future<String> doc({required String name});
}

class CodeMirrorController implements _CodeMirrorController {
  final Invoker _invoker;

  CodeMirrorController._(this._invoker);

  @override
  Future<bool> containItem({required String name}) async {
    final ret = await _invoker.invokeWithReturn(_containItem, [name]);
    return ret == "true";
  }

  @override
  Future<bool> createItem({required String name, required CodeMirrorProps props}) async {
    final ret = await _invoker.invokeWithReturn(_createItem, [name, props.toJson()]);
    return ret == "true";
  }

  @override
  Future<bool> deleteItem({required String name}) async {
    final ret = await _invoker.invokeWithReturn(_deleteItem, [name]);
    return ret == "true";
  }

  @override
  Future<bool> selectItem({String? name}) async {
    final ret = await _invoker.invokeWithReturn(_selectItem, [name]);
    return ret == "true";
  }

  @override
  Future<bool> itemProps({required String name, required CodeMirrorProps props}) async {
    final ret = await _invoker.invokeWithReturn(_itemProps, [name, props.toJson()]);
    return ret == "true";
  }

  @override
  Future<bool> itemRedo({required String name}) async {
    final ret = await _invoker.invokeWithReturn(_itemRedo, [name]);
    return ret == "true";
  }

  @override
  Future<bool> itemUndo({required String name}) async {
    final ret = await _invoker.invokeWithReturn(_itemUndo, [name]);
    return ret == "true";
  }

  @override
  Future<int> itemRedoDepth({required String name}) async {
    var ret = await _invoker.invokeWithReturn(_itemRedoDepth, [name]);
    return int.parse(ret);
  }

  @override
  Future<int> itemUndoDepth({required String name}) async {
    var ret = await _invoker.invokeWithReturn(_itemUndoDepth, [name]);
    return int.parse(ret);
  }

  @override
  Future<String> doc({required String name}) async {
    var ret = await _invoker.invokeWithReturn(_itemDoc, [name]);
    return (jsonDecode(ret) as List<dynamic>).map((e) => jsInQuotesStrConvert(e)).toList().join("\n");
  }
}

class CodeMirror extends StatefulWidget {
  const CodeMirror({
    Key? key,
    required this.onCreated,
    required this.onItemReadied,
    required this.onItemUpdated,
  }) : super(key: key);
  final void Function(CodeMirrorController controller) onCreated;
  final void Function(String name) onItemUpdated;
  final void Function(String name) onItemReadied;

  @override
  State<CodeMirror> createState() => _CodeMirrorState();
}

class _CodeMirrorState extends State<CodeMirror> {
  late final WebViewController _controller;
  LocalAssetsServer? _localAssetsServer;
  String? _localURL;

  @override
  void initState() {
    super.initState();
    final server = LocalAssetsServer(
      address: InternetAddress.loopbackIPv4,
      assetsBasePath: 'packages/flutter_codemirror/codemirror',
    );
    server.serve().then((address) {
      setState(() {
        _localAssetsServer = server;
        _localURL = "http://${address.address}:${server.boundPort!}/";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final codemirrorURL = _localURL;
    if (codemirrorURL != null) {
      return WebView(
        zoomEnabled: false,
        javascriptMode: JavascriptMode.unrestricted,
        backgroundColor: Colors.transparent,
        onWebViewCreated: (controller) {
          _controller = controller;
          _controller.loadUrl(codemirrorURL);
          debugPrint(codemirrorURL);
        },
        onPageFinished: (_) {
          debugPrint("onPageFinished .. $_");
          if (_ != codemirrorURL) return;
          widget.onCreated(CodeMirrorController._(Invoker(_controller)));
        },
        javascriptChannels: {
          JavascriptChannel(name: "_onReadied", onMessageReceived: (message) => widget.onItemReadied(message.message)),
          JavascriptChannel(name: "_onUpdated", onMessageReceived: (message) => widget.onItemUpdated(message.message)),
        },
      );
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _localAssetsServer?.stop();
  }
}
