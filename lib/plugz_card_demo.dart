library plugz_card_demo;

import 'package:plugz_card_demo/common/card_request_object.dart';
import 'package:plugz_card_demo/common/card_response_object.dart';
import 'package:plugz_card_demo/common/card_transit_object.dart';

/// Plugz Card plugin for NFC and RFID cards.
class PlugzCard {
  //final CardRequestObject cardRequest;

 // PlugzCard({required this.cardRequest});

  /// Execute card Card Operation. CommandType are:
  /// PAYMENT: For initiating payment.
  /// CREDIT: For card top up.
  /// DEBIT: For withdrawal from card.
  /// BALANCE: For getting balance on card.
  Future<CardResponseObject> executeCommand(CardRequestObject cardMsg) async {
    var cardResponse = CardResponseObject(); //initialize the response object.
    try {
      switch (cardMsg.commandType) {
        case 'PAYMENT': //payment command
          var cardReadResult = await _readNfcCard();
          if (cardReadResult.statusCode > 0) {
            //error occured. determine which error based on statusCode
            cardResponse.statusCode = cardReadResult.statusCode;
            cardResponse.message = _getErrorMessage(cardReadResult.statusCode);
            cardResponse.userId = cardMsg.userId;
          } else {
            //success
            double dAmount = cardReadResult.amount;
            String? sCardId = cardReadResult.cardId;
            if (cardMsg.amount! > dAmount) {
              //balance not enough for payment operation
              cardResponse.statusCode = 5;
              cardResponse.amount = cardReadResult.amount;
              cardResponse.cardId = cardReadResult.cardId;
              cardResponse.userId = cardMsg.userId;
              cardResponse.message =
                  '${_getErrorMessage(cardReadResult.statusCode)} Current balance is ${cardReadResult.amount}';
            } else {
              //make deductions and write to card
              var cardTransitMsg = CardTransitMsg();
              cardTransitMsg.amount = dAmount - cardMsg.amount!;
              cardTransitMsg.cardId = sCardId;
              var cardWriteResult = await _writeNfcCard(cardTransitMsg);
              if (cardWriteResult.statusCode > 0) {
                //error. return error message
                cardResponse.statusCode = cardWriteResult.statusCode;
                cardResponse.message =
                    _getErrorMessage(cardWriteResult.statusCode);
                cardResponse.userId = cardMsg.userId;
              } else {
                //success. return standard message';
                cardResponse.statusCode = 0;
                cardResponse.amount = cardWriteResult.amount;
                cardResponse.cardId = cardWriteResult.cardId;
                cardResponse.userId = cardMsg.userId;
                cardResponse.message = cardWriteResult.message;
              }
            }
          }
          break;
        case 'CREDIT': //save to card command
          var cardReadResult = await _readNfcCard();
          if (cardReadResult.statusCode > 0) {
            //error occured. determine which error based on statusCode
            cardResponse.statusCode = cardReadResult.statusCode;
            cardResponse.message = _getErrorMessage(cardReadResult.statusCode);
            cardResponse.userId = cardMsg.userId;
          } else {
            //success
            double dAmount = cardReadResult.amount;
            String? sCardId = cardReadResult.cardId;

            //add the amount to current card balance.
            var cardTransitMsg = CardTransitMsg();
            cardTransitMsg.amount = dAmount + cardMsg.amount!;
            cardTransitMsg.cardId = sCardId;
            var cardWriteResult = await _writeNfcCard(cardTransitMsg);
            if (cardWriteResult.statusCode > 0) {
              //error. return error message
              cardResponse.statusCode = cardWriteResult.statusCode;
              cardResponse.message =
                  _getErrorMessage(cardWriteResult.statusCode);
              cardResponse.userId = cardMsg.userId;
            } else {
              //success. return standard message';
              cardResponse.statusCode = 0;
              cardResponse.amount = cardWriteResult.amount;
              cardResponse.cardId = cardWriteResult.cardId;
              cardResponse.userId = cardMsg.userId;
              cardResponse.message = cardWriteResult.message;
            }
          }
          break;
        case 'DEBIT': //withdrawal from card command
          var cardReadResult = await _readNfcCard();
          if (cardReadResult.statusCode > 0) {
            //error occured. determine which error based on statusCode
            cardResponse.statusCode = cardReadResult.statusCode;
            cardResponse.message = _getErrorMessage(cardReadResult.statusCode);
            cardResponse.userId = cardMsg.userId;
          } else {
            //success
            double dAmount = cardReadResult.amount;
            String? sCardId = cardReadResult.cardId;
            if (cardMsg.amount! > dAmount) {
              //balance not enough for debit operation
              cardResponse.statusCode = 5;
              cardResponse.amount = cardReadResult.amount;
              cardResponse.cardId = cardReadResult.cardId;
              cardResponse.userId = cardMsg.userId;
              cardResponse.message =
                  '${_getErrorMessage(cardReadResult.statusCode)} Current balance is ${cardReadResult.amount}';
            } else {
              //make deductions and write to card
              var cardTransitMsg = CardTransitMsg();
              cardTransitMsg.amount = dAmount - cardMsg.amount!;
              cardTransitMsg.cardId = sCardId;
              var cardWriteResult = await _writeNfcCard(cardTransitMsg);
              if (cardWriteResult.statusCode > 0) {
                //error. return error message
                cardResponse.statusCode = cardWriteResult.statusCode;
                cardResponse.message =
                    _getErrorMessage(cardWriteResult.statusCode);
                cardResponse.userId = cardMsg.userId;
              } else {
                //success. return standard message';
                cardResponse.statusCode = 0;
                cardResponse.amount = cardWriteResult.amount;
                cardResponse.cardId = cardWriteResult.cardId;
                cardResponse.userId = cardMsg.userId;
                cardResponse.message = cardWriteResult.message;
              }
            }
          }
          break;
        case 'BALANCE':
          var cardResult = await _readNfcCard();
          if (cardResult.statusCode > 0) {
            //error occured. determine which error based on statusCode
          } else {
            //success
            cardResponse.statusCode = 0;
            cardResponse.amount = cardResult.amount;
            cardResponse.cardId = cardResult.cardId;
            cardResponse.userId = cardMsg.userId;
            cardResponse.message =
                "Success! Card ID is ${cardResult.cardId}. New balance is ${cardResult.amount}";
          }
          break;
        default:
      }
      return cardResponse;
    } catch (e) {
      cardResponse.message = e.toString();
      //_closeNfcOps(false);
      return cardResponse;
    } finally {
      _closeNfcOps(false);
    }
  }

  
  // Read NFC Card and return result object
  Future<CardTransitMsg> _readNfcCard() async {
    var cardTransitMsg =
        CardTransitMsg(); //initialize the transit response object.
    try {
      cardTransitMsg.cardId = 'DEMO-PLUGZ-001';
      cardTransitMsg.amount = 10000;
      cardTransitMsg.statusCode = 0;

      return cardTransitMsg;
    } catch (e) {
      cardTransitMsg.statusCode = 10;
      return cardTransitMsg;
    } finally {
      //_closeNfcOps(false);
    }
  }

  // Write to NFC Card and return result object
  Future<CardResponseObject> _writeNfcCard(CardTransitMsg cardMsg) async {
    var cardResponse = CardResponseObject(); //initialize the response object.
    try {
      cardResponse.statusCode = 0;
      cardResponse.message =
          "Success! Card ID is DEMO-PLUGZ-001. New balance is ${cardMsg.amount}";
      cardResponse.amount = cardMsg.amount;
      cardResponse.cardId = 'DEMO-PLUGZ-001';
      return cardResponse;
    } catch (e) {
      cardResponse.statusCode = 10;
      cardResponse.message = "Unexpected Error: ${e.toString()}";
      return cardResponse;
    } finally {
      //_closeNfcOps(false);
    }
  }

  // Close NFC Card stream
  void _closeNfcOps(bool status) async {
    return;
  }

  // Translate defined ErrorCodes to Messages
  String _getErrorMessage(int statusCode) {
    switch (statusCode) {
      case -1:
        return "Device in ready state but no operation has started.";
      case 0:
        return "Operation completed successfully.";
      case 1:
        return "NFC operations not supported or enabled on the device.";
      case 2:
        return "Error initializing card for the first time.";
      case 3:
        return "Error reading card content.";
      case 4:
        return "Error writting to card.";
      case 5:
        return "Balance on card not enough for the stated operation.";
      case 6:
        return "Card not yet initialized or activated. No record on card yet.";
      case 7:
        return "This card type is not supported on our platform.";
      case 10:
        return "Unexpected Error.";
      default:
        return "Wrong Status Code.";
    }
  }
}
