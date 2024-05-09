import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rice_leaf_disease_detection_flutter/app_colors.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:rice_leaf_disease_detection_flutter/controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  File? _selectedImage;
  UploadController uploadController = Get.find<UploadController>();

  String? leafClass;
  String? confidence;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
          setState(() {
            _selectedImage = File(pickedImage.path);
          });
          EasyLoading.show(status: 'Predicting...');
          uploadController.uploadImage(_selectedImage!.path).then((value){
            if(value.isSuccess){
              EasyLoading.dismiss();
              setState(() {
                leafClass = uploadController.leafClass;
                confidence = uploadController.confidence;
              });
            }
          });


      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 20, bottom: 10, right: 20),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 5,
                      offset: Offset(0, 0),
                      color: Colors.grey.withOpacity(0.2)
                    )
                  ]
                ),
                width: double.infinity,
                child: Center(
                  child: Text('RiceLeafDoctor',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              _selectedImage == null ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                      color: Colors.grey.withOpacity(0.2)
                    )
                  ]
                ),

                padding: EdgeInsets.only(top: 10, left: 20, bottom: 10, right: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        _pickImage(ImageSource.gallery);
                        },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/icons/image_upload.png', width: 50,),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Gallery'),
                                  Text('Upload image from gallery'),
                                ],
                              ),
                            ],
                          ),
                          Icon(Icons.add)
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2,
                    ),

                    GestureDetector(
                      onTap: (){
                        _pickImage(ImageSource.camera);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/icons/camera.png', width: 50,),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Camera'),
                                  Text('Take a photo'),
                                ],
                              ),
                            ],
                          ),
                          Icon(Icons.add)
                        ],
                      ),
                    ),
                  ],
                )
              )
                  : Container(
                child: Image.file(_selectedImage!, width: 250,),
              ),
              SizedBox(height: 10,),
              leafClass == null ? Container() :
              GestureDetector(
                onTap: (){
                  setState(() {
                    _selectedImage = null;
                    leafClass = null;
                    confidence = null;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(0, 0),
                        color: Colors.white.withOpacity(0.2)
                      )
                    ]
                  ),
                  child: Center(
                    child: Text('Predict Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              leafClass == null ? Container() : Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: Offset(0, 0),
                          color: Colors.grey.withOpacity(0.2)
                      )
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Class: ',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                        Text(leafClass == null ? '' : leafClass!,
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Confidence: ',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                        Text(confidence == null ? '' : '${(double.parse(confidence!) * 100).toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
