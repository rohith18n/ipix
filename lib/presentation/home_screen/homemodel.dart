class Restaurant {
  final int id;
  final String name;
  final String neighborhood;
  final String photograph;
  final String address;
  final Location location;
  final String cuisineType;
  final Map<String, String> operatingHours;
  final List<Review> reviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.neighborhood,
    required this.photograph,
    required this.address,
    required this.location,
    required this.cuisineType,
    required this.operatingHours,
    required this.reviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    List<Review> reviewsList = [];
    if (json['reviews'] != null) {
      json['reviews'].forEach((review) {
        reviewsList.add(Review.fromJson(review));
      });
    }
    return Restaurant(
      id: json['id'],
      name: json['name'],
      neighborhood: json['neighborhood'],
      photograph: json['photograph'],
      address: json['address'],
      location: Location.fromJson(json['latlng']),
      cuisineType: json['cuisine_type'],
      operatingHours: Map<String, String>.from(json['operating_hours']),
      reviews: reviewsList,
    );
  }
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class Review {
  final String name;
  final String date;
  final int rating;
  final String comments;

  Review({
    required this.name,
    required this.date,
    required this.rating,
    required this.comments,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      name: json['name'],
      date: json['date'],
      rating: json['rating'],
      comments: json['comments'],
    );
  }
}
