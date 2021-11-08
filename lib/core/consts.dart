import 'package:green_mile_app/domain/entities/resource.dart';

abstract class Consts {
  static Map<String, void Function(List<Resource>)> sortItemsRules = {
    'Ultimas atualizações': (list) {
      list.sort((b, a) {
        if (a.updatedAt == null || b.updatedAt == null) return 0;
        return a.updatedAt!.compareTo(b.updatedAt!);
      });
    },
    'Primeiras atualizações': (list) {
      list.sort((a, b) {
        if (a.updatedAt == null || b.updatedAt == null) return 0;
        return a.updatedAt!.compareTo(b.updatedAt!);
      });
    },
    'Id do recurso (A-Z)': (list) {
      list.sort((a, b) {
        return a.resourceId.compareTo(b.resourceId);
      });
    },
    'Id do recurso (Z-A)': (list) {
      list.sort((b, a) {
        return a.resourceId.compareTo(b.resourceId);
      });
    },
  };
}
