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