import '../models/cheatsheet.dart';
import 'cheatsheets/aws_cheatsheet.dart';
import 'cheatsheets/gcp_cheatsheet.dart';
import 'cheatsheets/azure_cheatsheet.dart';
import 'cheatsheets/ai_cheatsheet.dart';
import 'cheatsheets/kubernetes_cheatsheet.dart';
import 'cheatsheets/network_cheatsheet.dart';
import 'cheatsheets/python_cheatsheet.dart';
import 'cheatsheets/bash_cheatsheet.dart';
import 'cheatsheets/linux_cheatsheet.dart';
import 'cheatsheets/sql_cheatsheet.dart';
import 'cheatsheets/docker_cheatsheet.dart';
import 'cheatsheets/cybersecurity_cheatsheet.dart';

final Map<String, Cheatsheet> cheatsheetData = {
  'AWS': awsCheatsheet,
  'GCP': gcpCheatsheet,
  'Azure': azureCheatsheet,
  'AI': aiCheatsheet,
  'Kubernetes': kubernetesCheatsheet,
  'Network': networkCheatsheet,
  'Python': pythonCheatsheet,
  'Bash': bashCheatsheet,
  'Linux': linuxCheatsheet,
  'SQL': sqlCheatsheet,
  'Docker': dockerCheatsheet,
  'Cybersecurity': cybersecurityCheatsheet,
};
