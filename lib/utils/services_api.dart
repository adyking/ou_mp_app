import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ou_mp_app/models/logsheet.dart';
import 'package:ou_mp_app/models/reminder.dart';
import 'package:ou_mp_app/models/student.dart';
import 'package:ou_mp_app/models/project.dart';
import 'package:ou_mp_app/models/task.dart';
import 'package:ou_mp_app/models/subtask.dart';
import 'package:ou_mp_app/models/TaskSubtask.dart';
import 'package:intl/intl.dart';

class ServicesAPI {
  // Student
  static const String newStudentUrl = 'http://www.jteki.com/api/ou_pm/sign_up.php';
  static const String sendEmailRegStudentUrl =
      'http://www.jteki.com/api/ou_pm/sendRegEmailConfirmation.php';
  static const String checkEmailExistsUrl = 'http://www.jteki.com/api/ou_pm/checkEmailExists.php';
  static const String loginUrl = 'http://www.jteki.com/api/ou_pm/login.php';
  static const String signUpUrl = 'http://www.jteki.com/api/ou_pm/sign_up.php';
  static const String activateAccountUrl =
      'http://www.jteki.com/api/ou_pm/activate_acc.php';
  static const String studentDetailsUrl =
      'http://www.jteki.com/api/ou_pm/getStudentById.php';
  static const String studentUpdateProfileUrl =
      'http://www.jteki.com/api/ou_pm/student_update_profile.php';
  static const String studentUpdateTokenUrl =
      'http://www.jteki.com/api/ou_pm/student_update_device_token.php';
  static const String studentDeleteProfileUrl =
      'http://www.jteki.com/api/ou_pm/student_delete_profile.php';


  static Future<int> addStudent(String name, String email,
      String password, String activationCode) async {

    http.Client client = new http.Client();
    try {
      final response = await client.post(newStudentUrl, body: {
        'name': name,
        'email': email,
        'password': password,
        'activationCode': activationCode
      });

      if (response.statusCode == 200) {
        var studentJson = json.decode(response.body);
       // print(studentJson);
        var lastId = studentJson['Response']['insertedId'];
        return lastId;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {

      client.close();

    }
  }

  static Future<int> updateStudentProfile(int id, String name, String password) async {
    http.Client client = new http.Client();

    try {
      final response = await client.post(studentUpdateProfileUrl, body: {
        'id': id.toString(),
        'name': name,
        'password': password,
      });

      if (response.statusCode == 200) {
        var studentJson = json.decode(response.body);
        print(studentJson);
        int result = 0;

        if (studentJson['StatusCode'] == 200) {
          result = 1;
        }

        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {

      client.close();
    }
  }

  static Future<int> updateStudentToken(int id, String token) async {
    http.Client client = new http.Client();

    try {
      final response = await client.post(studentUpdateTokenUrl, body: {
        'id': id.toString(),
        'token': token,

      });

      if (response.statusCode == 200) {
        var studentJson = json.decode(response.body);
        print(studentJson);
        int result = 0;

        if (studentJson['StatusCode'] == 200) {
          result = 1;
        }

        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {

      client.close();
    }
  }

  static Future<int> deleteStudentProfile(int id) async {

    http.Client client = new http.Client();
    try {
      final response = await client.post(studentDeleteProfileUrl, body: {
        'id': id.toString(),
      });

      if (response.statusCode == 200) {
        var studentJson = json.decode(response.body);
        print(studentJson);
        int result = 0;

        if (studentJson['StatusCode'] == 200) {
          result = 1;
        }

        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {

      client.close();
    }
  }

  static Future<int> sendEmailRegStudent(String name, String email,
      String password, String activationCode) async {

    http.Client client = new http.Client();
    try {
      final response = await client.post(sendEmailRegStudentUrl, body: {
        'name': name,
        'email': email,
        'password': password,
        'activationCode': activationCode
      });

      if (response.statusCode == 200) {
        var studentJson = json.decode(response.body);

        int resp = studentJson['Response'];
        return resp;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {

      client.close();

    }
  }
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

  static Future<Student> checkStudentEmailExists(
      String email) async {
    http.Client client = new http.Client();

    try {
      final response = await client.post(checkEmailExistsUrl, body: {
        'email': email,
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
    } finally {
      client.close();

    }
  }
  static Future<Student> getStudentById(int id) async {
    http.Client client = new http.Client();

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
    } finally {
      client.close();
    }
  }

  static Future<bool> activateStudentAccount(int id) async {
    bool active = false;

    //try{
    final response = await http.post(activateAccountUrl, body: {
      'id': id.toString(),
    });

    var rsp = json.decode(response.body);
    print(rsp);
    if (rsp['StatusCode'] == 200) {
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
  static const String projectUpdateUrl =
      'http://www.jteki.com/api/ou_pm/project_update.php';
  static const String projectDeleteUrl =
      'http://www.jteki.com/api/ou_pm/project_delete.php';
  static const String projectDetailsByIdUrl =
      'http://www.jteki.com/api/ou_pm/getProjectById.php';
  static const String projectDetailsByStudentIdUrl =
      'http://www.jteki.com/api/ou_pm/getProjectsByStudentId.php';
  static const String overdueProjectDetailsByStudentIdUrl =
      'http://www.jteki.com/api/ou_pm/getOverdueProjectsByStudentId.php';
  static const String currentProjectDetailsByStudentIdUrl =
      'http://www.jteki.com/api/ou_pm/getCurrentProjectsByStudentId.php';
  static const String projectUpdateStatusByIdUrl =
      'http://www.jteki.com/api/ou_pm/update_project_status.php';

  static Future<int> addProject(int studentId, String name, String description,
      String category, DateTime startDate, DateTime endDate) async {
    try {
      final response = await http.post(projectAddUrl, body: {
        'studentId': studentId.toString(),
        'name': name,
        'description': description,
        'category': category,
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
      });

      if (response.statusCode == 200) {
        var projectJson = json.decode(response.body);
        print(projectJson);
        var lastId = projectJson['Response']['insertedId'];
        return lastId;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<int> updateProject(int id, String name, String description,
      String category, DateTime startDate, DateTime endDate) async {
    try {
      final response = await http.post(projectUpdateUrl, body: {
        'id': id.toString(),
        'name': name,
        'description': description,
        'category': category,
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
      });

      if (response.statusCode == 200) {
        var projectJson = json.decode(response.body);
        print(projectJson);
        int result = 0;

        if (projectJson['StatusCode'] == 200) {
          result = 1;
        }

        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }
  static Future<int> updateProjectStatus(int id, int status) async {

    try {

      final response = await http.post(projectUpdateStatusByIdUrl, body: {
        'id': id.toString(),
        'status': status.toString(),
      });

      if (response.statusCode == 200) {
        var projectJson = json.decode(response.body);
        print(projectJson);

        int result = 0;
        if (projectJson['StatusCode'] == 200) {
          result = 1;
        }
        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<int> deleteProject(int id) async {
    try {
      final response = await http.post(projectDeleteUrl, body: {
        'id': id.toString(),
      });

      if (response.statusCode == 200) {
        var projectJson = json.decode(response.body);
        print(projectJson);
        int result = 0;

        if (projectJson['StatusCode'] == 200) {
          result = 1;
        }

        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<List<Project>> getProjectByStudentId(int studentId) async {
    final response = await http.post(projectDetailsByStudentIdUrl, body: {
      'studentId': studentId.toString(),
    });

    var projects = List<Project>();

    if (response.statusCode == 200) {
      var projectsJson = json.decode(response.body);

      for (var pJson in projectsJson) {
        projects.add(Project.fromJson(pJson));
      }
    }

    return projects;
  }


  static Future<List<Project>> getOverdueProjectByStudentId(int studentId,
      DateTime endDate) async {

    http.Client client = new http.Client();

    try{
      final response = await client.post(overdueProjectDetailsByStudentIdUrl, body: {
        'studentId': studentId.toString(),
        'endDate': endDate.toString(),
      });

      var projects = List<Project>();

      if (response.statusCode == 200) {
        var projectsJson = json.decode(response.body);

        for (var pJson in projectsJson) {
          projects.add(Project.fromJson(pJson));
        }
      }

      return projects;
    } catch(e){
      return null;
    } finally{

      client.close();
    }


  }


  static Future<Project> getCurrentProjectByStudentId(int studentId) async {
    http.Client client = new http.Client();

    try{
      final response =
      await client.post(currentProjectDetailsByStudentIdUrl, body: {
        'studentId': studentId.toString(),
      });

      Project project;

      if (response.statusCode == 200) {
        var projectsJson = json.decode(response.body);

        for (var pJson in projectsJson) {
          project = Project.fromJson(pJson);
        }
      }

      return project;
    } catch (e){
      return null;
    } finally {
      client.close();
    }


  }

  static Future<Project> getProjectById(int id) async {
    http.Client client = new http.Client();
    Project project;

    try {
      final response = await client.post(projectDetailsByIdUrl, body: {
        'id': id.toString(),
      });

      if (response.statusCode == 200) {
        var projectsJson = json.decode(response.body);

        for (var pJson in projectsJson) {
          project = Project.fromJson(pJson);
        }
      }

      return project;
    } catch (e) {
      return project;
    } finally {
      client.close();
    }
  }

  // Task
  static const String taskAddUrl =
      'http://www.jteki.com/api/ou_pm/task_add.php';
  static const String taskDetailsByIdUrl =
      'http://www.jteki.com/api/ou_pm/getTaskById.php';
  static const String taskDetailsByProjectIdUrl =
      'http://www.jteki.com/api/ou_pm/getTasksByProjectId.php';
  static const String overdueTaskDetailsByProjectIdUrl =
      'http://www.jteki.com/api/ou_pm/getOverdueTasksByProjectId.php';
  static const String pendingTaskDetailsByProjectIdUrl =
      'http://www.jteki.com/api/ou_pm/getPendingTasksByProjectId.php';
  static const String taskDetailsUpdateByIdUrl =
      'http://www.jteki.com/api/ou_pm/update_task.php';
  static const String taskAllocatedHoursUpdateByIdUrl =
      'http://www.jteki.com/api/ou_pm/update_task_estimate_time.php';
  static const String taskUpdateStatusByIdUrl =
      'http://www.jteki.com/api/ou_pm/update_task_status.php';
  static const String taskDeleteUrl =
      'http://www.jteki.com/api/ou_pm/task_delete.php';

  static Future<int> addTask(
      int projectId,
      String name,
      DateTime startDate,
      DateTime endDate,
      String duration,
      String priority,
      double allocatedHours) async {
    try {
      final response = await http.post(taskAddUrl, body: {
        'projectId': projectId.toString(),
        'name': name,
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'duration': duration,
        'priority': priority,
        'allocatedHours': allocatedHours.toString(),
      });

      if (response.statusCode == 200) {
        var taskJson = json.decode(response.body);
        print(taskJson);
        var lastId = taskJson['Response']['insertedId'];
        return lastId;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<int> updateTask(
      int id,
      String name,
      DateTime startDate,
      DateTime endDate,
      String duration,
      String priority,
      double allocatedHours) async {
    try {
      final response = await http.post(taskDetailsUpdateByIdUrl, body: {
        'id': id.toString(),
        'name': name,
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'duration': duration,
        'priority': priority,
        'allocatedHours': allocatedHours.toString(),
      });

      if (response.statusCode == 200) {
        var taskJson = json.decode(response.body);
        print(taskJson);

        int result = 0;
        if (taskJson['StatusCode'] == 200) {
          result = 1;
        }
        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<int> deleteTask(int id) async {
    try {
      final response = await http.post(taskDeleteUrl, body: {
        'id': id.toString(),
      });

      if (response.statusCode == 200) {
        var taskJson = json.decode(response.body);
        print(taskJson);
        int result = 0;

        if (taskJson['StatusCode'] == 200) {
          result = 1;
        }

        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<int> updateTaskStatus(int id, int status) async {
    try {
      final response = await http.post(taskUpdateStatusByIdUrl, body: {
        'id': id.toString(),
        'status': status.toString(),
      });

      if (response.statusCode == 200) {
        var taskJson = json.decode(response.body);
        print(taskJson);

        int result = 0;
        if (taskJson['StatusCode'] == 200) {
          result = 1;
        }
        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<int> updateTaskEstimatedTime(
      int id, double allocatedHours) async {
    try {
      final response = await http.post(taskAllocatedHoursUpdateByIdUrl, body: {
        'id': id.toString(),
        'allocatedHours': allocatedHours.toString(),
      });

      if (response.statusCode == 200) {
        var taskJson = json.decode(response.body);
        print(taskJson);

        int result = 0;
        if (taskJson['StatusCode'] == 200) {
          result = 1;
        }
        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<List<Task>> getTasksByProjectId(int projectId) async {
    http.Client client = new http.Client();
    var tasks = List<Task>();

    try {
      final response = await http.post(taskDetailsByProjectIdUrl, body: {
        'projectId': projectId.toString(),
      });

      if (response.statusCode == 200) {
        var tasksJson = json.decode(response.body);

        for (var tJson in tasksJson) {
          tasks.add(Task.fromJson(tJson));
        }
      }

      return tasks;
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }

  static Future<List<Task>> getOverdueTasksByProjectId(int projectId,
      DateTime date) async {
    http.Client client = new http.Client();
    var tasks = List<Task>();

    try {
      final response = await http.post(overdueTaskDetailsByProjectIdUrl, body: {
        'projectId': projectId.toString(),
        'taskEndDate': date.toString(),

      });

      if (response.statusCode == 200) {
        var tasksJson = json.decode(response.body);

        for (var tJson in tasksJson) {
          tasks.add(Task.fromJson(tJson));
        }
      }

      return tasks;
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }

  static Future<List<Task>> getPendingTasksByProjectId(int projectId) async {
    http.Client client = new http.Client();
    var tasks = List<Task>();

    try {
      final response = await http.post(pendingTaskDetailsByProjectIdUrl, body: {
        'projectId': projectId.toString(),
      });

      if (response.statusCode == 200) {
        var tasksJson = json.decode(response.body);

        for (var tJson in tasksJson) {
          tasks.add(Task.fromJson(tJson));
        }
      }

      return tasks;
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }

  static Future<Task> getTaskById(int id) async {
    final response = await http.post(taskDetailsByIdUrl, body: {
      'id': id.toString(),
    });

    Task task;

    if (response.statusCode == 200) {
      var tasksJson = json.decode(response.body);

      for (var tJson in tasksJson) {
        task = Task.fromJson(tJson);
      }
    }

    return task;
  }

  // Subtask
  static const String subtaskAddUrl =
      'http://www.jteki.com/api/ou_pm/subtask_add.php';
  static const String subtaskDetailsByIdUrl =
      'http://www.jteki.com/api/ou_pm/getSubtaskById.php';
  static const String subtaskDetailsByTaskIdUrl =
      'http://www.jteki.com/api/ou_pm/getSubtasksByTaskId.php';
  static const String pendingSubtaskDetailsByTaskIdUrl =
      'http://www.jteki.com/api/ou_pm/getPendingSubtasksByTaskId.php';
  static const String subtaskDetailsUpdateByIdUrl =
      'http://www.jteki.com/api/ou_pm/update_subtask.php';
  static const String subtaskUpdateStatusByIdUrl =
      'http://www.jteki.com/api/ou_pm/update_subtask_status.php';
  static const String subtaskUpdateStatusOverdueByTaskIdUrl =
      'http://www.jteki.com/api/ou_pm/update_subtask_status_overdue.php';
  static const String subtaskDeleteUrl =
      'http://www.jteki.com/api/ou_pm/subtask_delete.php';

  static Future<int> addSubtask(
      int taskId,
      String name,
      DateTime startDate,
      DateTime endDate,
      String duration,
      String priority,
      double allocatedHours) async {
    try {
      final response = await http.post(subtaskAddUrl, body: {
        'taskId': taskId.toString(),
        'name': name,
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'duration': duration,
        'priority': priority,
        'allocatedHours': allocatedHours.toString(),
      });

      if (response.statusCode == 200) {
        var subtaskJson = json.decode(response.body);
        print(subtaskJson);
        var lastId = subtaskJson['Response']['insertedId'];
        return lastId;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<int> updateSubtask(
      int id,
      String name,
      DateTime startDate,
      DateTime endDate,
      String duration,
      String priority,
      double allocatedHours) async {
    try {
      final response = await http.post(subtaskDetailsUpdateByIdUrl, body: {
        'id': id.toString(),
        'name': name,
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
        'duration': duration,
        'priority': priority,
        'allocatedHours': allocatedHours.toString(),
      });

      if (response.statusCode == 200) {
        var subtaskJson = json.decode(response.body);
        print(subtaskJson);

        int result = 0;
        if (subtaskJson['StatusCode'] == 200) {
          result = 1;
        }
        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<int> deleteSubtask(int id) async {
    try {
      final response = await http.post(subtaskDeleteUrl, body: {
        'id': id.toString(),
      });

      if (response.statusCode == 200) {
        var subtaskJson = json.decode(response.body);
        print(subtaskJson);
        int result = 0;

        if (subtaskJson['StatusCode'] == 200) {
          result = 1;
        }

        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  static Future<int> updateSubtaskStatus(int id, int status) async {
    http.Client client = new http.Client();

    try {
      final response = await client.post(subtaskUpdateStatusByIdUrl, body: {
        'id': id.toString(),
        'status': status.toString(),
      });

      if (response.statusCode == 200) {
        var subtaskJson = json.decode(response.body);
        print(subtaskJson);

        int result = 0;
        if (subtaskJson['StatusCode'] == 200) {
          result = 1;
        }
        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {
      client.close();
    }
  }

  static Future<int> updateSubtaskStatusOverdueByTaskId(int taskId) async {

    http.Client client = new http.Client();
    try {
      final response = await client.post(subtaskUpdateStatusOverdueByTaskIdUrl
          , body: {
        'taskId': taskId.toString(),
      });

      if (response.statusCode == 200) {
        var subtaskJson = json.decode(response.body);
        print(subtaskJson);

        int result = 0;
        if (subtaskJson['StatusCode'] == 200) {
          result = 1;
        }
        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {

      client.close();
    }
  }

  static Future<List<Subtask>> getSubtasksByTaskId(int taskId) async {
    http.Client client = new http.Client();

    try {
      final response = await client.post(subtaskDetailsByTaskIdUrl, body: {
        'taskId': taskId.toString(),
      });

      var subtasks = List<Subtask>();

      if (response.statusCode == 200) {
        var subtasksJson = json.decode(response.body);

        for (var sJson in subtasksJson) {
          subtasks.add(Subtask.fromJson(sJson));
        }
      }

      return subtasks;
    } catch (e){
      return null;

    } finally {
      client.close();
    }

  }

  static Future<List<Subtask>> getPendingSubtasksByTaskId(int taskId) async {
    http.Client client = new http.Client();

    try {
      final response = await client.post(pendingSubtaskDetailsByTaskIdUrl, body: {
        'taskId': taskId.toString(),
      });

      var subtasks = List<Subtask>();

      if (response.statusCode == 200) {
        var subtasksJson = json.decode(response.body);

        for (var sJson in subtasksJson) {
          subtasks.add(Subtask.fromJson(sJson));
        }
      }

      return subtasks;
    } catch (e){
      return null;

    } finally {
      client.close();
    }

  }

  static Future<String> getSubtasksByTaskIdPercentage(
      int taskId, int status) async {
    http.Client client = new http.Client();

    try {
      final response = await client.post(subtaskDetailsByTaskIdUrl, body: {
        'taskId': taskId.toString(),
      });

      var subtasks = List<Subtask>();

      if (response.statusCode == 200) {
        var subtasksJson = json.decode(response.body);

        for (var sJson in subtasksJson) {
          subtasks.add(Subtask.fromJson(sJson));
        }
      }

      int currentPercentage = 0;
      int nSubCompleted = 0;

      for (var i = 0; i < subtasks.length; i++) {
        switch (subtasks[i].status) {
          case 1:
            {
              nSubCompleted = nSubCompleted + 1;
            }
            break;

          default:
            {
              //
            }
            break;
        }
      }
      if (subtasks.length != 0) {
        int total = 0;
        total = subtasks.length.toInt();
        num _cProgress = nSubCompleted / total;
        num percentage = (_cProgress * 100).round();

        currentPercentage = percentage;
      } else {
        if (status == 1) {
          num percentage = (1 * 100).round();
          currentPercentage = percentage;
        }
      }

      return currentPercentage.toString() + '%';
    } catch (e) {
      // client.close();
      print('getSubtasksByTaskIdPercentage Error: ' + e.toString());
      return 'N/A';
    } finally {
      client.close();
    }
  }

  static Future<Subtask> getSubtaskById(int id) async {
    final response = await http.post(subtaskDetailsByIdUrl, body: {
      'id': id.toString(),
    });

    Subtask subtask;

    if (response.statusCode == 200) {
      var subtasksJson = json.decode(response.body);

      for (var sJson in subtasksJson) {
        subtask = Subtask.fromJson(sJson);
      }
    }

    return subtask;
  }

  // Task & subtasks
  static const String tasksSubtasksDetailsByProjectIdUrl =
      'http://www.jteki.com/api/ou_pm/getTasksSubtasksByProjectId.php';
  static const String tasksSubtasksDetailsByProjectIdAgendaUrl =
      'http://www.jteki.com/api/ou_pm/getTasksSubtasksByProjectIdAgenda.php';
  static const String tasksSubtasksDetailsByProjectIdAgenda2Url =
      'http://www.jteki.com/api/ou_pm/getTasksSubtasksByProjectIdAgenda2.php';
  static const String tasksSubtasksDetailsByProjectIdOverdueUrl =
      'http://www.jteki.com/api/ou_pm/getTasksSubtasksByProjectIdOverdue.php';
  static const String tasksSubtasksDetailsByProjectIdWithPercentageUrl =
      'http://www.jteki.com/api/ou_pm/getTasksSubtasksByProjectIdPercentage.php';
  static const String tasksSubtasksDetailsByProjectIListWithPercentageUrl =
      'http://www.jteki.com/api/ou_pm/getTasksSubtasksByProjectIdListPercentage.php';

  static Future<List<TaskSubtask>> getTasksSubtasksByProjectId(
      int projectId,
      DateTime subtaskStartDate,
      DateTime taskStartDate,
      int filterOption) async {

    http.Client client = new http.Client();
    var tasksSubtasks = List<TaskSubtask>();

    try{
      final response = await client.post(tasksSubtasksDetailsByProjectIdUrl, body: {
        'projectId': projectId.toString(),
        'subtaskStartDate': subtaskStartDate.toString(),
        'taskStartDate': taskStartDate.toString(),
        'filterOption': filterOption.toString(),
      });



      if (response.statusCode == 200) {
        var tasksSubtasksJson = json.decode(response.body);

        for (var tSJson in tasksSubtasksJson) {
          tasksSubtasks.add(TaskSubtask.fromJsonHome(tSJson));
        }
      }

      return tasksSubtasks;
    }catch(e) {
      return tasksSubtasks;
    } finally {
      client.close();
    }

  }

  static Future<List<TaskSubtask>> getTasksSubtasksByProjectIdOverdue(
      int projectId,
      DateTime subtaskEndDate,
      DateTime taskEndDate) async {

    http.Client client = new http.Client();
    var tasksSubtasks = List<TaskSubtask>();

    try{
      final response = await client.post(tasksSubtasksDetailsByProjectIdOverdueUrl, body: {
        'projectId': projectId.toString(),
        'subtaskEndDate': subtaskEndDate.toString(),
        'taskEndDate': taskEndDate.toString(),
      });

      if (response.statusCode == 200) {
        var tasksSubtasksJson = json.decode(response.body);

        for (var tSJson in tasksSubtasksJson) {
          tasksSubtasks.add(TaskSubtask.fromJsonOverdue(tSJson));
        }
      }

      return tasksSubtasks;
    }catch(e) {
      return tasksSubtasks;
    } finally {
      client.close();
    }

  }



  static Future<List<TaskSubtask>> getTasksSubtasksByProjectIdWithPercentage(
      int projectId) async {

    http.Client client = new http.Client();

    try {
      final response = await http
          .post(tasksSubtasksDetailsByProjectIdWithPercentageUrl, body: {
        'projectId': projectId.toString(),
      });

      var tasksSubtasks = List<TaskSubtask>();

      if (response.statusCode == 200) {
        var tasksSubtasksJson = json.decode(response.body);

        for (var tSJson in tasksSubtasksJson) {
          tasksSubtasks.add(TaskSubtask.fromJson(tSJson));
        }
      }


      return tasksSubtasks;

    } catch (e) {
      return null;
    } finally {
      client.close();
    }

  }

  static Future<List<TaskSubtask>> getTasksSubtasksByProjectIdAgenda(
      int projectId) async {

    http.Client client = new http.Client();
    var tasksSubtasks = List<TaskSubtask>();

    try{
      final response = await client.post(tasksSubtasksDetailsByProjectIdAgendaUrl
          , body: {
        'projectId': projectId.toString(),
      });



      if (response.statusCode == 200) {
        var tasksSubtasksJson = json.decode(response.body);

        for (var tSJson in tasksSubtasksJson) {
          tasksSubtasks.add(TaskSubtask.fromJsonAgenda(tSJson));
        }
      }

      return tasksSubtasks;
    }catch(e) {
      return tasksSubtasks;
    } finally {
      client.close();
    }

  }

  static Future<Map<DateTime, List>> getTasksSubtasksByProjectIdAgenda2(
      int projectId) async {

    http.Client client = new http.Client();

    var tasksSubtasks = Map<DateTime, List>();
    var listTasksSubtasks = List<TaskSubtask>();

    try{
      final response = await client.post(tasksSubtasksDetailsByProjectIdAgenda2Url
          , body: {
            'projectId': projectId.toString(),
            'filterOption' : '0',
          });

      if (response.statusCode == 200) {
        var tasksSubtasksJson = json.decode(response.body);

        for (var tSJson in tasksSubtasksJson) {

          listTasksSubtasks.add(TaskSubtask.fromJsonAgenda(tSJson));
        }


        for (var i = 0; i < listTasksSubtasks.length; i++){
          var tasksSubtasks2List = new List();

          http.Client client2 = new http.Client();

          try{
            final response2 = await client2.post(tasksSubtasksDetailsByProjectIdAgenda2Url
                , body: {
                  'projectId': projectId.toString(),
                  'subtaskStartDate' : listTasksSubtasks[i].subtaskStartDate.toString(),
                  'taskStartDate' : listTasksSubtasks[i].subtaskStartDate.toString(),
                  'filterOption' : '1',
                });


            if (response2.statusCode == 200) {

              var tasksSubtasksJson = json.decode(response2.body);
              var listTasksSubtasks2 = List<TaskSubtask>();

              for (var tSJson in tasksSubtasksJson) {

                listTasksSubtasks2.add(TaskSubtask.fromJsonAgenda(tSJson));
              }

              for (var i = 0; i < listTasksSubtasks2.length; i++){

                var newMap = {
                  'task_id': listTasksSubtasks2[i].taskId,
                  'subtask_id': listTasksSubtasks2[i].subtaskId,
                  'task_name': listTasksSubtasks2[i].taskName,
                  'subtask_name': listTasksSubtasks2[i].subtaskName,
                  'task_time': listTasksSubtasks2[i].taskAllocatedHours,
                  'subtask_time': listTasksSubtasks2[i].subtaskAllocatedHours,
                  'taskStatus': listTasksSubtasks2[i].taskStatus,
                  'subtaskStatus': listTasksSubtasks2[i].subtaskStatus,
                  'percent': '0%',
                  'isDone': listTasksSubtasks2[i].isDone==1 ? true : false

                };

                tasksSubtasks2List.add(newMap);

              }

            }


          }catch(e) {
           String er = e.toString();
          } finally {
            client2.close();
          }

          if(tasksSubtasks2List.length!=0) {
            var formatter = DateFormat('yyyy-MM-dd');
            var formattedDate = formatter.format(listTasksSubtasks[i].subtaskStartDate);
            tasksSubtasks[DateTime.parse(formattedDate)] = tasksSubtasks2List;
          }



        }

      }

      return tasksSubtasks;
    }catch(e) {
      return tasksSubtasks;
    } finally {
      client.close();
    }

  }



  static Future<List<TaskSubtask>> getTasksSubtasksByProjectIdListWithPercentage(
      int projectId,
      DateTime subtaskStartDate,
      DateTime taskStartDate,
      int filterOption) async {

    http.Client client = new http.Client();

    try {
      final response = await http
          .post(tasksSubtasksDetailsByProjectIListWithPercentageUrl, body: {
        'projectId': projectId.toString(),
        'subtaskStartDate': subtaskStartDate.toString(),
        'taskStartDate': taskStartDate.toString(),
        'filterOption': filterOption.toString(),
      });

      var tasksSubtasks = List<TaskSubtask>();

      if (response.statusCode == 200) {
        var tasksSubtasksJson = json.decode(response.body);

        for (var tSJson in tasksSubtasksJson) {
          tasksSubtasks.add(TaskSubtask.fromJson(tSJson));
        }
      }

      return tasksSubtasks;

    } catch (e) {
      return null;
    } finally {
      client.close();
    }

  }

  // LogSheets
  static const String logSheetAddUrl =
      'http://www.jteki.com/api/ou_pm/log_sheet_add.php';
  static const String logSheetsListByProjectIdUrl =
      'http://www.jteki.com/api/ou_pm/getLogSheetsByProjectId.php';
  static const String logSheetDetailsByIdUrl =
      'http://www.jteki.com/api/ou_pm/getLogSheetById.php';
  static const String logSheetUpdateUrl =
        'http://www.jteki.com/api/ou_pm/log_sheet_update.php';
  static const String logSheetDeleteUrl =
      'http://www.jteki.com/api/ou_pm/log_sheet_delete.php';

    static Future<List<LogSheet>> getLogSheetsByProjectId(int projectId) async {

    http.Client client = new http.Client();

    try{
      final response = await client.post(logSheetsListByProjectIdUrl, body: {
        'projectId': projectId.toString(),
      });

      var logSheets = List<LogSheet>();

      if (response.statusCode == 200) {
        var logSheetsJson = json.decode(response.body);

        for (var lJson in logSheetsJson) {
          logSheets.add(LogSheet.fromJson(lJson));
        }
      }

      return logSheets;
    } catch (e){
      return null;
    } finally {

      client.close();
    }

  }


  static Future<int> addLogSheet(int projectId, String timeSpent, String work,
      String problems, String comments ,String nextWorkPlanned, DateTime loggedDate,
      String loggedTime) async {

    http.Client client = new http.Client();
    try {
      final response = await client.post(logSheetAddUrl, body: {
        'projectId': projectId.toString(),
        'timeSpent': timeSpent,
        'work': work,
        'problems': problems,
        'comments': comments,
        'nextWorkPlanned': nextWorkPlanned,
        'loggedDate': loggedDate.toString(),
        'loggedTime': loggedTime.toString(),
      });

      if (response.statusCode == 200) {
        var logSheetJson = json.decode(response.body);
        print(logSheetJson);
        var lastId = logSheetJson['Response']['insertedId'];
        return lastId;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {
      client.close();
    }
  }

  static Future<LogSheet> getLogSheetById(int id) async {
    http.Client client = new http.Client();
    LogSheet logSheet;

    try {
      final response = await client.post(logSheetDetailsByIdUrl, body: {
        'id': id.toString(),
      });

      if (response.statusCode == 200) {
        var logSheetJson = json.decode(response.body);

        for (var lJson in logSheetJson) {
          logSheet = LogSheet.fromJson(lJson);
        }
      }

      return logSheet;
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }

  static Future<int> updateLogSheet(int id, String timeSpent, String work,
      String problems, String comments, String nextWorkPlanned) async {
    http.Client client = new http.Client();

    try {
      final response = await client.post(logSheetUpdateUrl, body: {
        'id': id.toString(),
        'timeSpent': timeSpent,
        'work': work,
        'problems': problems,
        'comments': comments,
        'nextWorkPlanned': nextWorkPlanned,
      });

      if (response.statusCode == 200) {
        var logSheetJson = json.decode(response.body);
        print(logSheetJson);
        int result = 0;

        if (logSheetJson['StatusCode'] == 200) {
          result = 1;
        }

        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {
      client.close();
    }
  }

  static Future<int> deleteLogSheet(int id) async {

    http.Client client = new http.Client();
    try {
      final response = await client.post(logSheetDeleteUrl, body: {
        'id': id.toString(),
      });

      if (response.statusCode == 200) {
        var logSheetJson = json.decode(response.body);
        print(logSheetJson);
        int result = 0;

        if (logSheetJson['StatusCode'] == 200) {
          result = 1;
        }

        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {
      client.close();
    }
  }


  // Feedback
  static const String sendFeedbackUrl =
      'http://www.jteki.com/api/ou_pm/sendFeedbackEmail.php';


  static Future<int> sendEmailFeedback(String txt) async {

    http.Client client = new http.Client();
    try {
      final response = await client.post(sendFeedbackUrl, body: {
        'txt': txt,

      });

      if (response.statusCode == 200) {
        var feedbackJson = json.decode(response.body);

        int resp = feedbackJson['Response'];
        return resp;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {

      client.close();

    }
  }



  // Reminder
  static const String reminderListByProjectIdUrl =
      'http://www.jteki.com/api/ou_pm/getRemindersByProjectId.php';
  static const String reminderAddUrl =
      'http://www.jteki.com/api/ou_pm/reminder_add.php';
  static const String reminderEditUrl =
      'http://www.jteki.com/api/ou_pm/reminder_update.php';
  static const String reminderDeleteUrl =
      'http://www.jteki.com/api/ou_pm/reminder_delete.php';
  static const String reminderDetailsByIdUrl =
      'http://www.jteki.com/api/ou_pm/getReminderById.php';


  static Future<List<Reminder>> getRemindersByProjectId(int projectId) async {

    http.Client client = new http.Client();

    try{
      final response = await client.post(reminderListByProjectIdUrl, body: {
        'projectId': projectId.toString(),
      });

      var reminders = List<Reminder>();

      if (response.statusCode == 200) {
        var remindersJson = json.decode(response.body);

        for (var rJson in remindersJson) {
          reminders.add(Reminder.fromJson(rJson));
        }
      }

      return reminders;
    } catch (e){
      return null;
    } finally {

      client.close();
    }

  }


  static Future<int> addReminder(int projectId, String reminderText,
      DateTime cutOffDate, DateTime alertDate1, DateTime alertDate2,
      DateTime alertDate3) async {

    http.Client client = new http.Client();
    try {
      final response = await client.post(reminderAddUrl, body: {
        'projectId': projectId.toString(),
        'reminderText': reminderText,
        'cutOffDate': cutOffDate.toString(),
        'alertDate1': alertDate1.toString(),
        'alertDate2': alertDate2.toString(),
        'alertDate3': alertDate3.toString(),

      });

      if (response.statusCode == 200) {
        var reminderJson = json.decode(response.body);
        print(reminderJson);
        var lastId = reminderJson['Response']['insertedId'];
        return lastId;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {
      client.close();
    }
  }

  static Future<int> updateReminder(int id, String reminderText,
      DateTime cutOffDate, DateTime alertDate1, DateTime alertDate2,
      DateTime alertDate3) async {

    http.Client client = new http.Client();
    try {
      final response = await client.post(reminderEditUrl, body: {
        'id': id.toString(),
        'reminderText': reminderText,
        'cutOffDate': cutOffDate.toString(),
        'alertDate1': alertDate1.toString(),
        'alertDate2': alertDate2.toString(),
        'alertDate3': alertDate3.toString(),

      });

      if (response.statusCode == 200) {
        var reminderJson = json.decode(response.body);
        print(reminderJson);
        int result = 0;

        if (reminderJson['StatusCode'] == 200) {
          result = 1;
        }

        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {
      client.close();
    }
  }

  static Future<int> deleteReminder(int id) async {

    http.Client client = new http.Client();
    try {
      final response = await client.post(reminderDeleteUrl, body: {
        'id': id.toString(),
      });

      if (response.statusCode == 200) {
        var reminderJson = json.decode(response.body);
        print(reminderJson);
        int result = 0;

        if (reminderJson['StatusCode'] == 200) {
          result = 1;
        }

        return result;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    } finally {
      client.close();
    }
  }

  static Future<Reminder> getReminderById(int id) async {
    http.Client client = new http.Client();
    Reminder reminder;

    try {
      final response = await client.post(reminderDetailsByIdUrl, body: {
        'id': id.toString(),
      });

      if (response.statusCode == 200) {
        var reminderJson = json.decode(response.body);

        for (var rJson in reminderJson) {
          reminder = Reminder.fromJson(rJson);
        }
      }

      return reminder;
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }


}
