import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:textrecognition/screens/camera_screen.dart';

List<CameraDescription> cameras = [];   // List of cameras available


Future<void> main() async{
  try{
    WidgetsFlutterBinding.ensureInitialized();
    //Retrieve device cameras
    cameras = await availableCameras();
  }on CameraException catch(e){
    print(e);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text Recognition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraScreen(),
    );
  }
}
