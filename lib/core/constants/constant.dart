import 'package:url_launcher/url_launcher.dart';
bool passwordValidation (String password){
  RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  return regex.hasMatch(password);

}

bool emailValidation(String email){
  RegExp regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  return regex.hasMatch(email);
}

bool phoneValidation(String phone){
  RegExp regex = RegExp(r'^05\d{8}$');
  return regex.hasMatch(phone);
}

bool nameValidation(String name){
  RegExp regex = RegExp(r'^[a-zA-Z]+$');
  return regex.hasMatch(name);
}
void launchUrl_(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}


enum UserRole {
  student,
  company,
  admin,
  unknown
}

