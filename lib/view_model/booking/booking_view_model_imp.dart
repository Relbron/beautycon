import 'dart:ui';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:beautycon/cloud_firestore/all_salon_ref.dart';
import 'package:beautycon/fcm/notification_send.dart';
import 'package:beautycon/model/booking_model.dart';
import 'package:beautycon/model/city_model.dart';
import 'package:beautycon/model/notification_payload_model.dart';
import 'package:beautycon/model/salon_model.dart';
import 'package:beautycon/model/stylist_model.dart';
import 'package:beautycon/state/state_management.dart';
import 'package:beautycon/string/strings.dart';
import 'package:beautycon/utils/utils.dart';
import 'package:beautycon/view_model/booking/booking_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BookingViewModelImp implements BookingViewModel {
  @override
  Future<List<CityModel>> displayCities() {
    return getCities();
  }

  @override
  bool isCitySelected(BuildContext context, CityModel cityModel) {
    return context.read(selectedCity).state.name == cityModel.name;
  }

  @override
  void onSelectedCity(BuildContext context, CityModel cityModel) {
    context.read(selectedCity).state = cityModel;
  }

  @override
  Future<List<SalonModel>> displaySalonByCity(String cityName) {
    return getSalonByCity(cityName);
  }

  @override
  bool isSalonSelected(BuildContext context, SalonModel salonModel) {
    return context.read(selectedSalon).state.docId == salonModel.docId;
  }

  @override
  void onSelectedSalon(BuildContext context, SalonModel salonModel) {
    context.read(selectedSalon).state = salonModel;
  }

  @override
  Future<List<StylistModel>> displayStylistsBySalon(SalonModel salonModel) {
    return getStylistsBySalon(salonModel);
  }

  @override
  bool isStylistSelected(BuildContext context, StylistModel stylistModel) {
    return context.read(selectedStylist).state.docId == stylistModel.docId;
  }

  @override
  void onSelectedStylist(BuildContext context, StylistModel stylistModel) {
    context.read(selectedStylist).state = stylistModel;
  }

  @override
  Color displayColorTimeSlot(BuildContext context, List<int> listTimeSlot,
      int index, int maxTimeSlot) {
    return listTimeSlot.contains(index)
        ? Colors.white10
        : maxTimeSlot > index
            ? Colors.white60
            : context.read(selectedTime).state == TIME_SLOT.elementAt(index)
                ? Colors.white54
                : Colors.white;
  }

  @override
  Future<int> displayMaxAvailableTimeslot(DateTime dt) {
    return getMaxAvailableTimeSlot(dt);
  }

  @override
  Future<List<int>> displayTimeSlotOfStylist(
      StylistModel stylistModel, String date) {
    return getTimeSlotOfStylist(stylistModel, date);
  }

  @override
  bool isAvailableForTapTimeSlot(
      int maxTime, int index, List<int> listTimeSlot) {
    return (maxTime > index) || listTimeSlot.contains(index);
  }

  @override
  void onSelectedTimeSlot(BuildContext context, int index) {
    context.read(selectedTimeSlot).state = index;
    context.read(selectedTime).state = TIME_SLOT.elementAt(index);
  }

  @override
  void confirmBooking(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    var hour = context.read(selectedTime).state.length <= 10
        ? int.parse(
            context.read(selectedTime).state.split(':')[0].substring(0, 1))
        : int.parse(
            context.read(selectedTime).state.split(':')[0].substring(0, 2));

    var minutes = context.read(selectedTime).state.length <= 10
        ? int.parse(
            context.read(selectedTime).state.split(':')[1].substring(0, 1))
        : int.parse(
            context.read(selectedTime).state.split(':')[1].substring(0, 2));

    var timeStamp = DateTime(
            context.read(selectedDate).state.year,
            context.read(selectedDate).state.month,
            context.read(selectedDate).state.day,
            hour,
            minutes)
        .millisecondsSinceEpoch;
    //Create booking model
    var bookingModel = BookingModel(
      totalPrice: 0,
      stylistId: context.read(selectedStylist).state.docId!,
      stylistName: context.read(selectedStylist).state.name,
      cityBook: context.read(selectedCity).state.name,
      customerId: FirebaseAuth.instance.currentUser!.uid,
      customerName: context.read(userInformation).state.name,
      customerPhone: FirebaseAuth.instance.currentUser!.phoneNumber!,
      done: false,
      salonAddress: context.read(selectedSalon).state.address,
      salonId: context.read(selectedSalon).state.docId!,
      salonName: context.read(selectedSalon).state.name,
      slot: context.read(selectedTimeSlot).state,
      timeStamp: timeStamp,
      time:
          '${context.read(selectedTime).state} -${DateFormat('dd/MM/yyyy').format(context.read(selectedDate).state)}',
    );

    var batch = FirebaseFirestore.instance.batch();

    DocumentReference stylistBooking = context
        .read(selectedStylist)
        .state
        .reference!
        .collection(
            '${DateFormat('dd/MM/yyyy').format(context.read(selectedDate).state)}')
        .doc(context.read(selectedTimeSlot).state.toString());

    DocumentReference userBooking = FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber!)
        .collection('Booking_${FirebaseAuth.instance.currentUser!.uid}')
        .doc(
            '${context.read(selectedStylist).state.docId}_${DateFormat('dd_MM_yyyy').format(context.read(selectedDate).state)}');

    batch.set(stylistBooking, bookingModel.toJson());
    batch.set(userBooking, bookingModel.toJson());
    batch.commit().then((value) {
      
      context.read(isLoading).state = true;
      var notificationPayload = NotificationPayloadModel(
          to: '/topics/${context.read(selectedStylist).state.docId!}',
          notification: NotificationContent('New Booking',
              'You have a new appointment booking from ${FirebaseAuth.instance.currentUser!.phoneNumber}'));

      sendNotification(notificationPayload)
      .then((value) {
        context.read(isLoading).state = false;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(content: Text('Booking succesfully')));
        //Reset value
        context.read(selectedDate).state = DateTime.now();
        context.read(selectedStylist).state = StylistModel();
        context.read(selectedCity).state = CityModel(name: '');
        context.read(selectedSalon).state = SalonModel(name: '', address: '');
        context.read(currentStep).state = 1;
        context.read(selectedTime).state = '';
        context.read(selectedTimeSlot).state = -1;

        //Create Event
        final event = Event(
            title: titleText,
            description:
            'Stylist Appointment ${context.read(selectedTime).state} - '
                '${DateFormat('dd/MM/yyyy').format(context.read(selectedDate).state)}',
            location: '${context.read(selectedSalon).state.address}',
            startDate: DateTime(
                context.read(selectedDate).state.year,
                context.read(selectedDate).state.month,
                context.read(selectedDate).state.day,
                hour,
                minutes),
            endDate: DateTime(
                context.read(selectedDate).state.year,
                context.read(selectedDate).state.month,
                context.read(selectedDate).state.day,
                hour,
                minutes + 30),
            iosParams: IOSParams(reminder: Duration(minutes: 30)),
            androidParams: AndroidParams(emailInvites: []));
        Add2Calendar.addEvent2Cal(event).then((value) {});
      });
    });
  }
}
