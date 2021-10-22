import 'package:beautycon/model/booking_model.dart';
import 'package:beautycon/model/service_model.dart';
import 'package:beautycon/model/stylist_model.dart';
import 'package:beautycon/model/city_model.dart';
import 'package:beautycon/model/salon_model.dart';
import 'package:beautycon/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userLogged = StateProvider((ref) => FirebaseAuth.instance.currentUser);
final userToken = StateProvider((ref) => '');
final forceReload = StateProvider((ref) => false);

final userInformation = StateProvider((ref) => UserModel(name: '', address: ''));

//Booking state
final currentStep = StateProvider((ref) => 1);
final selectedCity = StateProvider((ref) => CityModel(name: ''));
final selectedSalon = StateProvider((ref) => SalonModel(name: '', address: ''));
final selectedStylist = StateProvider((ref) => StylistModel());
final selectedDate = StateProvider((ref) => DateTime.now());
final selectedTimeSlot = StateProvider((ref) => -1);
final selectedTime = StateProvider((ref) => '');

//Delete Booking
final deleteFlagRefresh = StateProvider((ref) => false);

//Staff
final staffStep = StateProvider((ref) => 1);
final selectedBooking = StateProvider((ref) => BookingModel(
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
    salonAddress: ''));
final selectedServices =
    StateProvider((ref) => List<ServiceModel>.empty(growable: true));

//Loading
final isLoading = StateProvider((ref) => false);