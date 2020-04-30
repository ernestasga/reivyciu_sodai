import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import './constants.dart';
class BottomNav extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomNavigationBar(
      elevation: 25,
      backgroundColor: Colors.transparent,
      onTap: (int index){
        if(index==0){
          _launchURL('tel:'+Constants().tel);
        } else if(index==1){
          _launchURL('https://www.google.com/maps/search/${Uri.encodeFull(Constants().address)}');
        } else if(index==2){
          _launchURL(Constants().website);
        }

      },
      items: [
        BottomNavigationBarItem(
            icon: new Icon(Icons.phone), title: Text('Tel'), ),
        BottomNavigationBarItem(
            icon: new Icon(Icons.location_on), title: Text('Adresas')),
        BottomNavigationBarItem(
            icon: new Icon(Icons.web), title: Text('Facebook'))
      ],
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}