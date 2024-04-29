class Prestation {
  final String discipline;
  final String prestationName;
  final String? prestataire;
  final String? observation;
  final double montant;
  final double pec;

  Prestation({
    required this.discipline,
    required this.prestationName,
    this.prestataire,
    this.observation,
    required this.montant,
    required this.pec,
  });

  factory Prestation.fromJson(Map<String, dynamic> json) {
    return Prestation(
      discipline: json['discipline'],
      prestationName: json['prestation'],
      prestataire: json['prestataire'] == false ? null : json['prestataire'],
      observation: json['observation'] == false ? null : json['observation'],
      montant: double.parse(json['montant'].toStringAsFixed(3)),
      pec: double.parse(json['pec'].toStringAsFixed(3)),
    );
  }

  @override
  String toString() {
    return 'Prestations: {discipline: $discipline, prestationName: $prestationName, prestataire: $prestataire, observation: $observation, montant: $montant, pec: $pec}';
  }
}
