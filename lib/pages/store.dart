import 'package:flutter/material.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Store"),
      ),
      body: GridView.count(
          crossAxisCount: 3,
          children: List.generate(21, (index) {
            return Center(
                child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headlineSmall,
            ));
          })),
    );
  }
}
