import 'package:app/services/person_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/services/icons.dart';

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
      Navigator.pushNamed(context, '/camera');
    }
  }

  Color claroColor = const Color(0xffDA291C);
  //Color de cuadro sobre foto de ci
  Color? _color = Colors.green[400];
  IconData _icon = Icons.offline_pin_outlined;
  // height y widht de Foto de cédula
  late double height;
  late double widht;
  //Obtener datos de la persona desde loading.dart
  Map person = {};
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffF1AF4B), // status bar color
    ));
    person = ModalRoute.of(context)!.settings.arguments as Map;
    //Tamaño para la foto de ci y para la foto de reco facial
    height = person['height'];
    widht = person['widht'];
    //Según resultado de la verificación facial, se eligen el icono y el color
    //para el mensaje que está sobre la foto de ci
    if (Global.recoResult == false) {
      _color = Colors.red;
      _icon = Icons.close;
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // decoration:
                //     BoxDecoration(border: Border.all(color: Colors.black)),
                child: Image.asset(
                  'assets/claro.jpg',
                  height: 100,
                  width: 100,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  'VERIFICACIÓN DE PERSONAS',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              //1er. elemento de la columna principal.
              Container(
                padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              //2do. elemento de la columna principal. Foto de la persona.
              Container(
                height: height,
                width: widht,
                margin: EdgeInsets.symmetric(vertical: 10),
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
              Divider(
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
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                    '${person['name']}'.toUpperCase(),
                                    style: TextStyle(color: Colors.grey[600]),
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
                                    '${person['name']}'.toUpperCase(),
                                    style: TextStyle(color: Colors.grey[600]),
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
                ),
              ),
              Divider(
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

              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
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
                                    style: TextStyle(color: Colors.grey[600]),
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
                                '${person['dosage']}',
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
                                'FECHA DE APLICACIÓN: ',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                              Text(
                                '',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}