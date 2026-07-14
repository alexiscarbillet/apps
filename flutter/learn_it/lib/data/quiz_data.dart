import '../models/question.dart';
import 'questions/ai_questions.dart';
import 'questions/aws_questions.dart';
import 'questions/azure_questions.dart';
import 'questions/electricity_questions.dart';
import 'questions/gcp_questions.dart';
import 'questions/hardware_questions.dart';
import 'questions/kubernetes_questions.dart';
import 'questions/network_questions.dart';
import 'questions/python_questions.dart';
import 'questions/bash_questions.dart';
import 'questions/linux_questions.dart';
import 'questions/sql_questions.dart';

final Map<String, List<Question>> quizData = {
  'AWS': awsQuestions,
  'GCP': gcpQuestions,
  'Azure': azureQuestions,
  'AI': aiQuestions,
  'Kubernetes': kubernetesQuestions,
  'Hardware': hardwareQuestions,
  'Network': networkQuestions,
  'Electricity': electricityQuestions,
  'Python': pythonQuestions,
  'Bash': bashQuestions,
  'Linux': linuxQuestions,
  'SQL': sqlQuestions,
};