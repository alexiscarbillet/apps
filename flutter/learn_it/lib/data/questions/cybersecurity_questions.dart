import '../../models/question.dart';

final List<Map<String, dynamic>> _cybersecurityQuestionBlueprints = [
  {
    'questionText': 'Which part of the CIA triad ensures information is only available to those with proper authorization?',
    'options': ['Confidentiality', 'Integrity', 'Availability', 'Authentication'],
    'correctAnswerIndex': 0,
    'explanation': 'Confidentiality is the security property that prevents unauthorized disclosure of information or access to sensitive data.',
  },
  {
    'questionText': 'What does the principle of least privilege mean?',
    'options': ['Users should have only the minimum access required to perform their duties', 'All employees should have full system access', 'Security policies should be applied only to admin accounts', 'Only network devices need access restrictions'],
    'correctAnswerIndex': 0,
    'explanation': 'Least privilege minimizes risk by limiting permissions to what is strictly necessary for a user, service, or process to do its job.',
  },
  {
    'questionText': 'Why is Multi-Factor Authentication effective?',
    'options': ['It requires two or more verification factors, reducing the chance of credential-only compromise', 'It removes the need for passwords entirely', 'It encrypts all files automatically', 'It prevents phishing websites from loading'],
    'correctAnswerIndex': 0,
    'explanation': 'MFA adds an additional verification step beyond a password, so an attacker who steals a password alone is still blocked.',
  },
  {
    'questionText': 'What is the purpose of TLS?',
    'options': ['To encrypt communications between clients and servers over a network', 'To store passwords securely in a database', 'To route packets across subnets', 'To prevent unauthorized hardware changes'],
    'correctAnswerIndex': 0,
    'explanation': 'TLS (Transport Layer Security) protects data in transit by encrypting traffic between endpoints such as browsers and web servers.',
  },
  {
    'questionText': 'Which security control addresses known vulnerabilities in software and operating systems?',
    'options': ['Patch management', 'VPN tunneling', 'Data deduplication', 'Load balancing'],
    'correctAnswerIndex': 0,
    'explanation': 'Patch management ensures updates are installed promptly to close known vulnerabilities and reduce attack exposure.',
  },
  {
    'questionText': 'What common attack injects malicious script into a trusted web page?',
    'options': ['Cross-Site Scripting (XSS)', 'DDoS', 'ARP spoofing', 'Keylogging'],
    'correctAnswerIndex': 0,
    'explanation': 'XSS occurs when attackers inject script code into a page that other users view, often targeting browser-side execution and session data.',
  },
  {
    'questionText': 'Which web flaw occurs when untrusted data is included in a database query?',
    'options': ['SQL injection', 'Buffer overflow', 'Credential stuffing', 'Man-in-the-middle'],
    'correctAnswerIndex': 0,
    'explanation': 'SQL injection occurs when attacker-controlled input is not properly parameterized or validated and is used in an SQL statement.',
  },
  {
    'questionText': 'What is the role of a firewall?',
    'options': ['To filter and control network traffic based on rules and policy', 'To encrypt data at rest', 'To generate security logs automatically', 'To back up database transactions'],
    'correctAnswerIndex': 0,
    'explanation': 'Firewalls restrict or allow traffic based on policy, helping prevent unauthorized access and reduce exposure to attacks.',
  },
  {
    'questionText': 'Which incident type involves malicious software that encrypts files and demands payment?',
    'options': ['Ransomware', 'Phishing', 'Credential stuffing', 'DDOS'],
    'correctAnswerIndex': 0,
    'explanation': 'Ransomware encrypts files or systems and demands a ransom to restore access, often spreading across networks and endpoints.',
  },
  {
    'questionText': 'What does SIEM primarily help security teams do?',
    'options': ['Collect, correlate, and analyze security events from multiple sources', 'Replace identity providers', 'Manage version control for code', 'Create network diagrams automatically'],
    'correctAnswerIndex': 0,
    'explanation': 'Security Information and Event Management (SIEM) centralizes logs and detections so analysts can identify incidents, trends, and unusual behavior.',
  },
];

final List<Question> cybersecurityQuestions = List.generate(50, (index) {
  final blueprint = _cybersecurityQuestionBlueprints[index % _cybersecurityQuestionBlueprints.length];
  final titleSuffix = ' (Practice ${index + 1})';

  return Question(
    questionText: '${blueprint['questionText']}$titleSuffix',
    options: List<String>.from(blueprint['options'] as List),
    correctAnswerIndex: blueprint['correctAnswerIndex'] as int,
    explanation: blueprint['explanation'] as String,
  );
});
