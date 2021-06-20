import 'package:intl/intl.dart';

class DateTimeHelper {
  static String getTxtWeek({int offset}) {
    var fmt = DateFormat('dd/MM');
    var d1 = getWeek(offset: offset)['weekStart'];
    var d2 = getWeek(offset: offset)['weekEnd'];

    return 'Semana de ${fmt.format(d1)} a ${fmt.format(d2)}';
  }

  static Map<String, DateTime> getWeekFilter({int offset}) {
    var d1 = getWeek(offset: offset)['weekStart'];
    var d2 = getWeek(offset: offset)['weekEnd'];

    d1 = d1.subtract(Duration(minutes: 1));
    d2 = d2.add(Duration(minutes: 1));

    return {'weekStart': d1, 'weekEnd': d2};
  }

  static Map<String, DateTime> getWeek({int offset}) {
    offset = offset ?? 0;
    var now = DateTime.now();
    var midnight = DateTime(now.year, now.month, now.day);
    var weekday = midnight.weekday;
    var d1 = midnight.subtract(Duration(days: weekday - 1));
    d1 = d1.add(Duration(days: 7 * offset));
    var d2 = d1.add(Duration(days: 7));
    d2 = d2.subtract(Duration(minutes: 1));

    return {'weekStart': d1, 'weekEnd': d2};
  }
}
