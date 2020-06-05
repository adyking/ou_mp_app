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
  double taskAllocatedHours;
  double subtaskAllocatedHours;
  DateTime taskEndDate;
  DateTime subtaskEndDate;
  int isDone;


  TaskSubtask(this.taskId, this.subtaskId ,this.taskName, this.subtaskName, this.taskStartDate,
      this.subtaskStartDate, this.taskStatus, this.subtaskStatus, this.percentageCompleted,
      this.taskAllocatedHours, this.subtaskAllocatedHours, this.taskEndDate, this.subtaskEndDate,
      this.isDone);




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
    taskAllocatedHours = double.parse(json['taskAllocatedHours']);
    subtaskAllocatedHours = double.parse(json['subtaskAllocatedHours']);

  }

  TaskSubtask.fromJsonHome(Map<String, dynamic> json){
    taskId = int.parse(json['taskId']);
    subtaskId =  int.parse(json['subtaskId']);
    taskName = json['taskName'];
    subtaskName = json['subtaskName'];
    taskStartDate = DateTime.parse(json['taskStartDate']);
    subtaskStartDate =  DateTime.parse(json['subtaskStartDate']);
    taskStatus = int.parse(json['taskStatus']);
    subtaskStatus = int.parse(json['subtaskStatus']);
    taskAllocatedHours = double.parse(json['taskAllocatedHours']);
    subtaskAllocatedHours = double.parse(json['subtaskAllocatedHours']);

  }
  TaskSubtask.fromJsonOverdue(Map<String, dynamic> json){
    taskId = int.parse(json['taskId']);
    subtaskId =  int.parse(json['subtaskId']);
    taskName = json['taskName'];
    subtaskName = json['subtaskName'];
    taskStartDate = DateTime.parse(json['taskStartDate']);
    subtaskStartDate =  DateTime.parse(json['subtaskStartDate']);
    taskStatus = int.parse(json['taskStatus']);
    subtaskStatus = int.parse(json['subtaskStatus']);
    taskAllocatedHours = double.parse(json['taskAllocatedHours']);
    subtaskAllocatedHours = double.parse(json['subtaskAllocatedHours']);
    taskEndDate = DateTime.parse(json['taskEndDate']);
    subtaskEndDate =  DateTime.parse(json['subtaskEndDate']);

  }

  TaskSubtask.fromJsonAgenda(Map<String, dynamic> json){
    taskId = int.parse(json['taskId']);
    subtaskId =  int.parse(json['subtaskId']);
    taskName = json['taskName'];
    subtaskName = json['subtaskName'];
    taskStartDate = DateTime.parse(json['taskStartDate']);
    subtaskStartDate =  DateTime.parse(json['subtaskStartDate']);
    taskStatus = int.parse(json['taskStatus']);
    subtaskStatus = int.parse(json['subtaskStatus']);
    taskAllocatedHours = double.parse(json['taskAllocatedHours']);
    subtaskAllocatedHours = double.parse(json['subtaskAllocatedHours']);
    taskEndDate = DateTime.parse(json['taskEndDate']);
    subtaskEndDate =  DateTime.parse(json['subtaskEndDate']);
    isDone =  int.parse(json['isDone']);

  }

}
