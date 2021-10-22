import 'package:beautycon/model/city_model.dart';
import 'package:beautycon/model/salon_model.dart';
import 'package:beautycon/model/stylist_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


abstract class BookingViewModel{
  Future<List<CityModel>> displayCities();
  void onSelectedCity(BuildContext context, CityModel cityModel);
  bool isCitySelected(BuildContext context, CityModel cityModel);

  //Salon
  Future<List<SalonModel>> displaySalonByCity(String cityName);
  void onSelectedSalon(BuildContext context, SalonModel salonModel);
  bool isSalonSelected(BuildContext context, SalonModel salonModel);

  //Stylist
  Future<List<StylistModel>> displayStylistsBySalon(SalonModel salonModel);
  void onSelectedStylist(BuildContext context, StylistModel stylistModel);
  bool isStylistSelected(BuildContext context, StylistModel stylistModel);

  //TimeSlot
  Future<int> displayMaxAvailableTimeslot(DateTime dt);
  Future<List<int>> displayTimeSlotOfStylist(StylistModel stylistModel, String date);
  bool isAvailableForTapTimeSlot(int maxTime, int index, List<int> listTimeSlot);
  void onSelectedTimeSlot(BuildContext context, int index);
  Color displayColorTimeSlot(BuildContext context, List<int> listTimeSlot, int index, int maxTimeSlot);

  void confirmBooking(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey);
}