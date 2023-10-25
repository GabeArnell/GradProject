import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
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
  void _setActiveField(String field) {
    setState(() {
      activeField = field;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
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
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1497551060073-4c5ab6435f12?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"),
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
