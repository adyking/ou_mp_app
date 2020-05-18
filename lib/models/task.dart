class Task {
  int id;
  int projectId;
  String name;
  DateTime startDate;
  DateTime endDate;
  String duration;
  String priority;
  double allocatedHours;
  int status;


  Task(this.id, this.projectId ,this.name, this.startDate, this.endDate,
      this.duration, this.priority, this.allocatedHours, this.status);

  Task.fromJson(Map<String, dynamic> json){
    id = int.parse(json['id']);
    projectId =  int.parse(json['projectId']);
    name = json['name'];
    startDate = DateTime.parse(json['startDate']);
    endDate =  DateTime.parse(json['endDate']);
    duration = json['duration'];
    priority = json['priority'];
    allocatedHours = double.parse(json['allocatedHours']);
    status = int.parse(json['status']);
  }

}
