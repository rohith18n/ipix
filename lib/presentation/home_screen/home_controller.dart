import 'dart:developer' as dev;
import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:ipix/presentation/home_screen/homemodel.dart';
import 'package:ipix/repositories/restaurants_repo.dart';
import 'package:ipix/widgets/snackbar_messenger.dart';

class RecommentedController extends GetxController {
  List<Restaurant> restaurants = [];

  final showLoading = false.obs;

  @override
  onInit() {
    super.onInit();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    showLoading.value = true;

    final either = RestaurantRepo().listRestaurants();
    either.fold(
      (error) {
        dev.log("error fetching restaurants $error");
        Get.showSnackbar(getxSnackbar(message: error.message, isError: true));
        showLoading.value = false;
      },
      (response) async {
        dev.log("fetching restaurants");
        // Map each element of response['data'] to InterestArea and assign to interestedAreas
        restaurants = List<Restaurant>.from(response['restaurants']
            .map((dynamic item) => Restaurant.fromJson(item)));

        dev.log(restaurants[0].operatingHours.toString());

        showLoading.value = false;

        update();
      },
    );
  }
}
