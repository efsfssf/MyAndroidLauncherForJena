import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launcher1/app/di/init_di.dart';
import 'package:launcher1/app/ui/components/apps_grid.dart';
import 'package:launcher1/feature/router/domain/app_router.dart';

class AppsItemView extends StatefulWidget {
  final AppItem item;
  final PageController pageController;
  final bool isFirst;

  const AppsItemView({super.key, required this.item, required this.pageController, this.isFirst = false});

  @override
  State<AppsItemView> createState() => _AppsItemViewState();
}

class _AppsItemViewState extends State<AppsItemView> {


  final colorMain = Colors.white;
  bool _isSelected = false;

  final FocusNode _focusNode = FocusNode();

  Timer? _holdTimer;
  final Duration _holdDuration =
      const Duration(seconds: 1); // Длительность долгого нажатия


  int _currentIndex = 1;
  //List<FocusNode> _focusNodes = List.generate(2, (index) => FocusNode());
  void _handleKeyPress(RawKeyEvent event) {

    if (event.runtimeType != RawKeyDownEvent) return;

    // Делаем переход на следующюю страницу
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      _currentIndex++; // В счётчике меняем текущюю страницу

      if (_currentIndex == 3) {
        widget.pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut).then((_) {
          // Здесь устанавливаем фокус на первый элемент новой страницы
          //FocusScope.of(context).requestFocus(_focusNodes[2]);
        });
        _currentIndex = 1;
      }

      /*if (!widget.pageController.hasClients || widget.pageController.page == widget.pageController.initialPage) {
        // Если мы находимся на первой странице, переходим на следующую
        widget.pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
      }*/
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) { // Делаем переход на предыдущюю страницу
      // В счётчике меняем текущюю страницу
      _currentIndex--;

      if (_currentIndex == 0) {
        widget.pageController.previousPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut); // переход
        _currentIndex = 2;
      }

      /*if (!widget.pageController.hasClients || widget.pageController.page == widget.pageController.initialPage) {
        // Если мы находимся на последней странице, переходим на предыдущую
        widget.pageController.previousPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
      }*/
    }






    if (event.runtimeType != RawKeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.select || event.logicalKey == LogicalKeyboardKey.enter) {
      final pn = widget.item.package;
      if (pn == "") {
        locator.get<AppRouter>().replace(const SettingsRoute());
      } else {
        _openApp(pn);
      }
    }

    if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
      final num2 = event.logicalKey == LogicalKeyboardKey.digit2;
      final num9 = event.logicalKey == LogicalKeyboardKey.digit9;

      if (num2 || num9) {
        if (_holdTimer == null || !_holdTimer!.isActive) {
          // Запуск таймера при нажатии клавиши
          _holdTimer = Timer(_holdDuration, () {
            // Действие при долгом нажатии
            if (num2) {
              locator
                  .get<AppRouter>()
                  .replace(AllAppsMenuRoute(onlyUserApps: false));
            } else if (num9) {
              locator
                  .get<AppRouter>()
                  .replace(AllAppsMenuRoute(onlyUserApps: true));
            }
          });
        }
      } else if (event is RawKeyUpEvent) {
        // Отмена таймера при отпускании клавиши
        _holdTimer?.cancel();
      }
    }
  }

  Future<void> _openApp(String pn) async {
    if (await DeviceApps.isAppInstalled(pn)) {
      await DeviceApps.openApp(pn);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() => _isSelected = _focusNode.hasFocus);
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isFirst) {
        _focusNode.requestFocus();
      }
    });



  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKey: _handleKeyPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isSelected ? Colors.blue.shade100 : Colors.transparent,
            style: BorderStyle.solid,
            width: 3.0,
          ),
          color: _isSelected ? Colors.white10 : Colors.transparent,
          borderRadius: BorderRadius.circular(32.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Expanded(
              flex: 3,
              child: SvgPicture.asset(
                widget.item.icon,
                width: 999,
                colorFilter: ColorFilter.mode(
                  colorMain,
                  BlendMode.srcATop,
                ),
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  widget.item.title,
                  style: TextStyle(
                    color: colorMain,
                    fontSize: 60.0,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
