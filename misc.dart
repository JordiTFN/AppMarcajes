import 'package:http/http.dart' as http;

//Mapa con todas las claves y su trabajador
Map codeDict = {
  '30001' : 'Cristian López',
  '30002': 'Gemma Sanjuan',
  '30004' : 'Vanesa Martínez',
  '30005' : 'Jorge Fernández',
  '30010' : 'Albert Lorenzo',
  '30011' : 'Jorge Giménez',
  '30012' : 'Raúl Hernández',
  '30013' : 'Paula Cortés',
  '11111' : 'Prueba Prueba'
};

void postRegister(String register, String month, String year) async {
  String mes = month.length>1?month:"0$month";
  String nombreDocumento = 'mar${year[2]}${year[3]}$mes';
  http.Response resp = await http.get("https://script.google.com/macros/s/AKfycbzlAsgubK16eEZqMHunjzvrQG_AsBftm6uA-ediKNoSM33nd94/exec?reg=$register&docname=$nombreDocumento");
  print(resp.body.toString());
}