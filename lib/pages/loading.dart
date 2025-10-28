import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/world_time.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.cyan,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      bool hasConnection = results.isNotEmpty &&
          !results.contains(ConnectivityResult.none);

      if (hasConnection && errorMessage != null) {
        setupWorldTime();
      }
    });


    setupWorldTime();
  }

  Future<void> setupWorldTime() async {
    setState(() {
      errorMessage = null; // Reset
    });

    // 🔍 Step 1: Check connectivity first
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        errorMessage = 'No internet connection. Please turn on Wi-Fi or mobile data.';
      });
      return;
    }

    // 🔄 Step 2: Proceed with API call if connected
    WorldTime instance = WorldTime(
      location: 'Ethiopia - Addis Ababa ',
      flag: 'ethiopia-flag.png',
      url: 'Africa/Addis_Ababa',
    );

    await instance.getTime();

    // 🧩 Step 3: Handle API errors
    if (instance.time == 'Oops! Something went wrong :(' ||
        instance.time == 'Could not fetch time') {
      setState(() {
        errorMessage = 'Failed to load time data. Please check your connection.';
      });
      return;
    }

    // 🚀 Step 4: Navigate to Home
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'location': instance.location,
      'flag': instance.flag,
      'time': instance.time,
      'isDayTime': instance.isDayTime,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: errorMessage == null
            ? SpinKitFadingCircle(
          color: Colors.white,
          size: 60.0,
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.red, size: 45),
            const SizedBox(height: 20),
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            // const SizedBox(height: 20),
            // ElevatedButton.icon(
            //   onPressed: setupWorldTime,
            //   icon: const Icon(Icons.refresh),
            //   label: const Text('Retry'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.cyan,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
