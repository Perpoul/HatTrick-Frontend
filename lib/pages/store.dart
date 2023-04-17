import 'package:flutter/material.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final List<IconImg> storeImgNames = [IconImg("default.png"), IconImg("bangs.png"), IconImg("hat.png"), IconImg("long.png")]; // IconImg("hat.png", 100), 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Store"),
      ),
      body: GridView.count(
          crossAxisCount: 3,
          children: List.generate(storeImgNames.length, (index) {
            return Center(
                child: Image(
                        image: AssetImage("assets/${storeImgNames[index].imgName}"),
                        width: storeImgNames[index].height,
                        fit: BoxFit.cover
                      ));
          })),
    );
  }
}

class IconImg {
  String imgName;
  double height = 100;
  IconImg(this.imgName);
  IconImg.sized(this.imgName, this.height);
}
