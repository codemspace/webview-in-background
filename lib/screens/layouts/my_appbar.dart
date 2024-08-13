import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  MyAppBar({Key? key})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.purple),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/landing');
        },
        child: Text('ally', style: TextStyle(color: Colors.purple, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text('Log In', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
