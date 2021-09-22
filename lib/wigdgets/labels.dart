import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String? ruta;
  final String? texto1;
  final String? texto2;

  const Labels({
    Key? key, 
    @required this.texto1,
    @required this.texto2,
    @required this.ruta
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(this.texto1!, style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),),
        SizedBox(height: 10,),
        GestureDetector(
          child: Text(this.texto2!, style: TextStyle(color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold),),
          onTap: () {
            Navigator.pushReplacementNamed(context, this.ruta!);
          },
        ),

      ],
    );
  }
}