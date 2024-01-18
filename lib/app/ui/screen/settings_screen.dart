import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  static const String path = '/settings';

  const SettingsScreen({super.key});



  @override
  State<SettingsScreen> createState() => _SettingsScreenState();


}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.red);
  }
}