import 'dart:io';

import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/wigdgets/boton_azul.dart';
import 'package:chat_app/wigdgets/custom_input.dart';
import 'package:chat_app/wigdgets/labels.dart';
import 'package:chat_app/wigdgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * .9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Logo(
                  titulo: 'Registro',
                ),
                _Form(),
                Labels(
                  texto1: '¿Ya tienes una cuenta?',
                  texto2: 'Ingresa ahora!',
                  ruta: 'login',
                ),
                Text(
                  'Terminos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),

          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),

          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),

          //TODO: Crear Boton
          BotonAzul(
            text: 'Registrarse',
            onPressed: authService.autenticando
                ? null
                : () async {
                    print(nameCtrl.text);
                    print(emailCtrl.text);
                    print(passCtrl.text);

                    if (nameCtrl.text.isEmpty ||
                        emailCtrl.text.isEmpty ||
                        passCtrl.text.isEmpty) {
                      mostrarAlerta(context, 'Campos vacios',
                          'Debe rellenar todos los campos');
                    } else {
                      if (passCtrl.text.length < 8) {
                        mostrarAlerta(context, 'Registro Incorrecto',
                            'Contraseña debe contener 8 caracteres como mínimo.');
                        return;
                      } else {
                        final registroOk = await authService.register(
                          nameCtrl.text.trim(),
                          emailCtrl.text.trim(),
                          passCtrl.text.trim(),
                        );
                        
                        if (registroOk == true) {
                          socketService.connect();

                          return showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('Registro Cliente'),
                              content: Text(
                                  '¿Desea continuar a la pantalla de chats?'),
                              actions: <Widget>[
                                MaterialButton(
                                  child: Text('Salir'),
                                  elevation: 5,
                                  textColor: Colors.blue,
                                  onPressed: () => exit(0),
                                ),
                                MaterialButton(
                                  child: Text('Si'),
                                  elevation: 5,
                                  textColor: Colors.blue,
                                  onPressed: () =>
                                      Navigator.pushReplacementNamed(
                                          context, 'usuarios'),
                                ),
                              ],
                            ),
                          );

                          //Navigator.pushReplacementNamed(context, 'usuarios');
                        } else {
                          mostrarAlerta(
                              context, 'Registro incorrecto', registroOk);
                        }
                      }
                    }
                  },
          ),
        ],
      ),
    );
  }
}
