import 'package:flutter/material.dart';
import 'package:hotel_real_merced/pages/home/widget/hotelimage.dart';
import 'package:hotel_real_merced/pages/home/widget/hotelinfo.dart';

class BuildHotelCard extends StatelessWidget {
  final String title;
  final String location;
  final String imagePath;
  final String rating;
  final String price;
  const BuildHotelCard({
    super.key,
    required this.imagePath,
    required this.location,
    required this.price,
    required this.rating,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hotelimage(imagePath: imagePath),
          Hotelinfo(title: title, location: location, rating: rating, price: price),
        ],
      ),
    );
  }
}
