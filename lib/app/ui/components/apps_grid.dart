import 'package:flutter/material.dart';
import 'package:launcher1/app/ui/components/apps_item_view.dart';
import 'package:launcher1/app/ui/components/scroll_effect.dart';
import 'package:launcher1/gen/assets.gen.dart';

import '../../../feature/router/domain/app_router.dart';
import '../../di/init_di.dart';

class AppItem {
  final String title;
  final String package;
  final String icon;
  final VoidCallback? action;

  AppItem({
    required this.title,
    required this.package,
    required this.icon,
    this.action,
  });
}

class AppsGrid extends StatefulWidget {
  const AppsGrid({super.key});

  @override
  State<AppsGrid> createState() => _AppsGridState();
}

class _AppsGridState extends State<AppsGrid> {
  final List<AppItem> _apps = [
    AppItem(
      title: 'Телефон',
      package: 'com.android.dialer',
      icon: Assets.images.icCall,
    ),
    AppItem(
      title: 'SMS',
      package: 'com.android.mms',
      icon: Assets.images.icMessage,
    ),
    AppItem(
      title: 'Калькулятор',
      package: 'com.sprd.sprdcalculator',
      icon: Assets.images.icMath,
    ),
    AppItem(
      title: 'Календарь',
      package: 'com.android.calendar',
      icon: Assets.images.icCalendar,
    ),
    AppItem(
      title: 'Настройки',
      package: '',
      icon: Assets.images.icCalendar,
      action: () => locator.get<AppRouter>().replace(const SettingsRoute()),
    )
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Инициализируйте _pageController здесь
  }

  @override
  void dispose() {
    _pageController.dispose(); // Не забудьте уничтожить его
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const crossAxisCount = 2;
    const spacing = crossAxisCount * 6.0;

    // Вычисляем количество страниц
    final pageCount = (_apps.length / (crossAxisCount * 2)).ceil();


    return PageView.builder(
      controller: _pageController,
      itemCount: pageCount,
      itemBuilder: (context, pageIndex) {
        return GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // Количество столбцов
            crossAxisSpacing: spacing, // Расстояние между столбцами
            mainAxisSpacing: spacing, // Расстояние между строками
          ),
          itemCount: crossAxisCount * 2,
          itemBuilder: (context, index) {
            final appIndex = pageIndex * crossAxisCount * 2 + index;
            if (appIndex < _apps.length) {
              return AppsItemView(item: _apps[appIndex], pageController: _pageController, isFirst: appIndex % 4 == 0 ? true : false);
            } else {
              return const SizedBox.shrink(); // Пустой виджет для недостающих элементов
            }
          },
        );
      },
    );
  }
}