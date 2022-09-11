class ActivityModel{
  String? id;
  String? uid;
  String? avatarUrl;
  String? activityTitle;
  DateTime? time;

  ActivityModel({
    this.id,
    this.uid,
    this.avatarUrl,
    this.activityTitle,
    this.time,
  }); 

  ActivityModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    uid = json['uid'];
    avatarUrl = json['avatar_url'];
    activityTitle = json['activity_title'];
    time = DateTime.tryParse(json['time']);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'avatar_url': avatarUrl,
    'activity_title': activityTitle,
    'time': time?.toIso8601String()
  };

}