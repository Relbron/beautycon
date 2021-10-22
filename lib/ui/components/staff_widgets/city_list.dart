import 'package:beautycon/model/city_model.dart';
import 'package:beautycon/state/state_management.dart';
import 'package:beautycon/string/strings.dart';
import 'package:beautycon/view_model/staff_home/staff_home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

staffDisplayCity(StaffHomeViewModel staffHomeViewModel) {
  return FutureBuilder(
      future: staffHomeViewModel.displayCities(),
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
            return GridView.builder(
                itemCount: cities.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () =>
                    staffHomeViewModel.onSelectedCity(context, cities[index]),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        shape: staffHomeViewModel.isCitySelected(context, cities[index])
                            ? RoundedRectangleBorder(
                            side:
                            BorderSide(color: Colors.green, width: 4),
                            borderRadius: BorderRadius.circular(5))
                            : null,
                        child: Center(
                          child: Text('${cities[index].name}'),
                        ),
                      ),
                    ),
                  );
                });
        }
      });
}