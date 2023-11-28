import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/common/widgets/bottom_bar.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/admin/screens/admin_screen.dart';
import 'package:thrift_exchange/features/auth/screens/auth_screen.dart';
import 'package:thrift_exchange/features/auth/services/auth_service.dart';
import 'package:thrift_exchange/providers/user_provider.dart';
import 'package:thrift_exchange/router.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.amber,
  ));
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thrift Exchange',
      theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          colorScheme: const ColorScheme.light(
            primary: Color.fromARGB(255, 255, 226, 7),
          ),
          appBarTheme: const AppBarTheme(
            elevation: 5,
            iconTheme: IconThemeData(color: Colors.black),
          )),
      onGenerateRoute: (settings) => generateRoute(settings),

      // Below checks if we have a user token saved in which case, we skip auth screen
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          // ? Provider.of<UserProvider>(context).user.type == 'user'
          //     ? const BottomBar()
          ? const AdminScreen()
          : const AuthScreen(),
    );
  }
}
