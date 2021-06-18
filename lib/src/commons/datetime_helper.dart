import 'package:intl/intl.dart';

class DateTimeHelper {
  static String getWeek() {
    var fmt = DateFormat('dd/MM');
    var weekday = DateTime.now().weekday;
    var d1 = DateTime.now().subtract(Duration(days: weekday));
    var d2 = d1.add(Duration(days: 7));

    return 'Semana de ${fmt.format(d1)} a ${fmt.format(d2)}';
  }
}
