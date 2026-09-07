import '../models/question.dart';
import 'questions/cpu_architecture_questions.dart';
import 'questions/hardware_foundations_questions.dart';
import 'questions/memory_systems_questions.dart';
import 'questions/motherboards_components_questions.dart';
import 'questions/power_thermals_questions.dart';
import 'questions/storage_io_questions.dart';

final Map<String, List<Question>> quizData = {
  'Hardware Foundations': hardwareFoundationsQuestions,
  'CPU Architecture': cpuArchitectureQuestions,
  'Memory Systems': memorySystemsQuestions,
  'Storage & I/O': storageIoQuestions,
  'Motherboards & Components': motherboardsComponentsQuestions,
  'Power & Thermals': powerThermalsQuestions,
};