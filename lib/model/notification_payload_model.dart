
class NotificationPayloadModel{
  String to = '';
  NotificationContent notification = new NotificationContent('', '');

  NotificationPayloadModel({required this.to, required this.notification});

  NotificationPayloadModel.fromJson(Map<String, dynamic> data){
    to = data['to'];
    notification = data['notification'];
    NotificationContent('', '');
  }

  Map<String, dynamic> toJson(){
    final data = new Map<String, dynamic>();
    data['to'] = to;
    data['notification'] = notification.toJson();
    return data;
  }

}

class NotificationContent{
  String title = '', body = '';

  NotificationContent(this.title, this.body);

  NotificationContent.fromJson(Map<String, dynamic> data){
    title = data['title'];
    body = data['body'];
  }

  Map<String, dynamic> toJson(){
    final data = new Map<String, dynamic>();
    data['title'] = title;
    data['body'] = body;
    return data;
  }
}