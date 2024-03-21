///CommandType {PAYMENT, CREDIT, DEBIT, BALANCE}
///PAYMENT=for make payment operation;
///CREDIT=for top up (wallet to card) operation;
///DEBIT=for withdrawal (card to wallet) operation;
///BALANCE=for checking balance
class CardRequestObject {
  String commandType = 'PAYMENT';
  double? amount = 0;
  String userId;
  CardRequestObject({required this.commandType,required this.userId,this.amount});
}
