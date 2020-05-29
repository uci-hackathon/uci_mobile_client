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

  Map<String, dynamic> body() {
    return {
      'title': title,
      'team': team,
      'why': why,
    };
  }
}
