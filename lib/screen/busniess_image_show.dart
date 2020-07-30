
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/model/addproduct.dart';
import 'package:marketplace/model/business_user.dart';
import 'package:photo_view/photo_view.dart';



class BussinessImageShow extends StatefulWidget {
  final int selectedImageIndex;
  final List<PhotosBusiness> arrImages;

//  final Products product;

  const BussinessImageShow(
      {Key key, this.selectedImageIndex,this.arrImages})
      : super(key: key);

  @override
  _BussinessImagePageState createState() => _BussinessImagePageState();

  
}

class _BussinessImagePageState extends State<BussinessImageShow> {

 final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: ColorRes.white),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        title: Text(""),
       
      ),
      body: Form(
        key: _formKey,
        
        child: InkResponse(
          child:
            
              firstCarouselView(),
             
           
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
     
    );
  }

  Widget firstCarouselView() {
    return Container(
        height: Utils.getDeviceHeight(context),
        color: ColorRes.black,
       
        child: 
        Align(
                  alignment: Alignment.center,
        
      child:  Stack(
          children: <Widget>[
            
                Container(
                    width: Utils.getDeviceWidth(context),
                      height: Utils.getDeviceHeight(context),
                    color: ColorRes.black,
                  
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return  
                       PhotoView(
      imageProvider:widget.arrImages[index]
                                            .photo
                                            .contains("http")
                                        ? new NetworkImage(widget.arrImages[index].photo): FileImage(File(widget.arrImages[index].photo))
                               );
                           
                      },
                      index: widget.selectedImageIndex,
                  
                      onIndexChanged: (i) {
                       
                      },
                      autoplay: false,
                      itemCount: widget.arrImages.length,
                     
                      control: new SwiperControl(),
                      loop: false,
                      onTap: (i){
                       
                    
                      },
                    ),
                  )
      


//            rightSideIcon(),
          ],
        )));
  }
}
