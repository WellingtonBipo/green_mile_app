import 'package:dio/dio.dart';
import 'package:green_mile_app/infra/datasources/get_resources_datasource.dart';
import 'package:green_mile_app/infra/models/resource_model.dart';

class GreenMileDatasource extends GetResourcesDatasource {
  final Dio _dio;

  GreenMileDatasource(this._dio);

  @override
  Future<List<ResourceModel>> getResources(
      {Function(int, int)? onReceiveProgress}) async {
    final response = await _dio.get(
        'http://portal.greenmilesoftware.com/get_resources_since',
        onReceiveProgress: onReceiveProgress,
        options: Options(receiveTimeout: 20000));
    final list = response.data as List;
    return list
        .map((e) => ResourceModel.fromMap((e as Map)['resource']))
        .toList();
  }
}
