import 'package:flutter/material.dart';
import 'package:ipix/presentation/details_screen/details_screen.dart';
import 'package:ipix/presentation/home_screen/homemodel.dart';
import 'package:shimmer/shimmer.dart';

class RedtsurantTileWidget extends StatefulWidget {
  final Restaurant restaurant;
  RedtsurantTileWidget(this.restaurant);

  @override
  State<RedtsurantTileWidget> createState() => _RedtsurantTileWidgetState();
}

class _RedtsurantTileWidgetState extends State<RedtsurantTileWidget> {
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    gotoCategoryList() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsScreen(
                    restaurant: widget.restaurant,
                  )));
    }

    return GestureDetector(
      onTap: () => gotoCategoryList(),
      child: Container(
        padding: EdgeInsets.fromLTRB(2.0, 5.0, 2.0, 0.0),
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
            SizedBox(
              height: 10,
            ),
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
                        color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
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
                        SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  Icons.restaurant_menu_rounded,
                  size: 14,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    widget.restaurant.cuisineType,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.0,
                ),
                Icon(
                  Icons.location_on,
                  size: 14,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    widget.restaurant.address,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
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
