import 'package:ipix/services/api_services.dart';
import 'package:ipix/core/utils/url.dart';

class RestaurantRepo {
  EitherResponse listRestaurants() async =>
      await ApiService.getApi(AppUrl.getRestaurants);
}
