import 'package:flutter/material.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final List<IconImg> storeImgNames = [IconImg("default.png", "FREE"), IconImg("bangs.png", "5"), IconImg("hat.png", "10"), IconImg("long.png", "20")];
  final bool a = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Store'),
              GestureDetector(
                child: Text('Skulls: 1000'),
              )
            ],
          ),
          centerTitle: false),
      body: GridView.count(
          crossAxisCount: 3,
          children: List.generate(storeImgNames.length, (index) {
            return Card(
              margin: EdgeInsets.all(8),
              elevation: 5,
              shape: storeImgNames[index].isEquipped() ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ) : RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
              child: Stack(
                children: <Widget>[
                  Center(
                child: Image(
                      image: AssetImage("assets/${storeImgNames[index].imgName}"),
                      width: storeImgNames[index].width,
                      fit: BoxFit.cover
                    )),
                  Positioned(
                    bottom: 3,
                    right: 3,
                    child: Container(
                      decoration: const BoxDecoration (
                        color: Color.fromARGB(204, 158, 158, 158),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      padding: EdgeInsets.fromLTRB(0, 0, 2, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.attach_money,
                            size: 25,
                            color: Color(0xFFFFD700),
                          ),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Container(
                              transform: Matrix4.translationValues(-3.0, 0, 0.0),
                              child: Text(
                              storeImgNames[index].priceLabel,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color(0xFFFFD700),
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          })),
    );
  }
}

class IconImg {
  String imgName;
  String priceLabel;
  double width = 100;

  IconImg(this.imgName, this.priceLabel);
  IconImg.sized(this.imgName, this.priceLabel, this.width);

  bool isEquipped(){
    return imgName == "default.png";
  }
}
