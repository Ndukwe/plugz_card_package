class CardTransitMsg {
  String? cardId;
  double amount = 0;
  int statusCode = -1;
  //-1=ready state;
  //0=success;
  //1=NFC operations not supported or enabled
  //2=error initializing card;
  //3=error reading card;
  //4=error writting to card;
  //5=balance not enough;
  //6=NDEF tag not found. No record on card yet;
  //10=unexpected error;
  CardTransitMsg();
}
