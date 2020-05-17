import 'package:json_annotation/json_annotation.dart';

class Student {
  int id;
  String name;
  String email;
  String password;
  String activationCode;
  int isActive;
  String deviceToken;
  DateTime registeredDatetime;

  Student(this.id, this.name, this.email, this.password, this.activationCode,
      this.deviceToken, this.isActive, this.registeredDatetime);

  Student.fromJson(Map<String, dynamic> json){
    id =  int.parse(json['id']);
    name = json['name'];
    email = json['email'];
    password = json['password'];
    activationCode = json['activationCode'];
    deviceToken = json['deviceToken'];
    isActive = int.parse(json['isActive']);
    registeredDatetime = DateTime.parse(json['registeredDatetime']);
  }

}
