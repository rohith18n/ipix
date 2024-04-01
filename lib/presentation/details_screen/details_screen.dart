// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipix/core/utils/google_maps.dart';
import 'package:ipix/presentation/details_screen/details_controller.dart';
import 'package:ipix/presentation/home_screen/homemodel.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';

class DetailsScreen extends StatefulWidget {
  final Restaurant restaurant;

  DetailsScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  ScrollController _controller = ScrollController();
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewController = Get.put(ReviewController());

    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200.0,
                child: Stack(
                  children: [
                    // Image
                    Visibility(
                      visible: !_isLoading,
                      child: ClipRRect(
                        child: Image.asset(
                          "assets/images/restaurant.jpg",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Shimmer Placeholder
                    Visibility(
                      visible: _isLoading,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 200.0,
                          color: Colors
                              .white, // Match the background color of your image container
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.restaurant.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Text(
                            calculateAverageRating(widget.restaurant.reviews)
                                .toString(),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(width: 5),
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.restaurant.neighborhood,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.restaurant_menu_rounded,
                    size: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      widget.restaurant.cuisineType,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.location_on,
                    size: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      widget.restaurant.address,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.access_time_filled_outlined,
                    size: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: GetBuilder<ReviewController>(
                      builder: (reviewController) => Text(
                        reviewController.showAllDays
                            ? widget.restaurant.operatingHours.entries
                                .map((entry) =>
                                    '${entry.key}: ${entry.value.replaceAll('=>', ':')}')
                                .join('\n')
                            : getOperatingHoursForDay(
                                widget.restaurant, "Monday"),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.0),
                  GestureDetector(
                    onTap: () {
                      reviewController.toggleAllDays();
                    },
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Rating & Reviews",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10),
              GetBuilder<ReviewController>(
                builder: (reviewController) => ListView.separated(
                  controller: _controller,
                  padding: EdgeInsets.all(0),
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey.withOpacity(0.7),
                    height: 1,
                  ),
                  shrinkWrap: true,
                  itemCount: widget.restaurant.reviews.length,
                  itemBuilder: (context, index) {
                    final review = widget.restaurant.reviews[index];
                    final isExpanded =
                        reviewController.reviewExpansionMap[index] ?? false;

                    return Container(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[700],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          review.rating.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.star,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  review.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                              isExpanded
                                  ? review.comments
                                  : (review.comments.length > 170
                                      ? review.comments.substring(0, 170) +
                                          '...'
                                      : review.comments),
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                reviewController.toggleExpansion(index);
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  isExpanded ? 'Read less' : 'Read more',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                    color: Colors.grey,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                review.date,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(28.0),
        child: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          onPressed: () async {
            // await IntentUtils.launchGoogleMaps();
            MapsLauncher.launchCoordinates(widget.restaurant.location.lat,
                widget.restaurant.location.lng, 'Book your restaurant now');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_outlined, color: Colors.white),
              Text("GO", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

calculateAverageRating(List<Review> reviews) {
  if (reviews.isEmpty) return 0.0;

  double sum = 0.0;
  for (var review in reviews) {
    sum += review.rating;
  }

  return (sum / reviews.length).toStringAsFixed(1);
}

String getOperatingHoursForDay(Restaurant restaurant, String day) {
  // Convert the day to title case (e.g., 'monday' -> 'Monday')
  day = day.substring(0, 1).toUpperCase() + day.substring(1).toLowerCase();

  // Find the operating hours for the specified day
  String? operatingHours = restaurant.operatingHours[day];

  // If operating hours exist for the specified day, replace '=>' with ':'
  if (operatingHours != null) {
    return "$day: ${operatingHours.replaceAll('=>', ':')}";
  } else {
    return "Operating hours not available for $day";
  }
}
