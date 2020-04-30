import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
class ImageDialog extends StatelessWidget{
  String name;
  String description;
  String price;
  String url;
  ImageDialog(this.name, this.description, this.price, this.url);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(

      child: Container(
        width: 400,
        height: 400,
        child: Column(children: <Widget>[
          Flexible(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                    child: new Image.asset('assets/images/not-found.png')),
                imageUrl: url,
                fit: BoxFit.cover,
              )
          ),
          Center(child: Text(name, style: TextStyle(fontFamily: 'Segoe', color: Colors.amber, fontSize: 20),),),
          Text(description),
          Center(child: Text('€'+price, style: TextStyle(fontFamily: 'Segoe', color: Colors.amber, fontSize: 30),),),

        ],),
      ),
    );
  }
}