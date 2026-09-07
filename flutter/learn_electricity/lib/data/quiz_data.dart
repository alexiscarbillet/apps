import '../models/question.dart';
import 'questions/ac_dc_power_questions.dart';
import 'questions/circuit_analysis_questions.dart';
import 'questions/components_semiconductors_questions.dart';
import 'questions/electrical_foundations_questions.dart';
import 'questions/safety_applications_questions.dart';
import 'questions/wiring_canadian_questions.dart';

final Map<String, List<Question>> quizData = {
  'Electrical Foundations': electricalFoundationsQuestions,
  'Circuit Analysis': circuitAnalysisQuestions,
  'AC/DC & Power': acDcPowerQuestions,
  'Components & Semiconductors': componentsSemiconductorsQuestions,
  'Wiring & Canadian Regulations': wiringCanadianQuestions,
  'Safety & Applications': safetyApplicationsQuestions,
};