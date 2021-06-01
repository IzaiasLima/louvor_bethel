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
bool validLyricField(String title) {
  return title.isNotEmpty && title.length > 1;
}

bool validTone(String tone) {
  return tone.isNotEmpty && tone.length <= 3 && tone.length >= 1;
}
