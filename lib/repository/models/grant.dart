import 'dart:convert';

class Grant {
  Grant({
    this.amount,
    this.title,
    this.team,
    this.why,
  });

  String amount;
  String title;
  String team;
  String why;
  String proposer;
  String ballotName;
  int proposalId;

  String get amountFormatted => amount.split(' ').first + ' USD';

  Map<String, dynamic> body() {
    return {
      'title': title,
      'team': team,
      'why': why,
    };
  }

  Grant.fromJson(Map<String, dynamic> json) {
    final body = jsonDecode(json['body']);
    title = body['title'];
    team = body['team'];
    why = body['why'];
    amount = json['amount_requested'];
    proposer = json['proposer'];
    proposalId = json['proposal_id'];
    ballotName = json['ballot_name'];
  }
}
