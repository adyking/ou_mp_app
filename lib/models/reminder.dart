class Reminder {
  int id;
  int projectId;
  String reminderText;
  DateTime cutOffDate;
  DateTime alertDate1;
  DateTime alertDate2;
  DateTime alertDate3;
  int isAlerted1;
  int isAlerted2;
  int isAlerted3;


  Reminder(this.id, this.projectId ,this.reminderText, this.cutOffDate, this.alertDate1,
      this.alertDate2,this.alertDate3, this.isAlerted1, this.isAlerted2, this.isAlerted3);

  Reminder.fromJson(Map<String, dynamic> json){
    id = int.parse(json['id']);
    projectId =  int.parse(json['projectId']);
    reminderText = json['reminderText'];
    cutOffDate =  DateTime.parse(json['cutOffDate']);
    alertDate1 =  DateTime.parse(json['alert1']);
    alertDate2 =  DateTime.parse(json['alert2']);
    alertDate3 =  DateTime.parse(json['alert3']);
    isAlerted1 =  int.parse(json['isAlerted1']);
    isAlerted2 =  int.parse(json['isAlerted2']);
    isAlerted3 =  int.parse(json['isAlerted3']);
  }

}
