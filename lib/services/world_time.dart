import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location;
  String time = 'Loading...';
  String flag;
  String url;
  bool isDayTime = true;
  bool success = false;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      final response = await http.get(
        Uri.parse('https://timeapi.io/api/Time/current/zone?timeZone=$url'),
      );

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        String dateTime = data['dateTime'];
        DateTime now = DateTime.parse(dateTime);
        isDayTime = now.hour > 6 && now.hour < 20;
        time = DateFormat.jm().format(now);
        success = true;
      } else {
        time = 'Could not fetch time';
      }
    } catch (e) {
      time = 'Oops! Something went wrong :(';
      isDayTime = true;
      success = false;
    }
  }
}
