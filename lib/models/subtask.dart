class Subtask {
  int id;
  int taskId;
  String name;
  DateTime startDate;
  DateTime endDate;
  String duration;
  String priority;
  double allocatedHours;
  int status;


  Subtask(this.id, this.taskId ,this.name, this.startDate, this.endDate,
      this.duration, this.priority, this.allocatedHours, this.status);

  Subtask.fromJson(Map<String, dynamic> json){
    id = int.parse(json['id']);
    taskId =  int.parse(json['taskId']);
    name = json['name'];
    startDate = DateTime.parse(json['startDate']);
    endDate =  DateTime.parse(json['endDate']);
    duration = json['duration'];
    priority = json['priority'];
    allocatedHours = double.parse(json['allocatedHours']);
    status = int.parse(json['status']);
  }

}
