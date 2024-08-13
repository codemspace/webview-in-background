import 'package:flutter/material.dart';

class TopMenu extends StatefulWidget {
  final List<Map<String, dynamic>> menuItems;

  TopMenu({required this.menuItems});

  @override
  _TopMenuState createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> {
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        right: 20,
        top: 80,
        width: size.width / 2,
        child: Material(
          elevation: 4.0,
          child: Column(
            children: widget.menuItems.map((item) {
              return ExpansionTile(
                title: Text(item['title']),
                children: item['children']
                    .map<Widget>((subItem) => ListTile(
                          title: Text(subItem['title']),
                          onTap: () {
                            Navigator.of(context).pop();
                            subItem['action']();
                          },
                        ))
                    .toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_drop_down_circle),
      onPressed: () {
        if (_overlayEntry == null) {
          _showOverlay(context);
        } else {
          _hideOverlay();
        }
      },
    );
  }
}