class MessageModel {
  String? id;
  String? senderId;
  String? receiverId;
  String? message;
  DateTime? time;

  MessageModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.time,
  });

  MessageModel.fromModel(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    time = DateTime.tryParse(json['time']);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender_id': senderId,
    'receiver_id': receiverId,
    'message': message,
    'time': time?.toIso8601String(),
  };
}
