import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:async';
import 'misc.dart' as misc;

main() => runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Ubuntu'),
    title: "Registro Jornada Laboral",
    debugShowCheckedModeBanner: false,
    home: Homepage()));

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static final _codeController = TextEditingController();
  static final _focoTexto = FocusNode();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final entradaTexto = TextField(
    style: TextStyle(color: Colors.white),
    textAlign: TextAlign.center,
    focusNode: _focoTexto,
    cursorColor: Colors.blue,
    controller: _codeController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelStyle: TextStyle(color: Colors.white),
      hintStyle: TextStyle(color: Colors.white.withAlpha(125)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), borderSide: BorderSide(color: Colors.white)),
      labelText: "Número de empleado",
      hintText: "Ejemplo: 12345",
      suffixIcon: Icon(Icons.person, color: Colors.white),
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), borderSide: BorderSide(color: Colors.white)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25), borderSide: BorderSide(color: Colors.white)),
    ),
    onChanged: (val) {
      print("Code length: ${_codeController.text.length.toString()}");
      if (_codeController.text.length == 5) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    void sendData(String option) async {
      if (misc.codeDict[_codeController.text] != null) {
        final channel = IOWebSocketChannel.connect("ws://213.97.150.47:9800"); //IP PÚBLICA A SERVIDOR TFN
        //final channel = IOWebSocketChannel.connect("ws://192.168.1.15:9800"); //PC PERSONAL EN RED DE TFN
        var ahora = DateTime.now();
        var msg = json.encode({
          'code': _codeController.text,
          'date': '${ahora.day}.${ahora.month}.${ahora.year}',
          'time': '${ahora.hour}:${ahora.minute}',
          'option': option
        });
        channel.sink.add(msg.codeUnits);
        channel.sink.close();
      }
      mostrarSnack(_codeController.text, option, context, _scaffoldKey);
      sendToDrive(_codeController.text);
      _codeController.clear();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Registro Jornada Laboral", style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Image.asset(
                  "images/tfnlogo.png",
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: entradaTexto,
            ),
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Tiempo de trabajo",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Divider(
                          color: Colors.white,
                          indent: 50,
                          endIndent: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.green,
                              onPressed: () => sendData("TRABAJO_ON"),
                              child: Text("Empezar"),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            ),
                            Icon(Icons.work, color: Colors.white, size: 50),
                            RaisedButton(
                              color: Colors.red,
                              onPressed: () => sendData("TRABAJO_OFF"),
                              child: Text("Finalizar"),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: 40,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "Tiempo de comida",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Divider(
                          color: Colors.white,
                          indent: 50,
                          endIndent: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.green,
                              onPressed: () => sendData("COMIDA_ON"),
                              child: Text("Empezar"),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            ),
                            Icon(Icons.fastfood, color: Colors.white, size: 50),
                            RaisedButton(
                              color: Colors.red,
                              onPressed: () => sendData("COMIDA_OFF"),
                              child: Text("Finalizar"),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

void mostrarSnack(String code, String option, BuildContext context, GlobalKey<ScaffoldState> scaKey) {
  SnackBar snack;

  if (misc.codeDict[code] == null) {
    snack = SnackBar(
      content: Center(
        child: Text(
          "¡CÓDIGO ERRONEO!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
        ),
      ),
      duration: Duration(seconds: 2, milliseconds: 500),
      backgroundColor: Colors.red,
    );
  } else {
    String texto;
    String persona = misc.codeDict[code].toString().split(' ')[0];
    switch (option) {
      case 'TRABAJO_ON':
        texto = '¡Que pases un buen dia $persona!';
        break;
      case 'TRABAJO_OFF':
        texto = '¡Adiós $persona, que descanses!';
        break;
      case 'COMIDA_ON':
        texto = '¡Buen provecho $persona!';
        break;
      case 'COMIDA_OFF':
        texto = '¡A trabajar $persona!';
        break;
    }
    snack = SnackBar(
      content: Center(
        child: Text(
          texto,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ),
      duration: Duration(seconds: 2, milliseconds: 500),
      backgroundColor: Colors.white,
    );
  }

  scaKey.currentState.showSnackBar(snack);
}

void sendToDrive(String code) {
  String inputedCode = code;
  DateTime ahora = DateTime.now();
  String registroFinal = getRegistro(inputedCode);
  misc.postRegister(registroFinal, ahora.month.toString(), ahora.year.toString());
}

String getRegistro(String code) {
  //FORMATO: P010051yyyymmddhhmmssyyyymmddhhmmss000codig00
  var fechaActual = DateTime.now();
  String reg = "P010051";
  for (int i = 0; i < 2; i++) {
    reg += fechaActual.year.toString();
    reg += fechaActual.month.toString().length > 1
        ? fechaActual.month.toString()
        : "0${fechaActual.month.toString()}";
    reg +=
        fechaActual.day.toString().length > 1 ? fechaActual.day.toString() : "0${fechaActual.day.toString()}";
    reg += fechaActual.hour.toString().length > 1
        ? fechaActual.hour.toString()
        : "0${fechaActual.hour.toString()}";
    reg += fechaActual.minute.toString().length > 1
        ? fechaActual.minute.toString()
        : "0${fechaActual.minute.toString()}";
    reg += fechaActual.second.toString().length > 1
        ? fechaActual.second.toString()
        : "0${fechaActual.second.toString()}";
  }
  reg += "000";
  reg += code;
  reg += "00";
  reg += "\n";

  return reg;
}
