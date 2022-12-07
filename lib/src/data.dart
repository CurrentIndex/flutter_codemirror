
class CodeMirrorStyle {
  final String? fontSize;

  CodeMirrorStyle({this.fontSize});

  Map<String, dynamic> toJson() {
    return {
      "fontSize": fontSize,
    };
  }
}

class CodeMirrorProps {
  final String? placeholder;
  final String? doc;
  final bool? autoDestroy;
  final int? tabSize;
  final bool? indentWithTab;
  final bool? disabled;
  final bool? autofocus;
  final CodeMirrorStyle? style;
  final Map<String, dynamic>? phrases;
  final String? language;
  final String? theme;

  CodeMirrorProps({
    this.placeholder,
    this.doc,
    this.autoDestroy,
    this.tabSize,
    this.indentWithTab,
    this.disabled,
    this.autofocus,
    this.style,
    this.phrases,
    this.language,
    this.theme,
  });

  Map<String, dynamic> toJson() {
    return {
      "placeholder": placeholder,
      "doc": doc,
      "autoDestroy": autoDestroy,
      "tabSize": tabSize,
      "indentWithTab": indentWithTab,
      "disabled": disabled,
      "autofocus": autofocus,
      "style": style?.toJson(),
      "phrases": phrases,
      "language": language,
      "theme": theme,
    };
  }
}
