import 'package:flutter/material.dart';
import 'package:green_mile_app/core/app_colors.dart';
import 'package:green_mile_app/domain/entities/resource.dart';
import 'package:intl/intl.dart';

class CardResource extends StatelessWidget {
  final Resource resource;
  const CardResource({
    Key? key,
    required this.resource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final updatedAt = resource.updatedAt == null
        ? 'Sem data'
        : DateFormat('dd/MM/yyyy - HH:mm').format(resource.updatedAt!) + 'h';

    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.greenVeryLight,
        ),
        margin: const EdgeInsets.only(bottom: 15),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Id do Recurso:',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(children: [
                Expanded(
                  child: Text(
                    resource.resourceId.trim(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
              const Divider(color: AppColors.white),
              const Text(
                'Valor:',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(children: [
                Expanded(
                  child: Text(
                    resource.value.trim(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
              const Divider(color: AppColors.white),
              Row(
                children: [
                  const Text(
                    'Atualizado em: ',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  Text(updatedAt),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
