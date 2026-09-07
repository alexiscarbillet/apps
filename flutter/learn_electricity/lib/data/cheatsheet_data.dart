import '../models/cheatsheet.dart';
import 'cheatsheets/ac_dc_power_cheatsheet.dart';
import 'cheatsheets/circuit_analysis_cheatsheet.dart';
import 'cheatsheets/components_semiconductors_cheatsheet.dart';
import 'cheatsheets/electrical_foundations_cheatsheet.dart';
import 'cheatsheets/safety_applications_cheatsheet.dart';
import 'cheatsheets/wiring_canadian_cheatsheet.dart';

final Map<String, Cheatsheet> cheatsheetData = {
  'Electrical Foundations': electricalFoundationsCheatsheet,
  'Circuit Analysis': circuitAnalysisCheatsheet,
  'AC/DC & Power': acDcPowerCheatsheet,
  'Components & Semiconductors': componentsSemiconductorsCheatsheet,
  'Wiring & Canadian Regulations': wiringCanadianCheatsheet,
  'Safety & Applications': safetyApplicationsCheatsheet,
};
