import 'dart:ui';
import 'package:beautycon/state/state_management.dart';
import 'package:beautycon/view_model/booking/booking_view_model_imp.dart';
import 'package:beautycon/widgets/my_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_stepper/stepper.dart';
import 'components/user_widgets/city_list.dart';
import 'components/user_widgets/confirm.dart';
import 'components/user_widgets/salon_list.dart';
import 'components/user_widgets/stylist_list.dart';
import 'components/user_widgets/time_slot.dart';

class BookingScreen extends ConsumerWidget {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final bookingViewModel = new BookingViewModelImp();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var step = watch(currentStep).state;
    var cityWatch = watch(selectedCity).state;
    var salonWatch = watch(selectedSalon).state;
    var stylistWatch = watch(selectedStylist).state;
    var dateWatch = watch(selectedDate).state;
    var timeWatch = watch(selectedTime).state;
    var timeSlotWatch = watch(selectedTimeSlot).state;

    var isLoadingWatch = watch(isLoading).state;

    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Booking'),
        backgroundColor: Color(0xFF383838),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFFDF9EE),
      body: Column(
        children: [
          //Step
          NumberStepper(
            activeStep: step - 1,
            direction: Axis.horizontal,
            enableNextPreviousButtons: false,
            enableStepTapping: false,
            numbers: [1, 2, 3, 4, 5],
            stepColor: Colors.black,
            activeStepColor: Colors.grey,
            numberStyle: TextStyle(color: Colors.white),
          ),
          //Screen
          Expanded(
              flex: 10,
              child: step == 1
                  ? displayCityList(bookingViewModel)
                  : step == 2
                      ? displaySalon(bookingViewModel, cityWatch.name)
                      : step == 3
                          ? displayStylist(bookingViewModel, salonWatch)
                          : step == 4
                              ? displayTimeSlot(
                                  bookingViewModel, context, stylistWatch)
                              : step == 5
                                  ? isLoadingWatch ? MyLoadingWidget(text: 'We are setting up your booking') : displayConfirm(
                                      bookingViewModel, context, scaffoldKey)
                                  : Container()),
          //Button
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      child: Text('Previous'),
                      onPressed: step == 1
                          ? null
                          : () => context.read(currentStep).state--,
                    )),
                    SizedBox(width: 30),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: (step == 1 &&
                                  context
                                          .read(selectedCity)
                                          .state
                                          .name
                                          .length ==
                                      0) ||
                              (step == 2 &&
                                  context
                                          .read(selectedSalon)
                                          .state
                                          .docId!
                                          .length ==
                                      0) ||
                              (step == 3 &&
                                  context
                                          .read(selectedStylist)
                                          .state
                                          .docId!
                                          .length ==
                                      0) ||
                              (step == 4 &&
                                  context.read(selectedTimeSlot).state == -1)
                          ? null
                          : step == 5
                              ? null
                              : () => context.read(currentStep).state++,
                      child: Text('Next'),
                    )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
