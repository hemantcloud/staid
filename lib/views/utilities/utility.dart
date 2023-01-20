import 'package:intl/intl.dart';
class Utility{
  String DatefomatToReferDate(String bigTime) {
    DateTime tempDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(bigTime);
    // var dateFormat = DateFormat("MM-dd-yyyy"); // you can change the format here
    var dateFormat = DateFormat.jm(); // you can change the format here
    var utcDate = dateFormat.format(tempDate); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, false).toLocal().toString();
    String createdDate = dateFormat.format(DateTime.parse(localDate));
    // print("formated date is------------$createdDate");
    return createdDate;
  }
}