import 'package:beautycon/state/state_management.dart';
import 'package:beautycon/string/strings.dart';
import 'package:beautycon/ui/components/staff_widgets/city_list.dart';
import 'package:beautycon/view_model/staff_home/staff_home_view_model_imp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/staff_widgets/appointment_list.dart';
import 'components/staff_widgets/salon_list.dart';

class StaffHome extends ConsumerWidget {
  final staffHomeViewModel = StaffHomeViewModelImp();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var currentStaffStep = watch(staffStep).state;
    var cityWatch = watch(selectedCity).state;
    var salonWatch = watch(selectedSalon).state;
    var dateWatch = watch(selectedDate).state;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFDFDFDF),
      appBar: AppBar(
        title: Text(currentStaffStep == 1
            ? selectCityText
            : currentStaffStep == 2
                ? selectSalonText
                : currentStaffStep == 3
                    ? yourAppointmentText
                    : staffHomeText),
        backgroundColor: Color(0xFF383838),
        actions: [
          currentStaffStep == 3
              ? InkWell(
                  child: Icon(Icons.history),
                  onTap: () =>
                      Navigator.of(context).pushNamed('/bookingHistory'),
                )
              : Container()
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: currentStaffStep == 1
                ? staffDisplayCity(staffHomeViewModel)
                : currentStaffStep == 2
                    ? staffDisplaySalon(staffHomeViewModel, cityWatch.name)
                    : currentStaffStep == 3
                        ? displayAppointment(staffHomeViewModel, context)
                        : Container(),
            flex: 10,
          ),
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
                      child: Text(previous),
                      onPressed: currentStaffStep == 1
                          ? null
                          : () => context.read(staffStep).state--,
                    )),
                    SizedBox(width: 30),
                    Expanded(
                        child: ElevatedButton(
                      child: Text(nextText),
                      onPressed: (currentStaffStep == 1 &&
                                  context
                                          .read(selectedCity)
                                          .state
                                          .name
                                          .length ==
                                      0) ||
                              (currentStaffStep == 2 &&
                                  context
                                          .read(selectedSalon)
                                          .state
                                          .docId!
                                          .length ==
                                      0) ||
                              currentStaffStep == 3
                          ? null
                          : () => context.read(staffStep).state++,
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
