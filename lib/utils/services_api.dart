import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ou_mp_app/models/student.dart';
import 'package:ou_mp_app/models/project.dart';

class ServicesAPI {

  // Student
  static const String loginUrl = 'http://www.jteki.com/api/ou_pm/login.php';
  static const String signUpUrl = 'http://www.jteki.com/api/ou_pm/sign_up.php';
  static const String activateAccountUrl =
      'http://www.jteki.com/api/ou_pm/activate_acc.php';
  static const String studentDetailsUrl =
      'http://www.jteki.com/api/ou_pm/getStudentById.php';

  static Future<Student> getStudentByLogin(
      String email, String password) async {
    try {
      final response = await http.post(loginUrl, body: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        var studentJson = json.decode(response.body);

        Student student;

        for (var stJson in studentJson) {
          student = Student.fromJson(stJson);
        }

        return student;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Student> getStudentById(
      int id) async {
    try {
      final response = await http.post(studentDetailsUrl, body: {
        'id': id.toString(),
      });

      if (response.statusCode == 200) {
        var studentJson = json.decode(response.body);

        Student student;

        for (var stJson in studentJson) {
          student = Student.fromJson(stJson);
        }

        return student;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

 static Future<bool> activateStudentAccount(int id) async{
    bool active = false;

    //try{
      final response = await http.post(activateAccountUrl, body: {
        'id': id.toString(),
      });

      var rsp = json.decode(response.body);
      print(rsp);
      if(rsp['StatusCode'] == 200) {
        active = true;
      }

   // } catch (e){
   //   return active;
   // }

   return active;

  }

  // Project
  static const String projectAddUrl =
      'http://www.jteki.com/api/ou_pm/project_add.php';

  static Future<int> addProject(int studentId, String name,
      String description, String category, DateTime startDate,
      DateTime endDate) async {

    try {
      final response = await http.post(projectAddUrl,body: {
        'studentId' : studentId.toString(),
        'name' : name,
        'description' : description,
        'category' : category,
        'startDate' : startDate.toString(),
        'endDate' : endDate.toString(),
      });

      if (response.statusCode == 200){

        var projectJson = json.decode(response.body);
        print(projectJson);
        var lastId = projectJson['Response']['insertedId'];
        return lastId;
      } else {
        return 0;
      }

    } catch (e){
      return 0;
    }




  }


}
