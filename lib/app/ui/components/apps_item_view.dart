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

  const AppsItemView({super.key, required this.item});

  @override
  State<AppsItemView> createState() => _AppsItemViewState();
}

class _AppsItemViewState extends State<AppsItemView> {
  final colorMain = Colors.white;
  bool _isSelected = false;

  final FocusNode _focusNode = FocusNode();

  Timer? _holdTimer;
  final Duration _holdDuration =
      const Duration(seconds: 8); // Длительность долгого нажатия

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.digit6) {
        if (_holdTimer == null || !_holdTimer!.isActive) {
          _holdTimer = Timer(Duration(seconds: 8), () {
            locator
                    .get<AppRouter>()
                    .replace(AllAppsMenuRoute(onlyUserApps: false));
          });
        }
      }
    } else if (event is RawKeyUpEvent) {
      _holdTimer?.cancel();
    }

    if (event.logicalKey == LogicalKeyboardKey.select) {
      final pn = widget.item.package;
      _openApp(pn);
    }

    
  }

  Future<void> _openApp(String pn) async {
    if (await DeviceApps.isAppInstalled(pn)) {
      await DeviceApps.openApp(pn);
    }
  }

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() => _isSelected = _focusNode.hasFocus);
    });
    super.initState();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
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