import '../../models/cheatsheet.dart';

final Cheatsheet bashCheatsheet = Cheatsheet(
  category: 'Bash',
  summary: 'Master the command line, piping, redirection, environment variables, control flow, and special parameters.',
  sections: [
    CheatsheetSection(
      title: 'Pipes & Redirection Operators',
      content: 'The core power of Unix shells comes from redirecting inputs, outputs, and linking small utility commands together using pipes.',
      bulletPoints: [
        'Stdout Redirection (`>`): Overwrites target file with output. (`echo "hi" > file.txt`).',
        'Stdout Append (`>>`): Appends output to the end of target file.',
        'Stderr Redirection (`2>`): Redirects error output streams. (`command 2> errors.txt`).',
        'Piping (`|`): Channels stdout of the left command directly into stdin of the right command.',
      ],
      codeSnippet: '# Filter lines containing "error", sort them, and save to a file\ncat app.log | grep "ERROR" | sort -u > unique_errors.log',
    ),
    CheatsheetSection(
      title: 'Control Flow: Conditions & Loops',
      content: 'Bash scripting supports loops and conditionals to automate repetitive command line tasks.',
      bulletPoints: [
        'If Statement: Executes branches based on command exit codes or test evaluations. Use `[[ expression ]]` for modern evaluations.',
        'For Loop: Iterates over lists, ranges, or file wildcards.',
        'While Loop: Loops as long as a condition resolves to success (exit status 0).',
      ],
      codeSnippet: r'''# Loop over files and rename them
for file in *.jpeg; do
    mv "$file" "${file%.jpeg}.jpg"
done

# Conditional check
if [[ -f "settings.conf" ]]; then
    echo "Settings file exists!"
fi''',
    ),
    CheatsheetSection(
      title: 'Special Shell Variables',
      content: 'Bash reserves several single-character parameters that hold operational details of the current execution.',
      bulletPoints: [
        r'`$?`: Holds the exit status of the last executed command. `0` indicates success; non-zero indicates an error.',
        r'`$#`: The count of command line arguments passed to the script.',
        r'`$@`: Expands to all command line arguments as separate words.',
        r'`$$`: The Process ID (PID) of the current shell session.',
      ],
      codeSnippet: r'''# Check if previous command succeeded
mkdir /root/secret
if [ $? -ne 0 ]; then
    echo "Failed to create directory! (Permissions issue?)"
fi''',
    ),
    CheatsheetSection(
      title: 'Variables & Command Substitution',
      content: 'Declaring data storage and capturing outputs of inline command executions.',
      bulletPoints: [
        'No Spaces: Never include spaces around the assignment operator (`=`). (e.g. `NAME="John"` is correct).',
        r'Command Substitution (`$(...)`): Executes command inline and saves its output to a variable.',
      ],
      codeSnippet: r'''# Save active date to a variable
CURRENT_DATE=$(date)
echo "Today is $CURRENT_DATE"''',
    ),
  ],
);
