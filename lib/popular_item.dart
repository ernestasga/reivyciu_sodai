import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './image_dialog.dart';
class PopularItem extends StatelessWidget{
  final String name;
  final String price;
  final String description;
  final String imageURL;

  const PopularItem(this.name, this.price, this.description, this.imageURL);



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new InkWell(
      onTap: () {
        showDialog(context: context, builder: (_) => ImageDialog(name, description, price, imageURL));
      },
      child: Container(
        width: 220,
        height: 300,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Container(
                        child: new Image.asset('assets/images/not-found.png')),
                    imageUrl: imageURL,
                    fit: BoxFit.cover,
                    width: 220,
                    height: 300,

                  ),
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(name, style: TextStyle(fontSize: 28, fontFamily: 'Segoe', color: Colors.amber)),
                        Text("€"+price, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.amber)),
                      ],
                    ),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }

}