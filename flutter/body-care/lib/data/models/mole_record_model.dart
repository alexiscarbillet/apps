enum MoleRiskRating { benign, monitor, doctorReview, biopsied }

class MoleInspectionLog {
  final String id;
  final DateTime date;
  final double sizeMm;
  final String notes;
  final String photoSimColorHex; // Hex string for visual color representation

  const MoleInspectionLog({
    required this.id,
    required this.date,
    required this.sizeMm,
    required this.notes,
    required this.photoSimColorHex,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'sizeMm': sizeMm,
    'notes': notes,
    'photoSimColorHex': photoSimColorHex,
  };

  factory MoleInspectionLog.fromJson(Map<String, dynamic> json) => MoleInspectionLog(
    id: json['id'] as String,
    date: DateTime.parse(json['date'] as String),
    sizeMm: (json['sizeMm'] as num).toDouble(),
    notes: json['notes'] as String? ?? '',
    photoSimColorHex: json['photoSimColorHex'] as String? ?? '#5C3826',
  );
}

class MoleRecord {
  final String id;
  final String label;
  final String bodyRegion; // "Head & Neck", "Chest & Torso", "Upper Back", "Lower Back", "Left Arm", "Right Arm", "Left Leg", "Right Leg"
  final bool isBackView;   // True if on posterior body map, false if anterior
  final double xPercent;   // 0.0 to 1.0 relative coordinate on silhouette
  final double yPercent;   // 0.0 to 1.0 relative coordinate on silhouette
  final double currentSizeMm;
  final String baseColorHex;
  final bool isAsymmetrical;
  final bool hasIrregularBorder;
  final bool hasMultipleColors;
  final bool isDiameterOver6mm;
  final bool isEvolving;
  final MoleRiskRating riskRating;
  final DateTime lastCheckedDate;
  final String clinicalNotes;
  final List<MoleInspectionLog> history;

  const MoleRecord({
    required this.id,
    required this.label,
    required this.bodyRegion,
    required this.isBackView,
    required this.xPercent,
    required this.yPercent,
    required this.currentSizeMm,
    required this.baseColorHex,
    required this.isAsymmetrical,
    required this.hasIrregularBorder,
    required this.hasMultipleColors,
    required this.isDiameterOver6mm,
    required this.isEvolving,
    required this.riskRating,
    required this.lastCheckedDate,
    required this.clinicalNotes,
    required this.history,
  });

  int get abcdeRiskScore {
    int score = 0;
    if (isAsymmetrical) score++;
    if (hasIrregularBorder) score++;
    if (hasMultipleColors) score++;
    if (isDiameterOver6mm || currentSizeMm >= 6.0) score++;
    if (isEvolving) score++;
    return score;
  }

  MoleRecord copyWith({
    String? id,
    String? label,
    String? bodyRegion,
    bool? isBackView,
    double? xPercent,
    double? yPercent,
    double? currentSizeMm,
    String? baseColorHex,
    bool? isAsymmetrical,
    bool? hasIrregularBorder,
    bool? hasMultipleColors,
    bool? isDiameterOver6mm,
    bool? isEvolving,
    MoleRiskRating? riskRating,
    DateTime? lastCheckedDate,
    String? clinicalNotes,
    List<MoleInspectionLog>? history,
  }) {
    return MoleRecord(
      id: id ?? this.id,
      label: label ?? this.label,
      bodyRegion: bodyRegion ?? this.bodyRegion,
      isBackView: isBackView ?? this.isBackView,
      xPercent: xPercent ?? this.xPercent,
      yPercent: yPercent ?? this.yPercent,
      currentSizeMm: currentSizeMm ?? this.currentSizeMm,
      baseColorHex: baseColorHex ?? this.baseColorHex,
      isAsymmetrical: isAsymmetrical ?? this.isAsymmetrical,
      hasIrregularBorder: hasIrregularBorder ?? this.hasIrregularBorder,
      hasMultipleColors: hasMultipleColors ?? this.hasMultipleColors,
      isDiameterOver6mm: isDiameterOver6mm ?? this.isDiameterOver6mm,
      isEvolving: isEvolving ?? this.isEvolving,
      riskRating: riskRating ?? this.riskRating,
      lastCheckedDate: lastCheckedDate ?? this.lastCheckedDate,
      clinicalNotes: clinicalNotes ?? this.clinicalNotes,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'bodyRegion': bodyRegion,
    'isBackView': isBackView,
    'xPercent': xPercent,
    'yPercent': yPercent,
    'currentSizeMm': currentSizeMm,
    'baseColorHex': baseColorHex,
    'isAsymmetrical': isAsymmetrical,
    'hasIrregularBorder': hasIrregularBorder,
    'hasMultipleColors': hasMultipleColors,
    'isDiameterOver6mm': isDiameterOver6mm,
    'isEvolving': isEvolving,
    'riskRating': riskRating.name,
    'lastCheckedDate': lastCheckedDate.toIso8601String(),
    'clinicalNotes': clinicalNotes,
    'history': history.map((e) => e.toJson()).toList(),
  };

  factory MoleRecord.fromJson(Map<String, dynamic> json) => MoleRecord(
    id: json['id'] as String,
    label: json['label'] as String,
    bodyRegion: json['bodyRegion'] as String,
    isBackView: json['isBackView'] as bool? ?? false,
    xPercent: (json['xPercent'] as num).toDouble(),
    yPercent: (json['yPercent'] as num).toDouble(),
    currentSizeMm: (json['currentSizeMm'] as num).toDouble(),
    baseColorHex: json['baseColorHex'] as String? ?? '#4A2E18',
    isAsymmetrical: json['isAsymmetrical'] as bool? ?? false,
    hasIrregularBorder: json['hasIrregularBorder'] as bool? ?? false,
    hasMultipleColors: json['hasMultipleColors'] as bool? ?? false,
    isDiameterOver6mm: json['isDiameterOver6mm'] as bool? ?? false,
    isEvolving: json['isEvolving'] as bool? ?? false,
    riskRating: MoleRiskRating.values.firstWhere(
      (e) => e.name == json['riskRating'],
      orElse: () => MoleRiskRating.monitor,
    ),
    lastCheckedDate: DateTime.parse(json['lastCheckedDate'] as String),
    clinicalNotes: json['clinicalNotes'] as String? ?? '',
    history: (json['history'] as List?)
            ?.map((e) => MoleInspectionLog.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );

  static List<MoleRecord> defaultMoleRecords() {
    final now = DateTime.now();
    return [
      MoleRecord(
        id: 'mole-1',
        label: 'Upper Right Scapula Dysplastic Nevus',
        bodyRegion: 'Upper Back',
        isBackView: true,
        xPercent: 0.64,
        yPercent: 0.28,
        currentSizeMm: 4.8,
        baseColorHex: '#422818',
        isAsymmetrical: true,
        hasIrregularBorder: false,
        hasMultipleColors: true,
        isDiameterOver6mm: false,
        isEvolving: false,
        riskRating: MoleRiskRating.monitor,
        lastCheckedDate: now.subtract(const Duration(days: 30)),
        clinicalNotes:
            'Slightly atypical pigment with two-tone brown hue. Inspected by dermatologist last year; stable.',
        history: [
          MoleInspectionLog(
            id: 'log-1-1',
            date: now.subtract(const Duration(days: 365)),
            sizeMm: 4.7,
            notes: 'Baseline photo taken during annual derm check. Stable borders.',
            photoSimColorHex: '#452A1A',
          ),
          MoleInspectionLog(
            id: 'log-1-2',
            date: now.subtract(const Duration(days: 30)),
            sizeMm: 4.8,
            notes: 'Self-check: no bleeding, no itching, border matches baseline.',
            photoSimColorHex: '#422818',
          ),
        ],
      ),
      MoleRecord(
        id: 'mole-2',
        label: 'Left Deltoid Uniform Nevus',
        bodyRegion: 'Left Arm',
        isBackView: false,
        xPercent: 0.22,
        yPercent: 0.27,
        currentSizeMm: 3.2,
        baseColorHex: '#2B170B',
        isAsymmetrical: false,
        hasIrregularBorder: false,
        hasMultipleColors: false,
        isDiameterOver6mm: false,
        isEvolving: false,
        riskRating: MoleRiskRating.benign,
        lastCheckedDate: now.subtract(const Duration(days: 60)),
        clinicalNotes: 'Classic benign junctional nevus. Well-defined symmetric border.',
        history: [
          MoleInspectionLog(
            id: 'log-2-1',
            date: now.subtract(const Duration(days: 60)),
            sizeMm: 3.2,
            notes: 'Self-inspection: completely uniform, low risk.',
            photoSimColorHex: '#2B170B',
          ),
        ],
      ),
      MoleRecord(
        id: 'mole-3',
        label: 'Mid-Lower Back Pigmented Macule',
        bodyRegion: 'Lower Back',
        isBackView: true,
        xPercent: 0.52,
        yPercent: 0.45,
        currentSizeMm: 5.2,
        baseColorHex: '#3D2314',
        isAsymmetrical: false,
        hasIrregularBorder: true,
        hasMultipleColors: false,
        isDiameterOver6mm: false,
        isEvolving: false,
        riskRating: MoleRiskRating.monitor,
        lastCheckedDate: now.subtract(const Duration(days: 15)),
        clinicalNotes: 'Wavy border; dermatologist requested photo check every 3 months.',
        history: [
          MoleInspectionLog(
            id: 'log-3-1',
            date: now.subtract(const Duration(days: 15)),
            sizeMm: 5.2,
            notes: 'Photo logged. No color change.',
            photoSimColorHex: '#3D2314',
          ),
        ],
      ),
    ];
  }
}
