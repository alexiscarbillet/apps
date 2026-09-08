import '../models/question.dart';
import 'questions/ai_questions.dart';
import 'questions/aws_questions.dart';
import 'questions/azure_questions.dart';
import 'questions/azure_certifs/az104_questions.dart';
import 'questions/gcp_questions.dart';
import 'questions/gcp_certifs/genai_leader_questions.dart';
import 'questions/kubernetes_questions.dart';
import 'questions/network_questions.dart';
import 'questions/python_questions.dart';
import 'questions/bash_questions.dart';
import 'questions/linux_questions.dart';
import 'questions/sql_questions.dart';
import 'questions/docker_questions.dart';
import 'questions/cybersecurity_questions.dart';

final Map<String, List<Question>> quizData = {
  'AWS': awsQuestions,
  'GCP': gcpQuestions,
  'GCP GenAI Leader': gcpGenaiLeaderQuestions,
  'Azure': azureQuestions,
  'AZ-104 Prep Quiz': az104Questions,
  'AI': aiQuestions,
  'Kubernetes': kubernetesQuestions,
  'Network': networkQuestions,
  'Python': pythonQuestions,
  'Bash': bashQuestions,
  'Linux': linuxQuestions,
  'SQL': sqlQuestions,
  'Docker': dockerQuestions,
  'Cybersecurity': cybersecurityQuestions,
};