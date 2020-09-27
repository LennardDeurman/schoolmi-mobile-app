import 'package:intl/intl.dart';
class Dates {

  static const String sqlDateFormat = "E, d MMM y HH:mm:ss";

  static const String dateTimeFormat = "d-MM-y HH:mm:ss";
  static const String friendlyFormat = "EEEE d MMMM y HH:mm";

  static DateTime parse(dynamic input) {
    try {
      return DateTime.fromMillisecondsSinceEpoch(input);
    } catch (e) {
      return null;
    }
  }

  static int format(DateTime dateTime) {
    if (dateTime == null)
      return null;
    return dateTime.millisecondsSinceEpoch;
  }

  static String formatAsString(DateTime sqlDateTime, {String format = sqlDateFormat}) {
    if (sqlDateTime != null) {
      DateFormat dateFormat = new DateFormat(format, "nl");
      return dateFormat.format(sqlDateTime);
    }
    return null;
  }

}