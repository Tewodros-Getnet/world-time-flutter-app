import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:world_time/services/world_time.dart';
class ChooseLocation extends StatefulWidget {
  const ChooseLocation({super.key});

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  List<WorldTime> locations = [
    WorldTime(url: 'Africa/Addis_Ababa', location: 'Ethiopia - Addis Ababa', flag: 'ethiopia-flag.png'),
    WorldTime(url: 'Asia/Jakarta', location: 'Indonesia - Jakarta ', flag: 'indonesia-flag.png'),
    WorldTime(url: 'Asia/Seoul', location: 'South Korea - Seoul', flag: 'south-korea-flag.png'),
    WorldTime(url: 'America/New_York', location: 'USA - New York', flag: 'usa-flag.png'),
    WorldTime(url: 'America/Chicago', location: 'USA - Chicago', flag: 'usa-flag.png'),
    WorldTime(url: 'Europe/Athens', location: 'Greece - Athens', flag: 'greece-flag.png'),
    WorldTime(url: 'Europe/London', location: 'UK - London', flag: 'uk-flag.png'),
    WorldTime(url: 'Europe/Paris', location: 'France - Paris', flag: 'france-flag.png'),
    WorldTime(url: 'Africa/Cairo', location: 'Egypt - Cairo', flag: 'egypt-flag.png'),
    WorldTime(url: 'America/Toronto', location: 'Canada - Toronto', flag: 'canada-flag.png'),

  ];


  void updateTime(index) async{
    WorldTime instance = locations[index];
    await instance.getTime();
    if (!instance.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load time. Check your internet connection.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDayTime': instance.isDayTime,
    });
    }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.cyan[600],
          title: Text('Choose Location'),
          centerTitle: true,
          elevation: 0,
        ),
      body: ListView.builder(
        itemCount: locations.length,
          itemBuilder: (context, index){

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
            child: Card(
              child: ListTile(
                onTap: () {
                  updateTime(index);
                },
                title: Text(locations[index].location),
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/${locations[index].flag}'),
                ),

              ),
            ),
          );
          })
    );
  }
}
