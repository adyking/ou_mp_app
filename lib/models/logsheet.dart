class LogSheet {
  int id;
  int projectId;
  String timeSpent;
  String work;
  String problems;
  String comments;
  String nextWorkPlanned;
  DateTime loggedDate;
  String loggedTime;


  LogSheet(this.id, this.projectId ,this.timeSpent, this.work, this.problems,
      this.comments,this.nextWorkPlanned, this.loggedDate, this.loggedTime);

  LogSheet.fromJson(Map<String, dynamic> json){
    id = int.parse(json['id']);
    projectId =  int.parse(json['projectId']);
    timeSpent = json['timeSpent'];
    work = json['work'];
    problems = json['problems'];
    comments = json['comments'];
    nextWorkPlanned = json['nextWorkPlanned'];
    loggedDate =  DateTime.parse(json['loggedDate']);
    loggedTime =  json['loggedTime'];
  }

}
