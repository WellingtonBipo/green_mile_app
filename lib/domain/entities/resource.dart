abstract class Resource {
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String resourceId;
  final String moduleId;
  final String value;
  final String languageId;

  Resource({
    required this.createdAt,
    required this.updatedAt,
    required this.resourceId,
    required this.moduleId,
    required this.value,
    required this.languageId,
  });
}
