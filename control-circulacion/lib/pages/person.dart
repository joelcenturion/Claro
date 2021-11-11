import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/services/icons.dart';
import 'package:mrzflutterplugin/mrzflutterplugin.dart';
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:app/services/person_data.dart';

class Person extends StatefulWidget {
  // const ({ Key? key }) : super(key: key);
  @override
  _PersonState createState() => _PersonState();
}

class _PersonState extends State<Person> {
  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else if (index == 1) {
      Global.pages++;
      print('Global.pages: ${Global.pages}, index1');
      if (Global.pages > 2) {
        Global.pages--;
        Navigator.pushReplacementNamed(context, '/camera');
      } else {
        Navigator.pushNamed(context, '/camera');
      }
    } else if (index == 2) {
      startScanning();
    }
  }

  /*Parte MRZ SCANNER*/
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      Mrzflutterplugin.registerWithLicenceKey(
          "F79CD0A43780F6722114469AB6551D4E854CA8CDE5A13B7030835B59E0F2426AEAFB378423AD7F013B00F795E8103507");
      //F79CD0A43780F6722114469AB6551D4E854CA8CDE5A13B7030835B59E0F2426AEAFB378423AD7F013B00F795E8103507
    } else if (Platform.isIOS) {
      Mrzflutterplugin.registerWithLicenceKey("ios_licence_key");
    }
  }

  Color? _colorValidation;
  IconData? _iconValidation;
  bool validationHidden = true;
  String? validationString;
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> startScanning() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      Mrzflutterplugin.setIDActive(true);
      Mrzflutterplugin.setPassportActive(true);
      Mrzflutterplugin.setVisaActive(true);
      Mrzflutterplugin.setVibrateOnSuccessfulScan(true);

      String jsonResultString = await Mrzflutterplugin.startScanner;

      Map<String, dynamic> jsonResult = jsonDecode(jsonResultString);
      // fullImage = jsonResult['full_image'];
      if (jsonResult['document_number'] == Global.ci) {
        validationString = 'Validación Positiva';
      } else {
        validationString = 'Validación Negativa';
      }
      print(jsonResult);
    } on PlatformException catch (ex) {
      String? message = ex.message;
      print('scannerResult = Scanning failed');
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      validationHidden = false;
    });
  }

  /**Variables para elegir iconos y colores apropiados */
  Color? _iconDosisColor;
  IconData? _iconDosis;

  //El titulo RECO FACIAL está oculto antes de hacer el reconocimiento facial
  late bool titleIsHidden;
  Color claroColor = const Color(0xffDA291C);

  //Color de cuadro sobre foto de ci
  Color? _color;
  IconData? _icon;

  // height y widht de Foto de cédula
  late double height;
  late double widht;

  //Obtener datos de la persona desde loading.dart
  Map person = {};
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffDA291C), // status bar color
    ));
    person = ModalRoute.of(context)!.settings.arguments as Map;
    //Tamaño para la foto de ci y para la foto de reco facial
    height = person['height'];
    widht = person['widht'];
    //Según resultado de la verificación facial, se eligen el icono y el color
    //para el mensaje que está sobre la foto de ci
    if (person['message'] == 'RECO FACIAL NEGATIVO') {
      _color = Colors.red;
      _icon = Icons.close;
      titleIsHidden = false;
    } else if (person['message'] == 'RECO FACIAL POSITIVO') {
      _color = Colors.green[400];
      _icon = Icons.offline_pin_outlined;
      titleIsHidden = false;
    } else {
      titleIsHidden = true;
      _color = Colors.green[400];
      _icon = Icons.offline_pin_outlined;
    }

    if (validationString == 'Validación Positiva') {
      _colorValidation = Colors.green[400];
      _iconValidation = Icons.offline_pin_outlined;
    } else {
      _colorValidation = Colors.red;
      _iconValidation = Icons.close;
    }

    if (person['dosage'] == '1RA.') {
      _iconDosis = Icons.warning_rounded;
      _iconDosisColor = Colors.orange[600];
    } else if (person['dosage'] == '2DA.') {
      _iconDosis = Icons.offline_pin_outlined;
      _iconDosisColor = Colors.green[400];
    } else {
      _iconDosis = Icons.highlight_off_rounded;
      // _iconDosis = Icons.dangerous_rounded;
      _iconDosisColor = Colors.red[600];
    }
    print(person['message']);
    print(titleIsHidden);
    return WillPopScope(
      onWillPop: () async {
        Global.pages--;
        print('Global.pages: ${Global.pages}, onWillPop');
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      // decoration:
                      //     BoxDecoration(border: Border.all(color: Colors.black)),
                      child: Image.asset(
                        'assets/claro.jpg',
                        height: 75,
                        width: 75,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container(
                      child: Text(
                        'VERIFICACIÓN DE PERSONAS',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                //Mensaje sobre foto de cédula,
                !titleIsHidden
                    ? Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: _color,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _icon,
                              color: Colors.white,
                            ),
                            Text(
                              '   ${person['message']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),

                !validationHidden
                    ? Container(
                        margin: EdgeInsets.only(bottom: 5),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: _colorValidation,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _iconValidation,
                              color: Colors.white,
                            ),
                            Text(
                              '   $validationString'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),

                //2do. elemento de la columna principal. Foto de la persona.
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  height: height,
                  width: widht,
                  margin: EdgeInsets.only(bottom: 10, top: 3),
                  child: Image.memory(
                    person['photoBytes'],
                    fit: BoxFit.fill,
                    //EN CASO DE QUE NO SE PUEDA CARGAR LA IMAGEN
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/empty_photo.jpg',
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
                //3er. elemento de la columna principal. CI, Nombre, Fecha de nacimiento
                Flexible(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Divider(
                        height: 5,
                        thickness: 2,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'DATOS PERSONALES',
                          style: TextStyle(
                            color: claroColor,
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'C.I.: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17),
                                  ),
                                  Text(
                                    '${person['ci']}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'NOMBRE: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${person['first_name']}'.toUpperCase(),
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'APELLIDO: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${person['last_name']}'.toUpperCase(),
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'FECHA DE NACIMIENTO: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17),
                                  ),
                                  Text(
                                    '${person['born_date']}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 5,
                        thickness: 2,
                      ),
                      //4to. elemento de la columna principal. Datos de Vacunación
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 3),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'DATOS DE VACUNACIÓN',
                          style: TextStyle(
                            color: claroColor,
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'VACUNA: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                        '${person['vaccine']}'.toUpperCase(),
                                        style:
                                            TextStyle(color: Colors.grey[600]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'DOSIS APLICADA: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17),
                                  ),
                                  Text(
                                    '${person['dosage']}  ',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  Icon(
                                    _iconDosis,
                                    color: _iconDosisColor,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    'FECHA DE APLICACIÓN: ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17),
                                  ),
                                  Text(
                                    '${person['vaccine_date']}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 20,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: Color(0xffDA291C),
              ),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  MyIcon.face1,
                  color: Color(0xffDA291C),
                ),
                label: 'Verificación'),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.document_scanner_outlined,
                color: Color(0xffDA291C),
              ),
              label: 'Validación',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.comment_outlined,
                color: Color(0xffDA291C),
              ),
              label: 'Comentarios',
            )
          ],
          currentIndex: selectedIndex,
          // selectedItemColor: Colors.black,
          fixedColor: Colors.grey,
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
