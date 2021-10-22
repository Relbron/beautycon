import 'package:beautycon/model/booking_model.dart';
import 'package:flutter/material.dart';

abstract class StylistBookingHistoryViewModel {
  Future<List<BookingModel>> getStylistBookingHistory(
      BuildContext context, DateTime dateTime);
}
