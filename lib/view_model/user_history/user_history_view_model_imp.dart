import 'package:beautycon/cloud_firestore/user_ref.dart';
import 'package:beautycon/model/booking_model.dart';
import 'package:beautycon/state/state_management.dart';
import 'package:beautycon/view_model/user_history/user_history_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserHistoryViewModelImp implements UserHistoryViewModel{
  @override
  Future<List<BookingModel>> displayUserHistory() {
    return getUserHistory();
  }

  @override
  void userCancelBooking(BuildContext context, BookingModel bookingModel) {
    var batch = FirebaseFirestore.instance.batch();
    var stylistBooking = FirebaseFirestore.instance
        .collection('AllSalon')
        .doc(bookingModel.cityBook)
        .collection('Branch')
        .doc(bookingModel.salonId)
        .collection('Stylist')
        .doc(bookingModel.stylistId)
        .collection(DateFormat('dd_MM_yyyy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp)))
        .doc(bookingModel.slot.toString());
    var userBooking = bookingModel.reference;

    //Delete
    batch.delete(userBooking!);
    batch.delete(stylistBooking);
    batch.commit().then((value) {

      //Refresh data
      context.read(deleteFlagRefresh).state = !context.read(deleteFlagRefresh).state;

    });
  }

}