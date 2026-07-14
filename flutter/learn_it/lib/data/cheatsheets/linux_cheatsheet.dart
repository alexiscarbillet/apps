import '../../models/cheatsheet.dart';

final Cheatsheet linuxCheatsheet = Cheatsheet(
  category: 'Linux',
  summary: 'Reference guide for Linux administration, focusing on filesystem structure, file ownership, permissions, and process controls.',
  sections: [
    CheatsheetSection(
      title: 'The Filesystem Hierarchy Standard (FHS)',
      content: 'Linux systems organize files inside a single root directory (`/`) with strict conventions defining directory purposes.',
      bulletPoints: [
        '`/etc`: Host-specific configuration files for all system-wide programs.',
        '`/var`: Variable data directories housing logs, database tables, and mail spools.',
        '`/bin` & `/sbin`: Core user commands and essential system administration binaries.',
        '`/usr`: Read-only user data, documentation, and libraries.',
        '`/proc`: Virtual filesystem presenting kernel status and active process information.',
      ],
      codeSnippet: '# View contents of system release file\ncat /etc/os-release',
    ),
    CheatsheetSection(
      title: 'Permissions & File Ownership',
      content: 'Linux implements security access boundaries using Read (r=4), Write (w=2), and Execute (x=1) permissions assigned to Owner, Group, and Others.',
      bulletPoints: [
        'Chmod: Modifies file read/write/execute permissions. E.g. `chmod 755` provides rwxr-xr-x.',
        'Chown: Alters user owner and/or group owner values of files/directories.',
        'Numeric Notation: Created by summing permission bits. (e.g., Read(4)+Write(2)=6).',
      ],
      codeSnippet: '# Provide execute permission to owner, read/execute to others\nchmod 755 deploy.sh\n\n# Change owner to "admin" and group to "web"\nchown admin:web index.html',
    ),
    CheatsheetSection(
      title: 'Process Management',
      content: 'Operating system execution units are managed through process identifiers (PIDs).',
      bulletPoints: [
        'ps: Snapshot listing of active processes. `ps aux` shows system-wide details.',
        'top & htop: Interactive real-time resource monitors listing CPU and RAM usage.',
        'kill: Terminates processes by sending signals (e.g., SIGTERM=15, SIGKILL=9).',
      ],
      codeSnippet: '# Find PID of running service and terminate it forcefully\npgrep nginx\nkill -9 <PID_NUMBER>',
    ),
    CheatsheetSection(
      title: 'Systemd & Services',
      content: 'Systemd serves as the modern standard initialization system and service manager for Linux.',
      bulletPoints: [
        'Systemctl: Primary control utility to manage unit states (start, stop, restart, status).',
        'Enable vs Start: `start` boots service immediately; `enable` schedules it to start at boot time.',
      ],
      codeSnippet: '# Enable and start apache server\nsystemctl enable apache2\nsystemctl start apache2\nsystemctl status apache2',
    ),
  ],
);
