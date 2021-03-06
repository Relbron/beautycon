import 'package:beautycon/model/city_model.dart';
import 'package:beautycon/state/state_management.dart';
import 'package:beautycon/string/strings.dart';
import 'package:beautycon/view_model/booking/booking_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

displayCityList(BookingViewModel bookingViewModel) {
  return FutureBuilder(
      future: bookingViewModel.displayCities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var cities = snapshot.data as List<CityModel>;
          if (cities.length == 0)
            return Center(
              child: Text(cannotLoadCityText),
            );
          else
            return ListView.builder(
              key: PageStorageKey('keep'),
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => bookingViewModel.onSelectedCity(context, cities[index]),
                    child: Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.home_work,
                          color: Colors.black,
                        ),
                        trailing: bookingViewModel.isCitySelected(context, cities[index])
                            ? Icon(Icons.check)
                            : null,
                        title: Text(
                          '${cities[index].name}',
                          style: GoogleFonts.robotoMono(),
                        ),
                      ),
                    ),
                  );
                });
        }
      });
}