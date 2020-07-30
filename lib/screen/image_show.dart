
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:marketplace/helper/res.dart';
import 'package:marketplace/helper/utils.dart';
import 'package:marketplace/model/addproduct.dart';
import 'package:photo_view/photo_view.dart';



class ImageShow extends StatefulWidget {
  final int selectedImageIndex;
  final List<ProductPhoto> arrImages;

//  final Products product;

  const ImageShow(
      {Key key, this.selectedImageIndex,this.arrImages})
      : super(key: key);

  @override
  _ImagePageState createState() => _ImagePageState();

  
}

class _ImagePageState extends State<ImageShow> {

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
