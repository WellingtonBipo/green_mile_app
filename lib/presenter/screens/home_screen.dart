import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:green_mile_app/core/app_colors.dart';

import 'package:green_mile_app/core/consts.dart';
import 'package:green_mile_app/core/extensions.dart';
import 'package:green_mile_app/domain/entities/resource.dart';
import 'package:green_mile_app/domain/usecases/get_resources.dart';
import 'package:green_mile_app/external/get_resources_from_device_impl.dart';
import 'package:green_mile_app/external/green_mile_datasource.dart';
import 'package:green_mile_app/infra/repositories_impl/get_resources_repository_impl.dart';
import 'package:green_mile_app/presenter/widgets/card_resource.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = ScrollController();
  List<Resource> listItems = [];
  List<String> listLanguage = [];
  List<String> listModuleId = [];
  String filterLanguage = 'Nenhum';
  String filterModule = 'Nenhum';
  TextEditingController filterByTextController = TextEditingController();
  String sortItemsBy = Consts.sortItemsRules.keys.first;
  bool isLoading = true;
  bool firstTime = true;
  bool showFilters = false;
  bool showBackTopButton = false;
  int count = 0, total = 1;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _addListenerToShowBackTopButton();
    getResourcesFromDevice(true)
        .then((value) => setState(() => firstTime = false));
  }

  _addListenerToShowBackTopButton() {
    scrollController.addListener(() {
      if (scrollController.position.pixels > 300) {
        if (!showBackTopButton) {
          setState(() => showBackTopButton = true);
        }
      } else {
        if (showBackTopButton) {
          setState(() => showBackTopButton = false);
        }
      }
    });
  }

  Future getResourcesFromDevice(bool fromDevice) async {
    if (!isLoading) setState(() => isLoading = true);

    final result = await GetResources(GetResourcesRepositoryImpl(
            GreenMileDatasource(Dio()), GetResourcesFromDeviceImpl()))
        .call(fromDevice: fromDevice, onReceiveProgress: onReceiveProgress);

    result.fold(
      (l) {
        setState(() => isLoading = false);
        String message =
            'Não soi possível obter a lista de atualizacões.\n${l.message}';

        return ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      },
      (r) {
        setState(() {
          isLoading = false;
          listItems = r;
        });
        return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                '${r.length.toStringHundredsDivider()} items atualizados com sucesso')));
      },
    );

    _setLanguages();
    _setModulesId();
  }

  onReceiveProgress(int count, int total) {
    setState(() {
      this.count = count;
      this.total = total;
    });
  }

  _setLanguages() {
    Set<String> list = {};
    for (var element in listItems) {
      list.add(element.languageId);
    }
    listLanguage = list.toList();
    listLanguage.sort();
    listLanguage.insertAll(0, ['Nenhum']);
  }

  _setModulesId() {
    Set<String> list = {};
    for (var element in listItems) {
      list.add(element.moduleId);
    }
    listModuleId = list.toList();
    listModuleId.sort();
    listModuleId.insertAll(0, ['Nenhum']);
  }

  List<Resource> _filterList() {
    final list = listItems
        .where((element) =>
            (element.languageId == filterLanguage ||
                filterLanguage == 'Nenhum') &&
            (element.moduleId == filterModule || filterModule == 'Nenhum') &&
            _resourceContainFilterText(element))
        .toList();

    Consts.sortItemsRules[sortItemsBy]!(list);
    return list;
  }

  bool _resourceContainFilterText(Resource resource) {
    if (filterByTextController.text == '') return true;
    String text = filterByTextController.text.toLowerCase();
    return resource.value.contains(text);
  }

  @override
  Widget build(BuildContext context) {
    final list = _filterList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.greenDark,
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                onPressed: () {
                  setState(() {
                    showFilters = !showFilters;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: const Icon(Icons.download_rounded),
                  onPressed: () async {
                    if (isLoading) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Aguarde o download terminar')));
                    } else {
                      count = 0;
                      total = 1;
                      await getResourcesFromDevice(false);
                    }
                  },
                ),
              )
            ],
            centerTitle: false,
            title: const Text(
              'Recursos de Tradução',
              style: TextStyle(fontSize: 18),
            )),
        floatingActionButton: !showBackTopButton
            ? null
            : GestureDetector(
                child: const Chip(
                  label: Text(
                    'Voltar ao topo',
                    style: TextStyle(color: AppColors.white),
                  ),
                  backgroundColor: AppColors.greenDark,
                ),
                onTap: () async {
                  await scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 1000),
                      curve: const ElasticInOutCurve(0.2));
                  setState(() => showBackTopButton = false);
                },
              ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              if (listItems.isNotEmpty) ...[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: showFilters ? 200 : 0,
                  child: _filters(),
                ),
                const SizedBox(height: 20),
                _totalItems(list),
                const SizedBox(height: 5),
              ],
              Expanded(
                  child: firstTime
                      ? const SizedBox()
                      : isLoading
                          ? _progress(count / total)
                          : ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              itemCount: list.length,
                              itemBuilder: (_, index) {
                                return CardResource(resource: list[index]);
                              })),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filters() => Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _filterContainText(),
              const SizedBox(height: 5),
              _filterRow(
                  title: 'Idioma',
                  value: filterLanguage,
                  list: listLanguage,
                  onChanged: (text) {
                    setState(() => filterLanguage = text ?? 'Nenhum');
                  }),
              _filterRow(
                  title: 'Módulo',
                  value: filterModule,
                  list: listModuleId,
                  onChanged: (text) {
                    setState(() => filterModule = text ?? 'Nenhum');
                  }),
              _filterRow(
                  title: 'Ordenar por',
                  value: sortItemsBy,
                  list: Consts.sortItemsRules.keys.toList(),
                  onChanged: (text) {
                    setState(() =>
                        sortItemsBy = text ?? Consts.sortItemsRules.keys.first);
                  }),
            ],
          ),
        ),
      );

  Widget _totalItems(List list) => Text(
        '${list.length != listItems.length ? (list.length.toStringHundredsDivider() + ' de ') : ''}${listItems.length.toStringHundredsDivider()} items',
        style: const TextStyle(
            color: AppColors.greenDark, fontWeight: FontWeight.bold),
      );

  Widget _filterContainText() {
    return Row(
      children: [
        const Text(
          'Procurar por valor',
          style: TextStyle(
              color: AppColors.greenDark, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextField(
            controller: filterByTextController,
            decoration: const InputDecoration(
              isDense: true,
            ),
            onChanged: (text) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          child: const Icon(Icons.close),
          onTap: () {
            filterByTextController.clear();
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _filterRow({
    required String title,
    required String? value,
    required List<String> list,
    required Function(String?) onChanged,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              color: AppColors.greenDark, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20),
        DropdownButton<String>(
          value: value,
          items: list
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _progress([double? value]) => SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 70,
                width: 70,
                child: CircularProgressIndicator(value: value)),
            const SizedBox(height: 20),
            if (value != null) ...[
              Text('${(value * 100).toStringAsFixed(2)} %'),
              Text('${(count / 1000000).toStringAsFixed(2)} Mb')
            ]
          ],
        ),
      );
}
