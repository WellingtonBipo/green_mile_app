import 'package:green_mile_app/infra/models/resource_model.dart';

abstract class GetResourcesFromDevice {
  Future<List<ResourceModel>> getResources();
  Future<bool> setResources(List<ResourceModel> resources);
}
