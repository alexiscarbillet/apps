import '../../models/flashcard.dart';

final List<Flashcard> bashFlashcards = [
  Flashcard(
    frontTitle: 'What is the shell?',
    frontSubtitle: 'BASH CONCEPT',
    backTitle: 'Command Shell',
    backExplanation: 'The shell is a command interpreter that reads user input, executes commands, and returns output. Bash is a popular Unix shell that supports scripting, job control, and command history.',
    bulletPoints: [
      'The shell is distinct from the terminal emulator, which only displays text.',
      'Bash stands for Bourne Again Shell.',
      'Shell scripts are plain text files containing commands and control flow.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'How do pipes work in Bash?',
    frontSubtitle: 'BASH CONCEPT',
    backTitle: 'Pipes (|)',
    backExplanation: 'A pipe sends the stdout output of one command as stdin input to another command. It enables command chaining and simple data processing pipelines.',
    bulletPoints: [
      'Example: ls -l | grep ".txt" | sort -k9',
      'Pipes connect processes directly through kernel buffers.',
      'Each command in the pipeline executes concurrently.',
    ],
    codeSnippet: 'ps aux | grep nginx | awk \'{print $2, $11}\' | head -n 5',
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is stdout vs stderr?',
    frontSubtitle: 'BASH CONCEPT',
    backTitle: 'Standard Streams',
    backExplanation: 'stdout is the standard output stream for normal command output. stderr is the standard error stream for error messages. They can be redirected separately.',
    bulletPoints: [
      'stdout is file descriptor 1; stderr is file descriptor 2.',
      'Redirect stdout: command > output.txt',
      'Redirect stderr: command 2> error.txt',
    ],
    codeSnippet: 'ls /tmp > files.txt 2> errors.txt
# Combine stdout and stderr
ls /tmp > all.txt 2>&1',
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is command substitution?',
    frontSubtitle: 'BASH CONCEPT',
    backTitle: 'Command Substitution',
    backExplanation: 'Command substitution runs a command and substitutes its output into another command. Use $(...) for modern syntax or backticks for legacy compatibility.',
    bulletPoints: [
      'Example: files=$(ls /tmp)',
      'Substitution removes trailing newlines from command output.',
      'Useful for dynamic values in scripts and loops.',
    ],
    codeSnippet: 'today=$(date +%F)
echo "Backup file: backup-$today.tar.gz"',
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is a here document?',
    frontSubtitle: 'BASH CONCEPT',
    backTitle: 'Here Document',
    backExplanation: 'A here document feeds a block of text as stdin to a command. It is useful for embedding multiline input directly in a shell script.',
    bulletPoints: [
      'Syntax: command <<EOF ... EOF',
      'Use <<\'EOF\' to prevent variable expansion inside the block.',
      'Common with cat, sql clients, or configuration generators.',
    ],
    codeSnippet: 'cat <<EOF > config.txt
name=LearnIt
env=production
EOF',
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What do quotes do in Bash?',
    frontSubtitle: 'BASH CONCEPT',
    backTitle: 'Quoting',
    backExplanation: 'Quotes control how the shell interprets spaces, variables, and special characters. Single quotes prevent expansion entirely, while double quotes allow variable and command substitution.',
    bulletPoints: [
      'Single quotes: literal strings, no expansion.',
      'Double quotes: preserve spaces but expand $, ``, and \!.',
      'Unquoted words are split on whitespace and can be glob-expanded.',
    ],
    codeSnippet: 'name="Alice"
echo "Hello, $name"
echo \"Literal $name\"',
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is an environment variable?',
    frontSubtitle: 'BASH CONCEPT',
    backTitle: 'Environment Variables',
    backExplanation: 'Environment variables are key/value pairs inherited by child processes. They configure shell behavior, command paths, locale settings, and application options.',
    bulletPoints: [
      'Use export VAR=value to make a variable available to child processes.',
      'Common variables: PATH, HOME, SHELL, LANG.',
      'Access a variable with $VAR or ${VAR}.',
    ],
    codeSnippet: 'export PATH="$HOME/bin:$PATH"
echo "Current shell: $SHELL"',
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What does set -e do?',
    frontSubtitle: 'BASH CONCEPT',
    backTitle: 'set -e',
    backExplanation: 'set -e causes a shell script to exit immediately when any command returns a non-zero status. It makes scripts fail fast and avoids continuing after errors.',
    bulletPoints: [
      'Useful for safer automation and deployment scripts.',
      'Be careful with commands that intentionally return non-zero status.',
      'Often combined with set -u and set -o pipefail for stricter behavior.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What does chmod do?',
    frontSubtitle: 'BASH CONCEPT',
    backTitle: 'chmod Permissions',
    backExplanation: 'chmod changes file or directory permissions. Permissions control read, write, and execute access for the owner, group, and others.',
    bulletPoints: [
      'Common mode: chmod 755 file = rwxr-xr-x.',
      'Symbolic mode: chmod u+x script adds execute for owner.',
      'Execute permission is required to run shell scripts directly.',
    ],
    codeSnippet: 'chmod 644 document.txt
chmod u+x deploy.sh',
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is globbing in Bash?',
    frontSubtitle: 'BASH CONCEPT',
    backTitle: 'Filename Globbing',
    backExplanation: 'Globbing is shell expansion of wildcard patterns to match filenames. Common patterns include *, ?, and [ ] for sets and ranges.',
    bulletPoints: [
      '* matches any string, ? matches one character.',
      '[a-z]' matches any lowercase letter in the set.',
      'Use quotes to prevent globbing when literal characters are needed.',
    ],
    codeSnippet: 'ls *.sh
cp file?.txt backup/
rm report_[0-9][0-9].log',
    isConcept: true,
  ),
];