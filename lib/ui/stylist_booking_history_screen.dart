import 'package:beautycon/model/booking_model.dart';
import 'package:beautycon/state/staff_user_history_state.dart';
import 'package:beautycon/state/state_management.dart';
import 'package:beautycon/utils/utils.dart';
import 'package:beautycon/view_model/stylist_booking_history/stylist_booking_history_view_model.dart';
import 'package:beautycon/view_model/stylist_booking_history/stylist_booking_history_view_model_imp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class StylistHistoryScreen extends ConsumerWidget {
  final stylistHistoryViewModel = StylistBookingHistoryViewModelImp();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var dateWatch = watch(stylistHistorySelectedDate).state;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xFFDFDFDF),
      appBar: AppBar(
        title: Text('StylistHistory'),
        backgroundColor: Color(0xFF383838),
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFF008577),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            '${DateFormat.MMMM().format(dateWatch)}',
                            style: GoogleFonts.robotoMono(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                          Text(
                            '${dateWatch.day}',
                            style: GoogleFonts.robotoMono(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                          Text(
                            '${DateFormat.EEEE().format(dateWatch)}',
                            style: GoogleFonts.robotoMono(
                                color: Colors.white54,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        onConfirm: (date) => context
                            .read(stylistHistorySelectedDate)
                            .state = date);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.calendar_today, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: FutureBuilder(
              future: stylistHistoryViewModel.getStylistBookingHistory(
                  context, dateWatch),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  var userBookings = snapshot.data as List<BookingModel>;
                  if (userBookings.length == 0)
                    return Center(
                      child: Text('You have not booking on this date'),
                    );
                  else
                    return FutureBuilder(
                        future: syncTime(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          else {
                            var syncTime = snapshot.data as DateTime;
                            return ListView.builder(
                                itemCount: userBookings.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(22))),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        'Date',
                                                        style: GoogleFonts
                                                            .robotoMono(),
                                                      ),
                                                      Text(
                                                        DateFormat('dd/MM/yy')
                                                            .format(DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                            userBookings[
                                                            index]
                                                                .timeStamp)),
                                                        style: GoogleFonts
                                                            .robotoMono(
                                                            fontSize: 22,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        'Time',
                                                        style: GoogleFonts
                                                            .robotoMono(),
                                                      ),
                                                      Text(
                                                        TIME_SLOT.elementAt(
                                                            userBookings[index]
                                                                .slot),
                                                        style: GoogleFonts
                                                            .robotoMono(
                                                            fontSize: 22,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Divider(
                                                thickness: 1,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${userBookings[index].salonName}',
                                                        style: GoogleFonts
                                                            .robotoMono(
                                                            fontSize: 20,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      Text(
                                                        '${userBookings[index].stylistName}',
                                                        style: GoogleFonts
                                                            .robotoMono(),
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                    '${userBookings[index].salonAddress}',
                                                    style: GoogleFonts
                                                        .robotoMono(),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }
                        });
                }
              }),)
        ],
      ),
    ));
  }
}
