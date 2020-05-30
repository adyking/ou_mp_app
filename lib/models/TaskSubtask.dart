class TaskSubtask {
  int taskId;
  int subtaskId;
  int projectId;
  String taskName;
  String subtaskName;
  DateTime taskStartDate;
  DateTime subtaskStartDate;
  int taskStatus;
  int subtaskStatus;
  int percentageCompleted;


  TaskSubtask(this.taskId, this.subtaskId ,this.taskName, this.subtaskName, this.taskStartDate,
      this.subtaskStartDate, this.taskStatus, this.subtaskStatus, this.percentageCompleted);

  TaskSubtask.fromJson(Map<String, dynamic> json){
    taskId = int.parse(json['taskId']);
    subtaskId =  int.parse(json['subtaskId']);
    taskName = json['taskName'];
    subtaskName = json['subtaskName'];
    taskStartDate = DateTime.parse(json['taskStartDate']);
    subtaskStartDate =  DateTime.parse(json['subtaskStartDate']);
    taskStatus = int.parse(json['taskStatus']);
    subtaskStatus = int.parse(json['subtaskStatus']);
    percentageCompleted = int.parse(json['percentageCompleted']);

  }

}
