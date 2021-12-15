import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';

class PersonData {
  late String message;
  late String name;
  late String first_name;
  late String last_name;
  late String vaccine_date;
  late String ci;
  late String bornDate;
  late int dosage;
  late String vaccine;
  late String photoString;
  late final photoBytes;
  String? ciValue;
  late String url;

  PersonData({this.ciValue});

  Future<void> getData(BuildContext context) async {
    try {
      url =
          'https://mdi.bypar.com.py/check-data?document_number=$ciValue&api_key=7e9ef835066a907e4264caa94389a8695775bb94a8c66bf459ce423faab15c0f';
      http.Response response = await http.get(Uri.parse(url));
      //STATUS CODE
      
      print("STATUS CODE: ${response.statusCode} ");
      if (response.statusCode == 200) {
        Map data = convert.jsonDecode(response.body);
        //Asignar valores obtenidos a variables
        message = data['response'][0]['message'];
        name = data['response'][0]['name'];
        ci = data['response'][0]['document_number'];
        bornDate = data['response'][0]['born_date'];
        dosage = data['response'][0]['dosage'];
        vaccine = data['response'][0]['vaccine'];
        photoString = data['response'][0]['photo'];
        first_name = data['response'][0]['first_name'];
        last_name = data['response'][0]['last_name'];
        vaccine_date = data['response'][0]['fecha_aplicacion'];
        Global.descripcion = data['response'][0]['estado_descripcion'];
        Global.vaccine_date = vaccine_date;
        Global.first_name = first_name;
        Global.last_name = last_name;
        Global.message = message;
        Global.name = name;
        Global.ci = ci;
        Global.bornDate = bornDate;
        if (dosage == 1) {
          Global.dosage = '1RA.';
        } else if (dosage == 2) {
          Global.dosage = '2DA.';
        } else {
          Global.dosage = 'Ninguna';
        }
        Global.vaccine = vaccine;
        //DECODIFICAR IMAGEN
        photoBytes = convert.base64Decode(photoString);
        Global.photoBytes = photoBytes;
        //PARA RECONOCIMIENTO FACIAL
        Global.ciBase64 = photoString;
        Global.error = false;
      } else {
        //SI statuscode != 200 hay algún error
        Global.error = true;
      }
    } catch (e) {
      //SI HAY ALGÚN ERROR
      print('ERRORRR1');
      Global.error = true;
    }
  }
}

class Global {
  static bool error = false;
  static late String ci;
  static late String ciBase64; // Foto de cédula en base64
  static late String cameraBase64; //Foto de cámara en base64
  // static bool recoResult = true; // Resultado del reconocimiento facial
  //Datos de la persona
  static late String message = '';
  static late String name = '';
  static late String bornDate = '';
  static late String dosage = '';
  static late String vaccine = '';
  static late Uint8List photoBytes;
  static late String first_name = '';
  static late String last_name = '';
  static late String vaccine_date = '';
  static late String descripcion = '';

  //Para contar cantidad de páginas apiladas
  static int pages = 0;
  static bool noFaces = false;
}
