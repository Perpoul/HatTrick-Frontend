import 'package:flutter/material.dart';
import 'package:hat_trick/pages/profile.dart';
import 'package:provider/provider.dart';

class Store extends StatefulWidget {
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final List<HatType> storeImgNames = [
    HatType.defaultHat,
    HatType.short,
    HatType.bangs,
    HatType.long,
    HatType.dimmehat,
    HatType.hat,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Store'),
              Consumer<PlayerModel> (
                builder: (context, player, child) =>
                    GestureDetector(
                      child: Text('Skulls: ${player.skulls}'),
                    )
              )
            ],
          ),
          centerTitle: false),
      body: GridView.count(
          crossAxisCount: 3,
          children: List.generate(storeImgNames.length, (index) {
            return Card(
              margin: const EdgeInsets.all(8),
              elevation: 5,
              shape: Provider.of<PlayerModel>(context).equippedHat == storeImgNames[index] ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: const BorderSide(
                  color: Colors.black,
                  width: 2.0,
                ),
              ) : RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
              child: GestureDetector(
                child: Stack(
                children: <Widget>[
                  Center(
                child: Image(
                      image: AssetImage(storeImgNames[index].path),
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
                                Provider.of<PlayerModel>(context).ownedHats.contains(storeImgNames[index])
                                    ? "Owned"
                                    : storeImgNames[index].cost.toString(),
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
              onTap: () {
                Provider.of<PlayerModel>(context, listen: false)
                    .buyIfNotOwned(storeImgNames[index])
                ;
                }
              ),
            );
          })),
    );
  }
}


class PurchaseResponse{

  Future<int> newCurrencyValue(){
    return Future.value(1);
  }
}
