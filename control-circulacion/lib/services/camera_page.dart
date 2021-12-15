import 'package:flutter/material.dart';
import 'package:flutter_mrz_scanner/flutter_mrz_scanner.dart';
// import 'package:vibration/vibration.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool isParsed = false;
  MRZController? controller;
  Color claroColor = const Color(0xffDA291C);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Camera'),
      // ),
      body: MRZScanner(
        withOverlay: true,
        onControllerCreated: onControllerCreated,
      ),
    );
  }

  @override
  void dispose() {
    controller?.stopPreview();
    super.dispose();
  }

  void onControllerCreated(MRZController controller) {
    this.controller = controller;
    controller.onParsed = (result) async {
      if (isParsed) {
        return;
      }
      isParsed = true;
      // Vibration.vibrate();
      // Navigator.pop(context, result);
      print('//////////////////VIBRATE///////////////////////');
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Tipo de Documento: ${result.documentType}'),
              Text('País: ${result.countryCode}'),
              Text('Nombre: ${result.givenNames}'),
              Text('Apellido: ${result.surnames}'),
              Text('Número de Documento: ${result.documentNumber}'),
              // Text('Nationality code: ${result.nationalityCountryCode}'),
              Text(
                  'Fecha de Nacimiento: ${result.birthDate.toString().substring(0, 10)}'),
              Text('Sexo: ${result.sex.toString() == 'Sex.male' ? 'M' : 'F'}'),
              Text(
                  'Fecha de Vencimiento: ${result.expiryDate.toString().substring(0, 10)}'),
              // Text('Personal number: ${result.personalNumber}'),
              // Text('Personal number 2: ${result.personalNumber2}'),
              // ElevatedButton(
              //   child: const Text('OK'),
              //   onPressed: () {
              //     isParsed = false;
              //     return Navigator.pop(context);
              //   },
              // ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: claroColor),
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            )
          ],
        ),
      );
      // Navigator.pop(context, result);
    };
    controller.onError = (error) => print(error);
    print('STARPREVIEW///////////////////');
    controller.startPreview();
  }
}
