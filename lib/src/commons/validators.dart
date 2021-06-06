// VALID USER
bool validEmail(String email) {
  return RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(email);
}

bool validPassword(String password) {
  return password.isNotEmpty && password.length > 5;
}

bool validName(String name) {
  return name.isNotEmpty && name.length > 1;
}

// VALID LYRIC
bool validLyricField(String field) {
  return field.isNotEmpty && field.length > 1;
}

bool validTone(String tone) {
  return tone.isNotEmpty &&
      tone.length <= 3 &&
      tone.length >= 1 &&
      RegExp(r"^[a-gA-G]{1}").hasMatch(tone);
}

bool validVideoUrl(String uri) {
  String url = 'https://youtu.be/';
  return uri.isEmpty || (uri.startsWith(url) && uri.length > url.length);
}
