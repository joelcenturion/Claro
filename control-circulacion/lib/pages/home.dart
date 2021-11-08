import 'package:flutter/material.dart';
import 'package:app/services/person_data.dart';
// import 'package:app/main.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  // const ({ Key? key }) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //controller para obtener el nro de cédula del textfiel
  final myController = TextEditingController();
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Color claroColor = Color(0xffDA291C);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: claroColor, // status bar color
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 25),
              child: Image.asset(
                'assets/claro.jpg',
                height: 100,
                width: 100,
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: Text(
                'VERIFICACIÓN DE PERSONAS',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    'Ingrese el número de documento',
                    style:
                        TextStyle(color: Colors.grey, height: 2, fontSize: 20),
                    // textAlign: TextAlign.center,
                  ),
                  Text(
                    'para validar los datos',
                    style:
                        TextStyle(color: Colors.grey, height: 2, fontSize: 20),
                    // textAlign: TextAlign.center,
                  ),
                  Text(
                    'ciudadano',
                    style:
                        TextStyle(color: Colors.grey, height: 2, fontSize: 20),
                    // textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            Container(
              margin: EdgeInsets.only(bottom: 25),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => showInputDialog(context).then((ciValue) {
                  myController.text = ''; //Limpiar textfield
                  ciValue = ciValue.replaceAll(' ', ''); //Remove white spaces
                  RegExp regexp =
                      RegExp(r'^[0-9]*$'); //Para validación de sólo números
                  if (!regexp.hasMatch(ciValue)) {
                    showAlert();
                  } else if (ciValue != false && ciValue != '') {
                    Global.ci = ciValue;
                    Navigator.pushNamed(context, '/loading');
                  }
                }),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'INGRESAR ',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: claroColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showInputDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Ingrese Nro. de Cédula'),
            content: TextField(
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black),
                labelText: 'Ingrese Cédula',
                contentPadding: EdgeInsets.only(left: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              controller: myController,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: claroColor,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    return Navigator.pop(context, myController.text.toString());
                  },
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                      color: claroColor,
                    ),
                  ))
            ],
          );
        });
  }

// MOSTRAR ALERT DIALOG CUANDO SE INGRESAN MAL LOS DATOS
  showAlert() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          Timer(Duration(milliseconds: 700), () {
            Navigator.pop(context);
          });
          return AlertDialog(
            title: Center(child: Text('Ingrese sólo números')),
          );
        });
  }
}
