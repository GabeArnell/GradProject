import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/features/account/services/update_services.dart';
import 'package:thrift_exchange/features/account/widgets/update_details.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/show-profile';
  ProfilePage({super.key});

  String currentURL = "";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String activeField = '';
  File? image;
  UpdateService updateService = UpdateService();
  void _setActiveField(String field) {
    setState(() {
      activeField = field;
    });
  }

  Future<File?> selectImages() async {
    var res = await pickProfileImages();
    setState(() {
      image = res;
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    widget.currentURL = user.image;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(67),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(
              top: 6,
            ),
            child: const Text(
              'Profile Details',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              '${user.name}',
              style: TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              '${user.email}',
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: Stack(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.currentURL,
                  ),
                  radius: 39,
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Container(
                    width: 33.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 21,
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Choose a profile picture'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Text('Take a picture'),
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        final pickedFile =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.camera,
                                          maxHeight: 480,
                                          maxWidth: 640,
                                        );
                                        if (pickedFile != null){
                                          final String pickedPath = pickedFile.path;
                                          // ignore: use_build_context_synchronously
                                        // ignore: use_build_context_synchronously
                                        String finalResult = await updateService.updateProfilePicture(context: context,token:user.token, image: File(pickedPath));
                                        if (finalResult != ''){
                                          user.image = finalResult;
                                          widget.currentURL = finalResult;
                                        }

                                        setState(() {
                                          
                                        });
                                        }else{
                                          print("No file chosen");
                                        }


                                      },
                                    ),
                                    Padding(padding: EdgeInsets.all(8.0)),
                                    GestureDetector(
                                      child: Text('Choose from gallery'),
                                      onTap: () async {
                                        await selectImages();
                                        if (image != null){
                                            String finalResult = await updateService.updateProfilePicture(
                                            context: context,
                                            token:user.token,
                                            image: image!,
                                          );
                                          if (finalResult != ''){
                                            user.image = finalResult;
                                            widget.currentURL = finalResult;
                                          }

                                          setState(() {
                                            
                                          });
                                        }else{
                                          print("IMAGE IS NULL");
                                        }

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Username"),
            subtitle: Text('${user.name}'),
            trailing: Icon(Icons.edit),
            onTap: () {
              setState(() {
                activeField = 'username';
              });
            },
          ),
          if (activeField == 'username')
            UpdateDetails(
                type: 'username',
                onSubmitted: () {
                  _setActiveField('');
                }),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("Email"),
            subtitle: Text('${user.email}'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.password),
            title: Text("Password"),
            subtitle: Text('**********'),
            trailing: Icon(Icons.edit),
            onTap: () {
              setState(() {
                activeField = 'password';
              });
            },
          ),
          if (activeField == 'password')
            UpdateDetails(
                type: 'password',
                onSubmitted: () {
                  _setActiveField('');
                }),
          ListTile(
            leading: Icon(Icons.location_city),
            title: Text("Address"),
            subtitle: Text('${user.address}'),
            trailing: Icon(Icons.edit),
            onTap: () {
              setState(() {
                activeField = 'address';
              });
            },
          ),
          if (activeField == 'address')
            UpdateDetails(
                type: 'address',
                onSubmitted: () {
                  _setActiveField('');
                }),
        ],
      ),
    );
  }
}
