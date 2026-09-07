import '../../models/decision_tree.dart';
import 'aws_decision_tree.dart';
import 'gcp_decision_tree.dart';
import 'azure_decision_tree.dart';
import 'ai_decision_tree.dart';
import 'kubernetes_decision_tree.dart';
import 'network_decision_tree.dart';
import 'bash_decision_tree.dart';
import 'linux_decision_tree.dart';
import 'python_decision_tree.dart';
import 'sql_decision_tree.dart';

final Map<String, List<DecisionTreeNode>> decisionTreeData = {
  'AWS': awsDecisionTree,
  'GCP': gcpDecisionTree,
  'Azure': azureDecisionTree,
  'AI': aiDecisionTree,
  'Kubernetes': kubernetesDecisionTree,
  'Network': networkDecisionTree,
  'Bash': bashDecisionTree,
  'Linux': linuxDecisionTree,
  'Python': pythonDecisionTree,
  'SQL': sqlDecisionTree,
};
