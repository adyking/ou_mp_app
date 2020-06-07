import 'package:ou_mp_app/utils/services_api.dart';

class SysUpdate {


  static updateTasksSubtasksOverdue(int projectId, DateTime date){

    // get all tasks that are overdue and for each mark as status 2

    ServicesAPI.getOverdueTasksByProjectId(projectId, date).then((value)  {

      var taskList = value;

      for(var i = 0; i < taskList.length; i ++){

         ServicesAPI.updateTaskStatus(taskList[i].id, 2);
         ServicesAPI.updateSubtaskStatusOverdueByTaskId(taskList[i].id);

      }


    });

  }

  static updateSubtasksOverdue(int projectId) {

    // get all tasks that are currently pending
    DateTime today = DateTime.now();


    ServicesAPI.getPendingTasksByProjectId(projectId).then((value)  {

      var taskList = value;

      for(var i = 0; i < taskList.length; i ++){


        ServicesAPI.getPendingSubtasksByTaskId(taskList[i].id).then((value) {


          var subtasksList = value;

          for(var i2 = 0; i2 < subtasksList.length; i2 ++){

            int diffDays = today.difference(subtasksList[i2].endDate).inDays;

            if (diffDays > 0) {


                  ServicesAPI.updateSubtaskStatus(subtasksList[i2].id, 2);

            }

          }




        });



      }


    });

  }

  static updateProjectOverdue(int studentId, DateTime date){

    // get all projects that are overdue and for each mark as status 2

    ServicesAPI.getOverdueProjectByStudentId(studentId, date).then((value)  {

      var projectList = value;

      for(var i = 0; i < projectList.length; i ++){

        ServicesAPI.updateProjectStatus(projectList[i].id, 2);

      }


    });

  }


}