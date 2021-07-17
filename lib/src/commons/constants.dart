import 'package:flutter/material.dart';

class Constants {
  static String title = 'LOUVOR BETHEL';

  static const redColor = const Color.fromARGB(255, 210, 20, 45);
  static const grayColor = Color.fromARGB(255, 200, 200, 200);
  static const darkGray = Color.fromRGBO(98, 95, 90, 1);

  static const txtGood =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.green);
  static const txtDanger =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.red);
// User
  static String neededUserName = 'Informe qual será seu nome no aplicativo.';
  static String validEmail = 'Informe um email válido.';
  static String validPwd = 'A senha dever ter seis caracteres ou mais.';
  static String neededEqPwd = 'As senhas precisam ser iguas.';

// Lyric
  static String validTitle = 'Informe o título da música.';
  static String validStanza = 'Informe o início da primeira estrofe.';
  static String validChorus = 'Informe o início do coro.';
  static String validStyle = 'Informe a temática ou estilo musical.';
  static String validTone = 'Informe uma nota musical.';
  static String validPdf = 'Selecione o PDF com a cifra, a ser anexado.';
  static String validVideoUrl = 'Informe o link do video no Youtube.';

  // Worship
  static String validDescription = 'Dê um nome para o evento ou momento.';
  static String validDateTime = 'Informe a data e hora do evento.';
}
