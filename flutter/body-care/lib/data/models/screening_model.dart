enum ScreeningStatus { completed, scheduled, upcoming, overdue }

class MedicalScreening {
  final String id;
  final String title;
  final String category; // e.g. "Cardiovascular", "Dermatology", "Metabolic", "Dentistry", "Vision", "GI"
  final int frequencyMonths;
  final DateTime? lastCompletedDate;
  final DateTime nextDueDate;
  final String providerName;
  final String facility;
  final ScreeningStatus status;
  final String notes;
  final String whyImportant;
  final List<String> prepChecklist;

  const MedicalScreening({
    required this.id,
    required this.title,
    required this.category,
    required this.frequencyMonths,
    this.lastCompletedDate,
    required this.nextDueDate,
    required this.providerName,
    required this.facility,
    required this.status,
    this.notes = '',
    required this.whyImportant,
    this.prepChecklist = const [],
  });

  int get daysUntilDue {
    final now = DateTime.now();
    return nextDueDate.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  bool get isOverdue => daysUntilDue < 0 && status != ScreeningStatus.completed;

  MedicalScreening copyWith({
    String? id,
    String? title,
    String? category,
    int? frequencyMonths,
    DateTime? lastCompletedDate,
    DateTime? nextDueDate,
    String? providerName,
    String? facility,
    ScreeningStatus? status,
    String? notes,
    String? whyImportant,
    List<String>? prepChecklist,
  }) {
    return MedicalScreening(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      frequencyMonths: frequencyMonths ?? this.frequencyMonths,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      providerName: providerName ?? this.providerName,
      facility: facility ?? this.facility,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      whyImportant: whyImportant ?? this.whyImportant,
      prepChecklist: prepChecklist ?? this.prepChecklist,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'frequencyMonths': frequencyMonths,
    'lastCompletedDate': lastCompletedDate?.toIso8601String(),
    'nextDueDate': nextDueDate.toIso8601String(),
    'providerName': providerName,
    'facility': facility,
    'status': status.name,
    'notes': notes,
    'whyImportant': whyImportant,
    'prepChecklist': prepChecklist,
  };

  factory MedicalScreening.fromJson(Map<String, dynamic> json) => MedicalScreening(
    id: json['id'] as String,
    title: json['title'] as String,
    category: json['category'] as String,
    frequencyMonths: json['frequencyMonths'] as int? ?? 12,
    lastCompletedDate: json['lastCompletedDate'] != null
        ? DateTime.parse(json['lastCompletedDate'] as String)
        : null,
    nextDueDate: DateTime.parse(json['nextDueDate'] as String),
    providerName: json['providerName'] as String? ?? '',
    facility: json['facility'] as String? ?? '',
    status: ScreeningStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => ScreeningStatus.upcoming,
    ),
    notes: json['notes'] as String? ?? '',
    whyImportant: json['whyImportant'] as String? ?? '',
    prepChecklist: List<String>.from(json['prepChecklist'] as List? ?? []),
  );

  static List<MedicalScreening> defaultScreenings() {
    final now = DateTime.now();
    return [
      MedicalScreening(
        id: 'sc-1',
        title: 'Full-Body Dermatological Skin Check',
        category: 'Dermatology & Oncology',
        frequencyMonths: 12,
        lastCompletedDate: now.subtract(const Duration(days: 300)),
        nextDueDate: now.add(const Duration(days: 65)),
        providerName: 'Dr. Valérie Mercier, MD (Dermatology)',
        facility: 'Montreal Health & Dermatology Clinic',
        status: ScreeningStatus.scheduled,
        notes: 'Review atypical dysplastic nevi on upper back and shoulder.',
        whyImportant:
            'Early detection of melanoma yields a >99% 5-year survival rate. Critical given familial skin cancer history.',
        prepChecklist: [
          'Perform self-body mole map check 2 days prior',
          'Avoid makeup or nail polish on appointment day',
          'List any evolving or itchy lesions',
        ],
      ),
      MedicalScreening(
        id: 'sc-2',
        title: 'Comprehensive Preventative Blood & Biomarker Panel',
        category: 'Metabolic & Cardiovascular',
        frequencyMonths: 12,
        lastCompletedDate: now.subtract(const Duration(days: 45)),
        nextDueDate: now.add(const Duration(days: 320)),
        providerName: 'Dynacare Diagnostics / Dr. Tremblay',
        facility: 'Centre Médical Westmount',
        status: ScreeningStatus.completed,
        notes: 'ApoB, hs-CRP, HbA1c, Ferritin, Fasting Insulin, Vitamin D, Full Lipid Panel.',
        whyImportant:
            'Identifies subclinical cardiovascular plaque drivers and metabolic dysregulation years before symptoms manifest.',
        prepChecklist: [
          '12-hour strict fasting (water permitted)',
          'Avoid heavy strenuous exercise 24h prior',
          'Take morning prescription meds after blood draw',
        ],
      ),
      MedicalScreening(
        id: 'sc-3',
        title: 'Preventative Dental & Periodontal Hygiene Scan',
        category: 'Dentistry & Systemic Health',
        frequencyMonths: 6,
        lastCompletedDate: now.subtract(const Duration(days: 120)),
        nextDueDate: now.add(const Duration(days: 60)),
        providerName: 'Dr. Marc Bouchard, DMD',
        facility: 'Cabinet Dentaire Laurier',
        status: ScreeningStatus.upcoming,
        notes: 'Periodontal pocket depth charting and oral cancer tissue screening.',
        whyImportant:
            'Periodontal pathogens (e.g. P. gingivalis) are direct systemic inflammatory drivers of arterial stiffness and Alzheimer pathology.',
        prepChecklist: [
          'Regular flossing and brushing',
          'Report any gum sensitivity or bleeding',
        ],
      ),
      MedicalScreening(
        id: 'sc-4',
        title: 'Coronary Calcium Scan (CAC) / Echo Baseline',
        category: 'Cardiovascular Longevity',
        frequencyMonths: 36,
        lastCompletedDate: null,
        nextDueDate: now.add(const Duration(days: 180)),
        providerName: 'Dr. Laurent Moreau (Cardiologist)',
        facility: 'Montreal Heart Institute',
        status: ScreeningStatus.upcoming,
        notes: 'Low-dose cardiac CT to evaluate coronary artery calcium score.',
        whyImportant:
            'Direct anatomic visualization of coronary calcification to calibrate cardiovascular longevity protocol.',
        prepChecklist: [
          'No caffeine 4 hours prior',
          'Wear comfortable loose clothing',
        ],
      ),
      MedicalScreening(
        id: 'sc-5',
        title: 'Comprehensive Dilated Eye & Retinal Imaging',
        category: 'Neurological & Microvascular',
        frequencyMonths: 24,
        lastCompletedDate: now.subtract(const Duration(days: 400)),
        nextDueDate: now.add(const Duration(days: 140)),
        providerName: 'Dr. Sarah Chen, OD',
        facility: 'Optométrie Rockland',
        status: ScreeningStatus.upcoming,
        notes: 'OCT retinal microvasculature and intraocular pressure screening.',
        whyImportant:
            'The retina is the only directly visible microvascular bed in the body, providing insight into cerebral vascular health.',
        prepChecklist: [
          'Bring sunglasses for post-dilation glare',
          'Arrange transport if driving is uncomfortable after dilation',
        ],
      ),
    ];
  }
}
