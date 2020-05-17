class Project {
  int id;
  int studentId;
  String name;
  String description;
  String category;
  DateTime startDate;
  DateTime endDate;
  int status;

  Project(this.id, this.studentId ,this.name, this.description, this.category,
      this.startDate, this.endDate, this.status);

  Project.fromJson(Map<String, dynamic> json){
    id = int.parse(json['id']);
    studentId =  int.parse(json['studentId']);
    name = json['name'];
    description = json['description'];
    category = json['category'];
    startDate = DateTime.parse(json['startDate']);
    endDate =  DateTime.parse(json['endDate']);
    status = int.parse(json['status']);
  }

}
