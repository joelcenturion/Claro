import 'package:app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:app/services/person_data.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getPerson() async {
    PersonData person = PersonData(ciValue: Global.ci);
    await person.getData(context);

    //SI NO HAY ERRORES SE CARGAN LOS DATOS DE LA PERSONA. SI HAY ALGÚN ERROR SE VUELVE A LA
    //PÁGINA PRINCIPAL
    if (Global.error == false) {
      Navigator.pushReplacementNamed(context, '/person', arguments: {
        //Pasar los valores a la página person.dart para mostrar
        'message': Global.message,
        'name': Global.name,
        'ci': Global.ci,
        'born_date': Global.bornDate,
        'dosage': Global.dosage,
        'vaccine': Global.vaccine,
        'photoBytes': Global.photoBytes,
        'widht': 120.0,
        'height': 160.0
      });
    } else {
      //SI HAY ALGÚN ERROR. RETORNA A LA PÁGINA PRINCIPAL;
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    getPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: AbsorbPointer(child: Home()),
        ),
        Opacity(
          opacity: 1,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              width: 70,
              height: 70,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
