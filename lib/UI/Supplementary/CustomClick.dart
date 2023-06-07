class CheckClick{
  DateTime? loginClickTime;

  bool isRedundentClick(DateTime currentTime){
    if(loginClickTime == null){
      loginClickTime = currentTime;
      return false;
    }
    if(currentTime.difference(loginClickTime!).inSeconds<1){//set this difference time in seconds
      return true;
    }

    loginClickTime = currentTime;
    return false;
  }
}