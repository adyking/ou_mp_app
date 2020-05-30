class LogSheet {
  int id;
  int projectId;
  String timeSpent;
  String work;
  String problems;
  String nextWorkPlanned;
  DateTime loggedDate;
  DateTime loggedTime;


  LogSheet(this.id, this.projectId ,this.timeSpent, this.work, this.problems,
      this.nextWorkPlanned, this.loggedDate, this.loggedTime);

  LogSheet.fromJson(Map<String, dynamic> json){
    id = int.parse(json['id']);
    projectId =  int.parse(json['studentId']);
    timeSpent = json['timeSpent'];
    work = json['work'];
    problems = json['problems'];
    nextWorkPlanned = json['nextWorkPlanned'];
    loggedDate =  DateTime.parse(json['loggedDate']);
    loggedTime =  DateTime.parse(json['loggedTime']);
  }

}
