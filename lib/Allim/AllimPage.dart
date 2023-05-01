import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_data/Allim/ManagerAllimPage.dart';
import 'package:test_data/Allim/UserAllimPage.dart';
import 'package:test_data/provider/UserProvider.dart';
import '/Allim/WriteAllimPage.dart';
import '/Supplementary/PageRouteWithAnimation.dart';
import 'ManagerSecondAllimPage.dart';
import '/NoticeModel.dart';

class AllimPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AllimPageState();
  }
}

class AllimPageState extends State<AllimPage>{

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {

        if (userProvider.urole == 'PROTECTER')
          return UserAllimPage();
        else
          return ManagerAllimPage();
      }
    );
  }
}