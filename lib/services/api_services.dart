import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import 'package:ipix/core/utils/app_exceptions.dart';

typedef EitherResponse<T> = Future<Either<AppException, T>>;

class ApiService {
  static final _headers = {'Content-Type': 'application/json'};



  static EitherResponse getApi(String url, [String? token]) async {
    final uri = Uri.parse(url);
    if (token != null) {
      _headers['x-access-token'] = token;
    }
    dynamic fetchedData;
    try {
      final response = await http.get(uri, headers: _headers);
      // fetchedData = _getResponse(response);
      fetchedData = jsonDecode(response.body);
    } on SocketException {
      return Left(InternetException());
    } on http.ClientException {
      return Left(RequestTimeOUtException());
    } catch (e) {
      return Left(BadRequestException());
    }
    return Right(fetchedData);
  }

 

  // static dynamic _getResponse(http.Response response) {
  //   switch (response.statusCode) {
  //     case 200:
  //       return (jsonDecode(response.body));
  //     case 400:
  //       throw BadRequestException();
  //     default:
  //       throw BadRequestException();
  //   }
  // }
}
