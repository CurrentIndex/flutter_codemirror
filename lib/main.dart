import 'package:flutter/material.dart';
import 'package:flutter_codemirror/codemirror.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const CodeMirrorView(),
    );
  }
}

class CodeMirrorView extends StatefulWidget {
  const CodeMirrorView({Key? key}) : super(key: key);

  @override
  State<CodeMirrorView> createState() => _CodeMirrorViewState();
}

class _CodeMirrorViewState extends State<CodeMirrorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Codemirror"),
      ),
      body: CodeMirror(
        onCreated: (CodeMirrorController controller) {
          controller.createItem(name: "name", props: CodeMirrorProps());
          controller.selectItem(name: "name");
        },
        onItemReadied: (String name) {},
        onItemUpdated: (String name) {},
      ),
    );
  }
}
