import 'dart:convert';
import 'package:beautycon/model/booking_model.dart';
import 'package:beautycon/model/stylist_model.dart';
import 'package:beautycon/model/city_model.dart';
import 'package:beautycon/model/salon_model.dart';
import 'package:beautycon/state/state_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Future<BookingModel> getDetailBooking(
    BuildContext context, int timeSlot) async {
  CollectionReference userRef = FirebaseFirestore.instance
      .collection('AllSalon')
      .doc(context.read(selectedCity).state.name)
      .collection('Branch')
      .doc(context.read(selectedSalon).state.docId)
      .collection('Stylist')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(
          DateFormat('dd_MM_yyyy').format(context.read(selectedDate).state));
  DocumentSnapshot snapshot = await userRef.doc(timeSlot.toString()).get();
  if (snapshot.exists) {
    var bookingModel =
        BookingModel.fromJson(json.decode(json.encode(snapshot.data())));
    bookingModel.docId = snapshot.id;
    bookingModel.reference = snapshot.reference;
    context.read(selectedBooking).state = bookingModel;
    return bookingModel;
  } else
    return BookingModel(
        totalPrice: 0,
        customerName: '',
        time: '',
        customerId: '',
        stylistName: '',
        cityBook: '',
        customerPhone: '',
        stylistId: '',
        slot: 0,
        timeStamp: 0,
        done: false,
        salonName: '',
        salonId: '',
        salonAddress: '');
}

Future<List<CityModel>> getCities() async {
  var cities = new List<CityModel>.empty(growable: true);
  var cityRef = FirebaseFirestore.instance.collection('AllSalon');
  var snapshot = await cityRef.get();
  snapshot.docs.forEach((element) {
    cities.add(CityModel.fromJson(element.data()));
  });
  return cities;
}

Future<List<SalonModel>> getSalonByCity(String cityName) async {
  var salons = new List<SalonModel>.empty(growable: true);
  var salonRef = FirebaseFirestore.instance
      .collection('AllSalon')
      .doc(cityName.replaceAll(' ', ''))
      .collection('Branch');
  var snapshot = await salonRef.get();
  snapshot.docs.forEach((element) {
    var salon = SalonModel.fromJson(element.data());
    salon.docId = element.id;
    salon.reference = element.reference;
    salons.add(salon);
  });
  return salons;
}

Future<List<StylistModel>> getStylistsBySalon(SalonModel salon) async {
  var stylists = new List<StylistModel>.empty(growable: true);
  var stylistRef = salon.reference!.collection('Stylist');
  var snapshot = await stylistRef.get();
  snapshot.docs.forEach((element) {
    var stylist = StylistModel.fromJson(element.data());
    stylist.docId = element.id;
    stylist.reference = element.reference;
    stylists.add(stylist);
  });
  return stylists;
}

Future<List<int>> getTimeSlotOfStylist(
    StylistModel stylistModel, String date) async {
  List<int> result = new List<int>.empty(growable: true);
  var bookingRef = stylistModel.reference!.collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  snapshot.docs.forEach((element) {
    result.add(int.parse(element.id));
  });
  return result;
}

Future<bool> checkStaffOfThisSalon(BuildContext context) async {
  DocumentSnapshot stylistSnapshot = await FirebaseFirestore.instance
      .collection('AllSalon')
      .doc('${context.read(selectedCity).state.name}')
      .collection('Branch')
      .doc(context.read(selectedSalon).state.docId)
      .collection('Stylist')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  return stylistSnapshot.exists;
}

Future<List<int>> getBookingSlotOfStylist(
    BuildContext context, String date) async {
  var stylistDocument = await FirebaseFirestore.instance
      .collection('AllSalon')
      .doc('${context.read(selectedCity).state.name}')
      .collection('Branch')
      .doc(context.read(selectedSalon).state.docId)
      .collection('Stylist')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  List<int> result = new List<int>.empty(growable: true);
  var bookingRef = stylistDocument.collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  snapshot.docs.forEach((element) {
    result.add(int.parse(element.id));
  });
  return result;
}
