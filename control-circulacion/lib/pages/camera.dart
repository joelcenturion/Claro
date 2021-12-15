// import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:app/services/person_data.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:image/image.dart' as img;
// import 'package:flutter_spinkit/flutter_spinkit.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  //En caso de que haya algún error con openface ó landmark
  bool error = false;
  Map data = {
    'image2.jpg': {'image1.jpg': 5}
  };
  Future<void> faceRecognition() async {
    try {
      String url = 'http://190.104.149.238:8080/';
      http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'image1': Global.ciBase64,
          'image2': Global.cameraBase64,
        }),
      );
      print('STATUS CODE ${response.statusCode}');
      if (response.statusCode == 200) {
        Map dataTemp = convert.jsonDecode(response.body);
        print('dataTemp');
        print(dataTemp);

        if (!(dataTemp['image2.jpg']).isEmpty) {
          // if (dataTemp['image2.jpg']['image1.jpg'] != 5) {
          data = dataTemp;
          print('Data: $data');
          // }
        } else {
          print('NO FACES.........');
          error = true;
          Global.noFaces = true;
        }
      } else {
        error = true;
      }
    } catch (e) {
      print('ERROR FACE RECOGNITION');
      print('Error: $e');
      error = true;
    }
    Global.photoBytes = convert.base64Decode(Global.cameraBase64);
    if (!error) {
      print('Landmark detection starting...........');
      Uint8List landmark_data;
      try {
        String url = 'http://190.104.149.238:8081/';
        http.Response response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: convert.jsonEncode(<String, String>{
            'image': Global.cameraBase64,
          }),
        );
        if (response.statusCode == 200) {
          landmark_data =
              convert.base64Decode(convert.jsonDecode(response.body));
          Global.photoBytes = landmark_data;
        }
      } catch (e) {
        print('ERROR LANDMARK');
      }
    } else {
      Global.photoBytes = convert.base64Decode(Global.cameraBase64);
    }
  }

  void doFaceRecognition() async {
    await faceRecognition();

    if (data['image2.jpg']['image1.jpg'] < 0.900) {
      Global.message = 'RECO FACIAL POSITIVO';
    } else {
      Global.message = 'RECO FACIAL NEGATIVO';
    }

    Navigator.pushReplacementNamed(context, '/person', arguments: {
      'message': Global.message,
      'name': Global.name,
      'ci': Global.ci,
      'born_date': Global.bornDate,
      'dosage': Global.dosage,
      'vaccine': Global.vaccine,
      'photoBytes': Global.photoBytes,
      'height': 210.0,
      'widht': 160.0,
      'first_name': Global.first_name,
      'last_name': Global.last_name,
      'vaccine_date': Global.vaccine_date,
      'descripcion': Global.descripcion,
    });
  }

  File? image;
  Uint8List? displayImage;

  Future pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) {
        Global.pages--;
        print('Global.pages: ${Global.pages}');
        Navigator.pop(context);
        return;
      }

      print('displayImage = await image.readAsBytes()');

      File imageTemporary = File(image.path);
      final image1 = img.decodeImage(File(image.path).readAsBytesSync())!;
      final thumbnail = img.copyResize(image1, width: 135, height: 180);
      imageTemporary.writeAsBytes(img.encodePng(thumbnail));
      setState(() {
        this.image = imageTemporary;
        print('this.image = imageTemporary;');
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void startCamera() async {
    await pickImage();
    print('despues de pickimage');
    final path = this.image!.path;
    final bytes = await File(path).readAsBytes();
    Global.cameraBase64 = convert.base64Encode(bytes);
    print('do faceRecognition');
    doFaceRecognition();
  }

  @override
  void initState() {
    super.initState();
    startCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
