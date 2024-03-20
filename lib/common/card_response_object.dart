///JSON reponse object. The Status Code are enumerated below.
///-1 = Device in ready state but no operation has started;
///0 = Operation completed successfully;
///1 = NFC operations not supported or enabled on the device
///2 = Error initializing card for the first time;
///3 = Error reading card content;
///4 = Error writting to card;
///5 = Balance on card not enough for the stated operation;
///6 = Card not yet initialized or activated. No record on card yet;
///7 = This card type is not supported on our platform;
///10 = An unexpected error;
final class CardResponseObject {
  int statusCode = -1;
  String message = "Error";
  String? cardId;
  double amount = 0;
  String? userId;
  CardResponseObject();
}
