class Bulletin {
  final int bsId;
  final String numBs;
  final String dateMaladie;
  final String dateReglement;
  final String patient;
  final String prestataire;
  final String adherent;
  final double totalDep;
  final double totalPec;
  final String state;
  final bool isCV;

  Bulletin({
    required this.bsId,
    required this.numBs,
    required this.dateMaladie,
    required this.dateReglement,
    required this.patient,
    required this.prestataire,
    required this.adherent,
    required this.totalDep,
    required this.totalPec,
    required this.state,
    required this.isCV,
  });

  factory Bulletin.fromJson(Map<String, dynamic> json) {
    return Bulletin(
      bsId: json['bs_id'],
      numBs: json['num_bs'],
      dateMaladie: json['date_maladie'],
      dateReglement: json['date_reglement'] is String
          ? json['date_reglement']
          : json['date_reglement'].toString(),
      patient: json['patient'],
      prestataire: json['prestataire'],
      adherent: json['adherent'],
      totalDep: double.parse(json['total_dep'].toStringAsFixed(3)),
      totalPec: double.parse(json['total_pec'].toStringAsFixed(3)),
      state: json['state'],
      isCV: json['is_cv'],
    );
  }
  @override
  String toString() {
    return 'Bulletin{idBs: $bsId, numBs: $numBs, dateMaladie: $dateMaladie, dateReglement: $dateReglement, patient: $patient, prestataire: $prestataire, adherent: $adherent, totalDep: $totalDep, totalPec: $totalPec, state: $state, isCV: $isCV}';
  }
}
