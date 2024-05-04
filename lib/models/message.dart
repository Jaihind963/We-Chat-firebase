class Message {
  Message({
    required this.msg,
    required this.toId,
    required this.read,
    required this.type,
    required this.send,
    required this.fromId,
  });
  late  String msg;
  late  String toId;
  late  String read;
  late  Type type;
  late  String send;
  late  String fromId;
  
  Message.fromJson(Map<String, dynamic> json){
    msg = json['msg'].toString();
    toId = json['toId'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name? Type.image: Type.text;
    send = json['send'].toString();
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['toId'] = toId;
    data['read'] = read;
    data['type'] = type;
    data['send'] = send;
    data['fromId'] = fromId;
    return data;
  }
}
enum Type{image, text}