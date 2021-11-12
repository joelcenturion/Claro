import 'package:app/pages/camera.dart';
import 'package:app/services/scanner.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/home.dart';
import 'package:app/pages/person.dart';
import 'package:app/pages/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/pages/login.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.red),
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/person': (context) => Person(),
      '/loading': (context) => Loading(),
      '/camera': (context) => Camera(),
      '/login': (context) => Login(),
      '/scanner': (context) => Scanner()
    },
  ));
}

//Mi appBar personalizado
Widget myAppBar() {
  return MyAppBar();
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);
  @override
  Size get preferredSize => Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Autorización',
            style: GoogleFonts.irishGrover(fontSize: 23, letterSpacing: 2.0),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              'assets/escudo.jpg',
              height: 45,
              width: 45,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.indigo[800],
    );
  }
}
