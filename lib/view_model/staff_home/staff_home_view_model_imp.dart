import 'package:beautycon/cloud_firestore/all_salon_ref.dart';
import 'package:beautycon/model/city_model.dart';
import 'package:beautycon/model/salon_model.dart';
import 'package:beautycon/state/state_management.dart';
import 'package:beautycon/utils/utils.dart';
import 'package:beautycon/view_model/staff_home/staff_home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffHomeViewModelImp implements StaffHomeViewModel{
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
  Future<List<int>> displayBookingSlotOfStylist(BuildContext context, String date) {
    return getBookingSlotOfStylist(context, date);
  }

  @override
  Future<int> displayMaxAvailableTimeSlot(DateTime dt) {
    return getMaxAvailableTimeSlot(dt);
  }

  @override
  Future<bool> isStaffOfThisSalon(BuildContext context) {
    return checkStaffOfThisSalon(context);
  }

  @override
  bool isTimeSlotBooked(List<int> listTimeSlot, int index) {
    return listTimeSlot.contains(index) ? false: true;
  }

  @override
  void processDoneServices(BuildContext context, int index) {
    context.read(selectedTimeSlot).state = index;
    Navigator.of(context).pushNamed('/doneService');
  }

  @override
  Color getColorOfThisSlot(BuildContext context, List<int> listTimeSlot, int index, int maxTimeSlot) {
    return listTimeSlot.contains(index)
        ? Colors.white10
        : maxTimeSlot > index
        ? Colors.white60
        : context.read(selectedTime).state ==
        TIME_SLOT.elementAt(index)
        ? Colors.white54
        : Colors.white;
  }
}