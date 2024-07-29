import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  @override
  Widget build(BuildContext context) {
    User? user = ModalRoute.of(context)!.settings.arguments as User?;
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          SizedBox(height: 20,),
          CircleAvatar(
            radius: 50,
            backgroundImage:
                (user?.photoURL != null) ? NetworkImage(user!.photoURL!) : null,
            child: (user?.photoURL == null)
                ? Text(
                    user!.email![0].toUpperCase(),
                    style: TextStyle(fontSize: 40),
                  )
                : null,
          ),
          SizedBox(height: 10,),
          Text("${user?.email}"),
        ],
      ),
    ));
  }
}
