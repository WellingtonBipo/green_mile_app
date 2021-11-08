import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:green_mile_app/external/green_mile_datasource.dart';
import 'package:green_mile_app/infra/models/resource_model.dart';
import 'package:mocktail/mocktail.dart';

class DioMock extends Mock implements Dio {}

main() {
  final dioMock = DioMock();
  test('Deve retornar lista de ResourceModel', () async {
    final result = await GreenMileDatasource(Dio()).getResources();

    expect(result, isA<List<ResourceModel>>());
  });

  test('Deve retornar DioErrorType.response quando problema na requisição',
      () async {
    when(() => dioMock.get(
              any(),
              onReceiveProgress: any(named: 'onReceiveProgress'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
              queryParameters: any(named: 'queryParameters'),
            ))
        .thenAnswer((_) async => throw DioError(
            type: DioErrorType.response,
            requestOptions: RequestOptions(path: '')));

    try {
      await GreenMileDatasource(dioMock).getResources();
    } catch (e) {
      expect(e, isA<DioError>());
      expect((e as DioError).type, equals(DioErrorType.response));
    }
  });
}
