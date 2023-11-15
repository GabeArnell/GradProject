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
  const ProfilePage({super.key});

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

  void selectImages() async {
    var res = await pickProfileImages();
    setState(() {
      image = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    String imageUrl =
        "https://images.unsplash.com/photo-1497551060073-4c5ab6435f12?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60";

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
                    imageUrl,
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
                                      },
                                    ),
                                    Padding(padding: EdgeInsets.all(8.0)),
                                    GestureDetector(
                                      child: Text('Choose from gallery'),
                                      onTap: () async {
                                        selectImages();
                                        updateService.updateProfilePicture(
                                          context: context,
                                          image: image,
                                          onSuccess: (imageUrlp) {
                                            setState(() {
                                              imageUrl = imageUrlp;
                                            });
                                          },
                                        );
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
