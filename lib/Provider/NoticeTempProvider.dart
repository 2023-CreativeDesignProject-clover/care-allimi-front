import 'package:flutter/material.dart';

class NoticeTempProvider with ChangeNotifier {
  bool isImportant = false;
  String selectedTag = '공지사항';

  void setIsImportant(bool important) {
    this.isImportant = important;
    notifyListeners();
  }

  void setSelectedTag(String tag) {
    this.selectedTag = tag;
    notifyListeners();
  }

  String getSelectedTag() {
    return selectedTag;
  }
}

