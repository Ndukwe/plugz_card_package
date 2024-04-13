///CommandType {PAYMENT, CREDIT, DEBIT, BALANCE}
///PAYMENT=for make payment operation;
///CREDIT=for top up (wallet to card) operation;
///DEBIT=for withdrawal (card to wallet) operation;
///BALANCE=for checking balance

enum OpCommandType {
  PAYMENT,
  CREDIT,
  DEBIT,
  BALANCE,
  ACTIVATE}

class CardRequestObject {
 // String commandType = 'PAYMENT';
  //OpCommandType commandType=OpCommandType.PAYMENT;
  OpCommandType commandType=OpCommandType.PAYMENT;
  double? amount = 0;
  String userId;
  CardRequestObject({required this.commandType,required this.userId,this.amount});
}
