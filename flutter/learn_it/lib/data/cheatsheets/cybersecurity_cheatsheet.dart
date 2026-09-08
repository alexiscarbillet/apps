import '../../models/cheatsheet.dart';

final Cheatsheet cybersecurityCheatsheet = Cheatsheet(
  category: 'Cybersecurity',
  summary: 'Cybersecurity protects digital systems, data, and users from attacks, misuse, and disruption across identity, infrastructure, applications, and data handling.',
  sections: [
    CheatsheetSection(
      title: 'CIA Triad and Risk',
      content: 'The core security goals are confidentiality, integrity, and availability. Security teams design controls to balance these goals against business needs and risk tolerance.',
      bulletPoints: [
        'Confidentiality: prevent unauthorized disclosure of information.',
        'Integrity: ensure data and systems are not altered improperly.',
        'Availability: ensure services remain accessible when needed.',
        'Threat: possible harmful event; vulnerability: weakness that can be exploited.',
      ],
      codeSnippet: r'''Risk = Likelihood × Impact

Example: public-facing admin panel with weak credentials has high likelihood and critical impact.''',
    ),
    CheatsheetSection(
      title: 'Identity, Authentication, and Access Control',
      content: 'Strong identity controls reduce the chance that attackers can steal or misuse high-value permissions.',
      bulletPoints: [
        'Authentication verifies identity: password, MFA, hardware token, biometrics.',
        'Authorization determines what an identity is allowed to do.',
        'Least privilege: grant minimum access required for a task.',
        'Role-Based Access Control (RBAC): group permissions by role instead of individually.',
      ],
      codeSnippet: r'''# Example principle:
# Developers need production read-only access, not admin access or secrets management.''',
    ),
    CheatsheetSection(
      title: 'Network and Endpoint Security',
      content: 'Network controls limit exposure, while endpoint controls protect user devices, servers, and cloud workloads from exploited vulnerabilities.',
      bulletPoints: [
        'Firewall: filters traffic based on rules and ports.',
        'VPN: encrypts traffic over untrusted networks.',
        'EDR/XDR: detects and responds to malicious endpoint behavior.',
        'Patch management: keep OS, applications, and libraries current.',
      ],
      codeSnippet: r'''iptables -A INPUT -p tcp --dport 443 -j ACCEPT
ufw allow 22/tcp
# Restrict inbound traffic to only required services.''',
    ),
    CheatsheetSection(
      title: 'Application Security',
      content: 'Secure application design reduces common exploitation vectors like injection flaws, broken authentication, and insecure handling of user data.',
      bulletPoints: [
        'SQL injection: user input reaches a database query without validation.',
        'XSS: malicious scripts run inside a user’s browser.',
        'CSRF: forged requests exploit a victim’s active authenticated session.',
        'Secure header configuration: CSP, HSTS, X-Frame-Options, and HttpOnly cookies.',
      ],
      codeSnippet: r'''# Validate and encode user input before use
# Prefer parameterized queries and safe output escaping''',
    ),
    CheatsheetSection(
      title: 'Monitoring, Incident Response, and Recovery',
      content: 'Security is not only preventive. Monitoring, alerting, and a tested incident response process are essential for detection and recovery.',
      bulletPoints: [
        'SIEM: centralizes logs and correlates suspicious activity.',
        'Threat hunting: proactively look for indicators of compromise or lateral movement.',
        'Incident response: identify, contain, eradicate, recover, and learn.',
        'Backups and ransomware readiness: restore from known-good copies and test restore workflows.',
      ],
      codeSnippet: r'''1. Detect
2. Contain
3. Eradicate
4. Recover
5. Review and improve

Document playbooks before an incident occurs.''',
    ),
  ],
);
