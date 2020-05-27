export 'account.dart';

class Proposal {
  String proposalId;
  String ballotName;
  String proposer;
  double amountRequested;
  String body;
}

class Ballot {
  String ballotName;
  String category;
  String publisher;
  double treasurySymbol;
  String body;
}