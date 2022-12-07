String jsInTempStrConvert(String text) {
  var val = _jsInTempStrConvert(text, 0, text.length);
  return val ?? text;
}

String? _jsInTempStrConvert(String text, int start, int end) {
  StringBuffer? result;
  for (var i = start; i < end; i++) {
    var ch = text[i];
    String? replacement;
    switch (ch) {
      case r'`':
        replacement = r'\`';
        break;
      case r'$':
        replacement = r'\$';
        break;
    }
    if (replacement != null) {
      result ??= StringBuffer();
      if (i > start) result.write(text.substring(start, i));
      result.write(replacement);
      start = i + 1;
    }
  }
  if (result == null) return null;
  if (end > start) result.write(text.substring(start, end));
  return result.toString();
}


String jsInQuotesStrConvert(String text) {
  var val = _jsInQuotesStrConvert(text, 0, text.length);
  return val ?? text;
}

String? _jsInQuotesStrConvert(String text, int start, int end) {
  StringBuffer? result;
  for (var i = start; i < end; i++) {
    var ch = text[i];
    String? replacement;
    switch (ch) {
      case r'\"':
        replacement = r'"';
        break;
      case r'\\':
        replacement = r'\';
        break;
    }
    if (replacement != null) {
      result ??= StringBuffer();
      if (i > start) result.write(text.substring(start, i));
      result.write(replacement);
      start = i + 1;
    }
  }
  if (result == null) return null;
  if (end > start) result.write(text.substring(start, end));
  return result.toString();
}