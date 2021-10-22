import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String? docId = '', services = '';
  String stylistId = '',
      stylistName = '',
      cityBook = '',
      customerId = '',
      customerName = '',
      customerPhone = '',
      salonAddress = '',
      salonId = '',
      salonName = '',
      time = '';

  double totalPrice = 0;
  bool done = false;
  int slot = 0, timeStamp = 0;

  DocumentReference? reference;

  BookingModel(
      {this.docId,
      required this.stylistId,
      required this.stylistName,
      required this.cityBook,
      required this.customerId,
      required this.customerName,
      required this.customerPhone,
      required this.salonAddress,
      required this.salonId,
      required this.salonName,
      this.services,
      required this.time,
      required this.done,
      required this.slot,
      required this.totalPrice,
      required this.timeStamp});

  BookingModel.fromJson(Map<String, dynamic> json) {
    stylistId = json['stylistId'];
    stylistName = json['stylistName'];
    cityBook = json['cityBook'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    customerPhone = json['customerPhone'];
    salonAddress = json['salonAddress'];
    salonName = json['salonName'];
    salonId = json['salonId'];
    services = json['services'];
    time = json['time'];
    done = json['done'];
    slot = int.parse(json['slot'] == null ? '-1' : json['slot'].toString());
    totalPrice = double.parse(
        json['totalPrice'] == null ? '0' : json['totalPrice'].toString());
    timeStamp = int.parse(
        json['timeStamp'] == null ? '0' : json['timeStamp'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stylistId'] = this.stylistId;
    data['stylistName'] = this.stylistName;
    data['cityBook'] = this.cityBook;
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['customerPhone'] = this.customerPhone;
    data['salonAddress'] = this.salonAddress;
    data['salonId'] = this.salonId;
    data['salonName'] = this.salonName;
    data['time'] = this.time;
    data['done'] = this.done;
    data['slot'] = this.slot;
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}
