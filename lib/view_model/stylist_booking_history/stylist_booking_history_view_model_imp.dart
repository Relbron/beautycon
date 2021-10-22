import 'package:beautycon/model/booking_model.dart';
import 'package:beautycon/state/state_management.dart';
import 'package:beautycon/view_model/stylist_booking_history/stylist_booking_history_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StylistBookingHistoryViewModelImp
    implements StylistBookingHistoryViewModel {
  @override
  Future<List<BookingModel>> getStylistBookingHistory(
      BuildContext context, DateTime dateTime) async{
    var listBooking = List<BookingModel>.empty(growable: true);
    var stylistDocument = FirebaseFirestore.instance
        .collection('AllSalon')
        .doc('${context.read(selectedCity).state.name}')
        .collection('Branch')
        .doc('${context.read(selectedSalon).state.docId}')
        .collection('Stylist')
        .doc('${FirebaseAuth.instance.currentUser!.uid}')
        .collection(DateFormat('dd_MM_yyyy').format(dateTime));
    var snapshot = await stylistDocument.get();
    snapshot.docs.forEach((element) {
      var stylistBooking = BookingModel.fromJson(element.data());
      stylistBooking.docId = element.id;
      stylistBooking.reference = element.reference;
      listBooking.add(stylistBooking);
    });
    return listBooking;
  }
}
