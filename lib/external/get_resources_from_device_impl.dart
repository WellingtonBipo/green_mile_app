import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:green_mile_app/infra/datasources/get_resources_from_device.dart';
import 'package:green_mile_app/infra/models/resource_model.dart';

class GetResourcesFromDeviceImpl extends GetResourcesFromDevice {
  SharedPreferences? _sharedPreferences;
  GetResourcesFromDeviceImpl({
    SharedPreferences? sharedPreferences,
  }) {
    _sharedPreferences = sharedPreferences;
  }

  static const String kResources = 'resources';

  @override
  Future<List<ResourceModel>> getResources() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    final response = _sharedPreferences!.getString(kResources);
    if (response == null) return [];
    final decoded = jsonDecode(response) as List;
    return decoded.map((e) => ResourceModel.fromMap(e)).toList();
  }

  @override
  Future<bool> setResources(List<ResourceModel> resources) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    final listMap = resources.map((e) => e.toMap()).toList();
    return await _sharedPreferences!.setString(kResources, jsonEncode(listMap));
  }
}
