import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        headers: {
          'Content-Type': 'application/json'
        }
    ));
  }

  static Future<Response> postData({
    required String endPoint,
    Object? data,
    Object? token,
    String lang = 'en',
  }) async {
    return await dio.post(
      endPoint,
      options: Options(
        headers: {
          'lang' : lang,
          'Authorization': token,
        }
      ),
      data: data,
    );
  }

  static Future<Response> getData({
    required String endPoint,
    Object? token,
    String lang = 'en',
  }) async {
    return await dio.get(
      endPoint,
      options: Options(
        headers: {
          'lang': lang,
          'Authorization': token,
        }
      )
    );
  }

}
