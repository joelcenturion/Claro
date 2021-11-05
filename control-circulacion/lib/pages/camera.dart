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
  bool error = false;
  Map data = {
    'image2.jpg': {'image1.jpg': 5}
  };
  Future<void> faceRecognition() async {
    try {
      String url = 'http://192.168.100.73:8080/';
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
        print(dataTemp);
        setState(() {
          if (dataTemp['image2.jpg']['image1.jpg'] != 5) {
            data = dataTemp;
            print(data);
          }
        });
      } else {
        error = true;
      }
    } catch (e) {
      print('ERRORRRR');
      print(e);
      error = true;
    }
  }

  void doFaceRecognition() async {
    await faceRecognition();

    if (data['image2.jpg']['image1.jpg'] < 0.900) {
      Global.recoResult = true;
      Global.message = 'RECO FACIAL POSITIVO';
    } else {
      Global.recoResult = false;
      Global.message = 'RECO FACIA NEGATIVO';
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
      'widht': 140.0
    });
  }

  File? image;
  Uint8List? displayImage;

  Future pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) {
        Navigator.pop(context);
        return;
      }
      displayImage = await image.readAsBytes();
      print('displayImage = await image.readAsBytes()');
      Global.photoBytes = displayImage!;

      File imageTemporary = File(image.path);
      final image1 = img.decodeImage(File(image.path).readAsBytesSync())!;
      final thumbnail = img.copyResize(image1, width: 145, height: 180);
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

  showImage() {
    if (displayImage != null) {
      return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.indigo[800],
          title: Text(
            'Reconocimiento Facial',
            style: GoogleFonts.irishGrover(fontSize: 20, letterSpacing: 2.0),
          ),
        ),
        body: Center(
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(
                  displayImage!,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  showAlert(bool input) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(milliseconds: 700), () {
            Navigator.pop(context);
          });
          var screen = MediaQuery.of(context).size;
          if (input) {
            return Container(
              child: AlertDialog(
                backgroundColor: Colors.green,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.done_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    Text(
                      '   Coincidente',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                insetPadding: EdgeInsets.only(
                    bottom: screen.height * 0.8,
                    left: screen.width * 0.2,
                    right: screen.width * 0.2),
                titlePadding: EdgeInsets.symmetric(vertical: 13),
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: AlertDialog(
                backgroundColor: Colors.red,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.close_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    Text(
                      '   NO Coincidente',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                insetPadding: EdgeInsets.only(
                    bottom: screen.height * 0.8,
                    left: screen.width * 0.2,
                    right: screen.width * 0.2),
                titlePadding: EdgeInsets.symmetric(vertical: 13),
              ),
            );
          }
        });
  }
}
