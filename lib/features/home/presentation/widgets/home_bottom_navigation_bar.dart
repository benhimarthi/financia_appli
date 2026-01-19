import 'package:badges/badges.dart' as badges;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
  });
  final Function(int) onItemTapped;
  final int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70,
      color: Colors.white,
      elevation: 10,
      shadowColor: const Color.fromARGB(255, 230, 230, 230),
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomBottomNavigationItem(
            iconData: Icons.home,
            label: 'nav_home'.tr(),
            isSelected: selectedIndex == 0,
            onTap: () => onItemTapped(0),
          ),
          CustomBottomNavigationItem(
            iconData: Icons.wallet,
            label: 'nav_finances'.tr(),
            isSelected: selectedIndex == 1,
            onTap: () => onItemTapped(1),
          ),
          CustomBottomNavigationItem(
            iconData: Icons.add_chart_outlined,
            label: 'nav_plan'.tr(),
            isSelected: selectedIndex == 2,
            onTap: () => onItemTapped(2),
          ),
          CustomBottomNavigationItem(
            iconData: Icons.book_outlined,
            label: 'nav_learn'.tr(),
            isSelected: selectedIndex == 3,
            onTap: () => onItemTapped(3),
          ),
          CustomBottomNavigationItem(
            iconData: Icons.stacked_line_chart_sharp,
            label: 'nav_wealth'.tr(),
            isSelected: selectedIndex == 4,
            onTap: () => onItemTapped(4),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigationItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomBottomNavigationItem({
    super.key,
    required this.iconData,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? const Color.fromARGB(255, 6, 90, 22)
        : const Color.fromARGB(255, 126, 126, 126);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSelected
                ? badges.Badge(
                    badgeStyle: badges.BadgeStyle(
                      badgeColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 2,
                        bottom: 2,
                      ),
                    ),
                    position: badges.BadgePosition.topEnd(top: -6, end: -8),
                    child: Icon(iconData, color: color, size: 28),
                  )
                : Icon(iconData, color: color, size: 28),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
