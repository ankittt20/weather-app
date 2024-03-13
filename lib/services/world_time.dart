import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WorldTime {
  late String location, time, flag, url;
  late bool isDayTime;

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      http.Response response = await http.get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);

        //getting properties from data
        String datetime = data['datetime'];
        String offset = data['utc_offset'].substring(1,3);

        //creating datetime object
        DateTime now = DateTime.parse(datetime);
        now = now.add(Duration(hours: int.parse(offset)));

        //setting time property
        isDayTime = now.hour > 6 && now.hour < 18 ? true : false;
        time = DateFormat.jm().format(now);
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}