enum RiskLevel { low, moderate, high }
enum LabStatus { optimal, normal, borderline, needsAttention }

class RiskFactor {
  final String id;
  final String title;
  final String category; // e.g., Cardiovascular, Metabolic, Oncology, Longevity
  final RiskLevel riskLevel;
  final String familyRelation; // e.g., "Paternal Grandfather", "Maternal Aunt", "Self Genetic"
  final String notes;
  final List<String> mitigations;

  const RiskFactor({
    required this.id,
    required this.title,
    required this.category,
    required this.riskLevel,
    required this.familyRelation,
    required this.notes,
    required this.mitigations,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'riskLevel': riskLevel.name,
    'familyRelation': familyRelation,
    'notes': notes,
    'mitigations': mitigations,
  };

  factory RiskFactor.fromJson(Map<String, dynamic> json) => RiskFactor(
    id: json['id'] as String,
    title: json['title'] as String,
    category: json['category'] as String,
    riskLevel: RiskLevel.values.firstWhere(
      (e) => e.name == json['riskLevel'],
      orElse: () => RiskLevel.moderate,
    ),
    familyRelation: json['familyRelation'] as String? ?? '',
    notes: json['notes'] as String? ?? '',
    mitigations: List<String>.from(json['mitigations'] as List? ?? []),
  );
}

class LabMarker {
  final String id;
  final String name;
  final double value;
  final String unit;
  final String referenceRange;
  final LabStatus status;
  final DateTime dateRecorded;
  final String category; // e.g., "Lipids", "Metabolic", "Inflammation", "Vitamins"
  final String clinicalNote;

  const LabMarker({
    required this.id,
    required this.name,
    required this.value,
    required this.unit,
    required this.referenceRange,
    required this.status,
    required this.dateRecorded,
    required this.category,
    required this.clinicalNote,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'value': value,
    'unit': unit,
    'referenceRange': referenceRange,
    'status': status.name,
    'dateRecorded': dateRecorded.toIso8601String(),
    'category': category,
    'clinicalNote': clinicalNote,
  };

  factory LabMarker.fromJson(Map<String, dynamic> json) => LabMarker(
    id: json['id'] as String,
    name: json['name'] as String,
    value: (json['value'] as num).toDouble(),
    unit: json['unit'] as String,
    referenceRange: json['referenceRange'] as String,
    status: LabStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => LabStatus.normal,
    ),
    dateRecorded: DateTime.parse(json['dateRecorded'] as String),
    category: json['category'] as String,
    clinicalNote: json['clinicalNote'] as String? ?? '',
  );
}

class UserProfile {
  final String fullName;
  final int age;
  final String biologicalSex;
  final double heightCm;
  final double weightKg;
  final String bloodType;
  final int restingHeartRate;
  final int bloodPressureSystolic;
  final int bloodPressureDiastolic;
  final String personalWhy;
  final List<RiskFactor> riskFactors;
  final List<LabMarker> baselineLabs;

  const UserProfile({
    required this.fullName,
    required this.age,
    required this.biologicalSex,
    required this.heightCm,
    required this.weightKg,
    required this.bloodType,
    required this.restingHeartRate,
    required this.bloodPressureSystolic,
    required this.bloodPressureDiastolic,
    required this.personalWhy,
    required this.riskFactors,
    required this.baselineLabs,
  });

  double get bmi {
    if (heightCm <= 0) return 0;
    final hMeters = heightCm / 100.0;
    return weightKg / (hMeters * hMeters);
  }

  UserProfile copyWith({
    String? fullName,
    int? age,
    String? biologicalSex,
    double? heightCm,
    double? weightKg,
    String? bloodType,
    int? restingHeartRate,
    int? bloodPressureSystolic,
    int? bloodPressureDiastolic,
    String? personalWhy,
    List<RiskFactor>? riskFactors,
    List<LabMarker>? baselineLabs,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      biologicalSex: biologicalSex ?? this.biologicalSex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      bloodType: bloodType ?? this.bloodType,
      restingHeartRate: restingHeartRate ?? this.restingHeartRate,
      bloodPressureSystolic: bloodPressureSystolic ?? this.bloodPressureSystolic,
      bloodPressureDiastolic: bloodPressureDiastolic ?? this.bloodPressureDiastolic,
      personalWhy: personalWhy ?? this.personalWhy,
      riskFactors: riskFactors ?? this.riskFactors,
      baselineLabs: baselineLabs ?? this.baselineLabs,
    );
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'age': age,
    'biologicalSex': biologicalSex,
    'heightCm': heightCm,
    'weightKg': weightKg,
    'bloodType': bloodType,
    'restingHeartRate': restingHeartRate,
    'bloodPressureSystolic': bloodPressureSystolic,
    'bloodPressureDiastolic': bloodPressureDiastolic,
    'personalWhy': personalWhy,
    'riskFactors': riskFactors.map((e) => e.toJson()).toList(),
    'baselineLabs': baselineLabs.map((e) => e.toJson()).toList(),
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    fullName: json['fullName'] as String? ?? 'Alexis C.',
    age: json['age'] as int? ?? 31,
    biologicalSex: json['biologicalSex'] as String? ?? 'Male',
    heightCm: (json['heightCm'] as num?)?.toDouble() ?? 178.0,
    weightKg: (json['weightKg'] as num?)?.toDouble() ?? 73.5,
    bloodType: json['bloodType'] as String? ?? 'O+',
    restingHeartRate: json['restingHeartRate'] as int? ?? 58,
    bloodPressureSystolic: json['bloodPressureSystolic'] as int? ?? 118,
    bloodPressureDiastolic: json['bloodPressureDiastolic'] as int? ?? 76,
    personalWhy: json['personalWhy'] as String? ??
        'Build bulletproof cardiovascular and metabolic health to stay active, sharp, and cancer-free for decades to come.',
    riskFactors: (json['riskFactors'] as List?)
            ?.map((e) => RiskFactor.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    baselineLabs: (json['baselineLabs'] as List?)
            ?.map((e) => LabMarker.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );

  static UserProfile defaultProfile() => UserProfile(
    fullName: 'Alexis Carbillet',
    age: 31,
    biologicalSex: 'Male',
    heightCm: 178.0,
    weightKg: 73.0,
    bloodType: 'O+',
    restingHeartRate: 58,
    bloodPressureSystolic: 118,
    bloodPressureDiastolic: 76,
    personalWhy:
        'Mitigate family cardiovascular & skin predisposition; maintain optimal cellular vitality, mental sharpness, and long healthspan.',
    riskFactors: [
      const RiskFactor(
        id: 'rf-1',
        title: 'Familial Early Cardiovascular Risk',
        category: 'Cardiovascular',
        riskLevel: RiskLevel.high,
        familyRelation: 'Paternal History (Grandfather, Father)',
        notes: 'Elevated ApoB & coronary artery disease in male lineage in late 50s.',
        mitigations: [
          'High polyphenol intake (extra virgin olive oil, berries)',
          'Aerobic Zone 2 cardio (150 min/wk)',
          'Annual ApoB and Lipid panels',
          'Eliminate ultra-processed foods & trans fats',
        ],
      ),
      const RiskFactor(
        id: 'rf-2',
        title: 'Melanoma & High Mole Count (Atypical Nevi)',
        category: 'Dermatology / Oncology',
        riskLevel: RiskLevel.moderate,
        familyRelation: 'Fair skin phototype II, maternal history',
        notes: 'Multiple dysplastic nevi on back and arms. Higher UV sensitivity.',
        mitigations: [
          'Daily SPF 50+ mineral sunscreen when UV Index >= 3',
          'Quarterly photographic body mapping & mole monitoring',
          'Annual professional dermatological full-body scan',
        ],
      ),
      const RiskFactor(
        id: 'rf-3',
        title: 'Insulin Resistance & Type 2 Diabetes Predisposition',
        category: 'Metabolic',
        riskLevel: RiskLevel.moderate,
        familyRelation: 'Maternal Grandmother',
        notes: 'Post-prandial glycemic spikes if diet is high in refined carbohydrates.',
        mitigations: [
          '3+ daily servings of leafy green & cruciferous fibers',
          'Post-meal 10-minute walks to clear glucose',
          'Resistance training 3x/week for muscle insulin sensitivity',
        ],
      ),
    ],
    baselineLabs: [
      LabMarker(
        id: 'lab-1',
        name: 'ApoB (Apolipoprotein B)',
        value: 78.0,
        unit: 'mg/dL',
        referenceRange: '< 80 mg/dL (Optimal < 70)',
        status: LabStatus.optimal,
        dateRecorded: DateTime.now().subtract(const Duration(days: 45)),
        category: 'Cardiovascular',
        clinicalNote: 'Optimal particle count; great preventative cardiovascular marker.',
      ),
      LabMarker(
        id: 'lab-2',
        name: 'Fasting Blood Glucose',
        value: 86.0,
        unit: 'mg/dL',
        referenceRange: '70 - 99 mg/dL',
        status: LabStatus.optimal,
        dateRecorded: DateTime.now().subtract(const Duration(days: 45)),
        category: 'Metabolic',
        clinicalNote: 'Normal fasting homeostasis.',
      ),
      LabMarker(
        id: 'lab-3',
        name: 'HbA1c',
        value: 5.1,
        unit: '%',
        referenceRange: '< 5.7 %',
        status: LabStatus.optimal,
        dateRecorded: DateTime.now().subtract(const Duration(days: 45)),
        category: 'Metabolic',
        clinicalNote: 'Long-term glycemic stability is excellent.',
      ),
      LabMarker(
        id: 'lab-4',
        name: 'hs-CRP (High-Sensitivity CRP)',
        value: 0.45,
        unit: 'mg/L',
        referenceRange: '< 1.0 mg/L (Low systemic inflammation)',
        status: LabStatus.optimal,
        dateRecorded: DateTime.now().subtract(const Duration(days: 45)),
        category: 'Inflammation',
        clinicalNote: 'Extremely low vascular inflammation.',
      ),
      LabMarker(
        id: 'lab-5',
        name: 'Vitamin D (25-OH)',
        value: 48.0,
        unit: 'ng/mL',
        referenceRange: '30 - 100 ng/mL (Optimal 40-60)',
        status: LabStatus.optimal,
        dateRecorded: DateTime.now().subtract(const Duration(days: 45)),
        category: 'Vitamins & Hormones',
        clinicalNote: 'Adequate immune and bone density reserve.',
      ),
      LabMarker(
        id: 'lab-6',
        name: 'eGFR (Kidney Filtration)',
        value: 108.0,
        unit: 'mL/min/1.73m²',
        referenceRange: '> 90 mL/min',
        status: LabStatus.optimal,
        dateRecorded: DateTime.now().subtract(const Duration(days: 45)),
        category: 'Renal & Organ Health',
        clinicalNote: 'Excellent renal filtration rate.',
      ),
    ],
  );
}
