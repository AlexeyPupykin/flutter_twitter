import 'package:flutter/material.dart';
import 'package:flutter_twitter/common/app_colors.dart';
import 'package:flutter_twitter/screens/home/screens/navbar/cubit/navbar_cubit.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Map<NavBarItem, IconData> items;
  final NavBarItem selectedItem;
  final Function(int) onTap;

  const CustomBottomNavBar({
    required this.items,
    required this.selectedItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        onTap: onTap,
        backgroundColor: AppColors.darkGreenColor,
        selectedItemColor: AppColors.textMainColor,
        selectedIconTheme: IconThemeData(size: 40),
        unselectedItemColor: Colors.grey,
        currentIndex: NavBarItem.values.indexOf(selectedItem),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: items
            .map((item, icon) {
              return MapEntry(
                item,
                BottomNavigationBarItem(
                  icon: Icon(icon, size: 35.0),
                  label: item.toString(),
                  tooltip: item.toString(),
                ),
              );
            })
            .values
            .toList());
  }
}
