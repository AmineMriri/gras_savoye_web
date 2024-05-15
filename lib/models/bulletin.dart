import 'package:healio/models/prestation.dart';

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
  final List<Prestation> prestations;

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
    required this.prestations,
  });

  factory Bulletin.fromJson(Map<String, dynamic> json) {
    return Bulletin(
      bsId: json['bs_id'] as int,
      numBs: json['num_bs'] as String? ?? '',
      dateMaladie: json['date_maladie'] as String? ?? '',
      dateReglement: json['date_reglement'] != null
          ? json['date_reglement'].toString()
          : '',
      patient: json['patient'] as String? ?? '',
      prestataire: json['prestataire'] as String? ?? '',
      adherent: json['adherent'] as String? ?? '',
      totalDep: (json['total_dep'] as num?)?.toDouble() ?? 0.0,
      totalPec: (json['total_pec'] as num?)?.toDouble() ?? 0.0,
      state: json['state'] as String? ?? '',
      isCV: json['is_cv'] as bool? ?? false,
      prestations: (json['prestations'] as List)
          .map((item) => Prestation.fromJson(item))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Bulletin{idBs: $bsId, numBs: $numBs, dateMaladie: $dateMaladie, dateReglement: $dateReglement, patient: $patient, prestataire: $prestataire, adherent: $adherent, totalDep: $totalDep, totalPec: $totalPec, state: $state, isCV: $isCV, prestations: $prestations}';
  }
}
