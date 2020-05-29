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
  String ballot_name;
  String proposal_id;

  Map<String, dynamic> body() {
    return {
      'title': title,
      'team': team,
      'why': why,
    };
  }

  Grant.fromJson(Map<String, dynamic> json) {
    title = json['body']['title'];
    team = json['body']['team'];
    why = json['body']['why'];
    amount = json['amount_requested'];
    proposer = json['proposer'];
    proposal_id = json['proposal_id'];
    ballot_name = json['ballot_name'];
  }
}
