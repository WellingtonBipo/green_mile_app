import 'package:green_mile_app/domain/entities/resource.dart';
import 'package:green_mile_app/core/extensions.dart';

class ResourceModel extends Resource {
  ResourceModel._({
    required DateTime? createdAt,
    required DateTime? updatedAt,
    required String resourceId,
    required String moduleId,
    required String value,
    required String languageId,
  }) : super(
          createdAt: createdAt,
          updatedAt: updatedAt,
          resourceId: resourceId,
          moduleId: moduleId,
          value: value,
          languageId: languageId,
        );

  factory ResourceModel.fromMap(Map map) {
    return ResourceModel._(
      createdAt: map.doIfNotNull('created_at', (e) => DateTime.tryParse(e)),
      updatedAt: map.doIfNotNull('updated_at', (e) => DateTime.tryParse(e)),
      resourceId: map['resource_id'],
      moduleId: map['module_id'],
      value: map['value'],
      languageId: map['language_id'],
    );
  }

  Map toMap() => {
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'resource_id': resourceId,
        'module_id': moduleId,
        'value': value,
        'language_id': languageId,
      };
}
