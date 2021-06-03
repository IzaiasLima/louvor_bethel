class StringHelper {
  static String capitalize(String string) {
    if (string.isEmpty) {
      return string;
    }
    return string[0].toUpperCase() + string.substring(1);
  }

  static String listToString(List list) {
    String str = '';

    if (list != null && list.length > 0) {
      str = list.toString();
      str = str.replaceAll('[', '');
      str = str.replaceAll(']', '');
    }
    return str;
  }
}
