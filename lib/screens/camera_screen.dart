import 'dart:io';

import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import '../main.dart';
import 'detail_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);    // cameras[0] is for back camera, ResolutionPreset is the quality of image
    _controller.initialize().then((_) {
      if(!mounted)
        return;

      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Future<String> _takePicture() async{

    if(!_controller.value.isInitialized){
      print("Controller is not initialized");
      return null;
    }

    String dateTime = DateFormat.yMMMMd()
        .addPattern('-')
        .add_Hms()
        .format(DateTime.now())
        .toString();

    String formattedDateTime = dateTime.replaceAll(" ", "");
    print('Formatted: $formattedDateTime');

    //Retrieving the path for saving an image
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

    // Checking whether the picture is being taken
    // to prevent execution of the function again
    // if previous execution has not ended
    if(_controller.value.isTakingPicture){
      print('Processing is in progress...');
      return null;
    }

    try{
      //Captures image and saves it to the provided path
      await _controller.takePicture(imagePath);
    }on CameraException catch(e){
      print('Camera Exception: $e');
      return null;
    }
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition'),
      ),
      body: _controller.value.isInitialized
          ? Stack(
        children: <Widget>[
          CameraPreview(_controller),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: RaisedButton.icon(
                  onPressed: () async{
                    await _takePicture().then((String path){
                      if(path != null){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(path),
                            )
                        );
                      }
                    });
                  },
                  icon: Icon(Icons.camera),
                  label: Text('Click'),
              ),
            ),
          ),
        ],
      )
          : Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
    );
  }
}
