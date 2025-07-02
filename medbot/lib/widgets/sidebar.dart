import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final List<IconData> icons;
  final List<String> labels;
  final int selected;
  final bool expanded;
  final Function(int) onTap;
  final VoidCallback onMenu;
  final VoidCallback onHome;

  const SideBar({
    Key? key,
    required this.icons,
    required this.labels,
    required this.selected,
    required this.expanded,
    required this.onTap,
    required this.onMenu,
    required this.onHome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = Colors.grey[900];
    final highlight = Colors.red.shade100;
    final iconCol = Colors.white;

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: expanded ? 180 : 72,
      color: bg,
      child: Column(
        crossAxisAlignment: expanded ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(height: 18),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onHome,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.home_rounded, size: 28, color: Colors.red),
                  if (expanded)
                    SizedBox(width: 10),
                  if (expanded)
                    Expanded(
                      child: Text(
                        "Home",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          IconButton(
            icon: Icon(expanded ? Icons.menu_open : Icons.menu, color: Colors.red),
            tooltip: expanded ? "Collapse" : "Expand",
            onPressed: onMenu,
          ),
          SizedBox(height: 8),
          ...List.generate(icons.length, (i) => InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => onTap(i),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 7, horizontal: 6),
                  decoration: selected == i
                      ? BoxDecoration(
                          color: highlight,
                          borderRadius: BorderRadius.circular(12),
                        )
                      : null,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    children: [
                      Icon(
                        icons[i],
                        size: 28,
                        color: selected == i ? Colors.red : iconCol,
                      ),
                      if (expanded)
                        SizedBox(width: 10),
                      if (expanded)
                        Expanded(
                          child: Text(
                            labels[i],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              color: selected == i ? Colors.red : Colors.white,
                              fontWeight: selected == i ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
