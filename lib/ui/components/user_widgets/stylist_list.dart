import 'package:beautycon/model/salon_model.dart';
import 'package:beautycon/model/stylist_model.dart';
import 'package:beautycon/string/strings.dart';
import 'package:beautycon/view_model/booking/booking_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

displayStylist(BookingViewModel bookingViewModel, SalonModel salonModel) {
  return FutureBuilder(
      future: bookingViewModel.displayStylistsBySalon(salonModel),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var stylists = snapshot.data as List<StylistModel>;
          if (stylists.length == 0)
            return Center(
              child: Text(stylistEmptyText),
            );
          else
            return ListView.builder(
              key: PageStorageKey('keep'),
                itemCount: stylists.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => bookingViewModel.onSelectedStylist(context, stylists[index]),
                    child: Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        trailing: bookingViewModel.isStylistSelected(context, stylists[index])
                            ? Icon(Icons.check)
                            : null,
                        title: Text(
                          '${stylists[index].name}',
                          style: GoogleFonts.robotoMono(),
                        ),
                        subtitle: RatingBar.builder(
                          itemSize: 16,
                          allowHalfRating: true,
                          initialRating: stylists[index].rating,
                          ignoreGestures: true,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemPadding: const EdgeInsets.all(4),
                          onRatingUpdate: (val) {},
                        ),
                      ),
                    ),
                  );
                });
        }
      });
}