import 'package:flutter_test/flutter_test.dart';
import 'package:green_mile_app/external/get_resources_from_device_impl.dart';
import 'package:green_mile_app/infra/models/resource_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesMock extends Mock implements SharedPreferences {}

const String response =
    '[{"created_at":"2021-08-14T20:49:32Z","updated_at":"2021-08-14T20:49:32Z","resource_id":"textfile.combineOrders","module_id":"GreenMileTrack","value":"Merge orders in the same stop","language_id":"en-g"}]';

void main() {
  final sharedPMock = SharedPreferencesMock();
  test('Deve retornar lista de Resources', () async {
    when(() => sharedPMock.getString(any())).thenReturn(response);

    final result =
        await GetResourcesFromDeviceImpl(sharedPreferences: sharedPMock)
            .getResources();

    expect(result, isA<List<ResourceModel>>());
  });

  test('Deve retornar lista vazia de Resources', () async {
    when(() => sharedPMock.getString(any())).thenReturn(null);

    final result =
        await GetResourcesFromDeviceImpl(sharedPreferences: sharedPMock)
            .getResources();

    expect(result.isEmpty, true);
  });
}
