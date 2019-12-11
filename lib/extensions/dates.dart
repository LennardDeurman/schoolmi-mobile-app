import 'package:intl/intl.dart';
class Dates {

  static const String sqlDateFormat = "E, d MMM y HH:mm:ss";

  static const String dateTimeFormat = "d-MM-y HH:mm:ss";
  static const String friendlyFormat = "EEEE d MMMM y HH:mm";

  static DateTime parse(String sqlDateString) {
    try {
      if (sqlDateString != null) {
        return new DateFormat(sqlDateFormat).parse(sqlDateString);
      }
    } catch (e) {
    }
    return null;
  }


  static String format(DateTime sqlDateTime, {String format = sqlDateFormat}) {
    if (sqlDateTime != null) {
      DateFormat dateFormat = new DateFormat(format, "nl");
      return dateFormat.format(sqlDateTime);
    }
    return null;
  }

}