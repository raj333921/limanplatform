import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Widget buildImageCarousel(List<String> images) {
  return CarouselSlider(
    options: CarouselOptions(
      height: 200,
      autoPlay: true,
      enlargeCenterPage: true,
      autoPlayInterval: Duration(seconds: 10), // change time here
      autoPlayAnimationDuration: Duration(milliseconds: 800), // slide speed
      viewportFraction: 0.9,
    ),
    items: images.map((img) {
      return Builder(
        builder: (context) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(img, fit: BoxFit.cover, width: double.maxFinite),
          );
        },
      );
    }).toList(),
  );
}
