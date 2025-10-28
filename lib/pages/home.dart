import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  Map data = {};

  @override
  Widget build(BuildContext context) {

    data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;
    print(data);
    String bgImage = data['isDayTime'] ? 'day.jpg' : 'night.jpg';
    Color? bgColor = data['isDayTime'] ? Colors.blue : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(padding: const EdgeInsets.fromLTRB(0,140,0,0),
          child: Column(
          children: <Widget>[
            TextButton.icon(
              onPressed: () async{
                dynamic result = await Navigator.pushNamed(context, '/location');
                if (result != null) {
                  setState(() {
                    data = {
                      'time': result['time'],
                      'location': result['location'],
                      'isDayTime': result['isDayTime'],
                      'flag': result['flag'],
                    };
                  });
                }
              },

              icon: Icon(
                Icons.edit_location,
                color: Colors.white,
              ),
              label: Text(
                  'Edit Location',
                  style: TextStyle(
                  color: Colors.white,
                    fontSize: 25.0,
              ),
              ),

            ),

            SizedBox(height: 20.0),

            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  data['location'],
                  style: TextStyle(
                    fontSize: 28.0,
                    letterSpacing: 2.0,
                    color: Colors.white,
                  ),
                ),
              ],
                ),

            SizedBox(height: 80.0),
            Text(
              data['time'],
              style: TextStyle(
                fontSize: 60.0,
                letterSpacing: 2.0,
                color: Colors.white,
                shadows: [
                  Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black54),
                ],
              ),
            ),
          ]),
          ),
        ),
      ));
    }
}
