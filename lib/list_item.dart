import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';

import './image_dialog.dart';
class ListItem extends StatelessWidget {
  String name;
  String description;
  String price;
  String imageURL;

  ListItem(this.name, this.price, this.description, this.imageURL);
  chechConnectivity() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("Connected to Mobile Network");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Connected to WiFi");
    } else {
      print("Unable to connect. Please Check Internet Connection");
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 80,
      child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Card(
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          showDialog(context: context, builder: (_) => ImageDialog(name, description, price, imageURL));
                        },
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              CachedNetworkImage(
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Container(
                                    child: new Image.asset('assets/images/not-found.png')),
                                imageUrl: imageURL,
                                width: 100,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.amber),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(description),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                '€' + price,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ))),
    );
  }

}
