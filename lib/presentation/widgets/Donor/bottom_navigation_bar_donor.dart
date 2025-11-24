import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/presentation/screens/Donor/BottomNavigationBarDonor/chats_screen.dart';
import 'package:giver_receiver/presentation/screens/Donor/BottomNavigationBarDonor/my_items_screen/my_items_screen..dart';
import 'package:giver_receiver/presentation/screens/Donor/BottomNavigationBarDonor/settings_screen..dart';
import 'package:giver_receiver/presentation/screens/Donor/BottomNavigationBarDonor/items_screen.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';

class MainBottomNavDonor extends StatefulWidget {
  const MainBottomNavDonor({super.key});

  @override
  State<MainBottomNavDonor> createState() => _MainBottomNavDonorState();
}

class _MainBottomNavDonorState extends State<MainBottomNavDonor>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    ItemsScreen(),
    MyItemsScreen(),
    ChatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: 'Items',
        labels: const ["Items", "My Items", "Chats", "Settings"],
        icons: const [
          Icons.description_outlined,
          Icons.description_outlined,
          Icons.chat_outlined,
          Icons.settings_outlined,
        ],
        tabIconColor: Colors.grey,
        tabIconSelectedColor: Colors.white,
        tabSelectedColor: AppColors().primaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        onTabItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
