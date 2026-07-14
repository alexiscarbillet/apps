import '../../models/cheatsheet.dart';

final Cheatsheet networkCheatsheet = Cheatsheet(
  category: 'Network',
  summary: 'Comprehensive summary of networking concepts, including the OSI model layers, routing, TCP/IP, and system-level networking tools.',
  sections: [
    CheatsheetSection(
      title: 'The OSI Reference Model',
      content: 'The Open Systems Interconnection (OSI) model standardizes the network communication functions into seven distinct logical layers.',
      bulletPoints: [
        'L7 - Application: User interface interactions (HTTP, HTTPS, DNS, SMTP, FTP).',
        'L4 - Transport: Process-to-process data delivery and control (TCP, UDP, ports).',
        'L3 - Network: Routing packets across networks based on logical addresses (IP, ICMP, routers).',
        'L2 - Data Link: Node-to-node frame delivery within the same network based on physical addresses (MAC, Ethernet, switches).',
        'L1 - Physical: Transmission of raw binary bits over physical media (cables, fibers, radio waves).',
      ],
      codeSnippet: 'OSI Mnemonic: "All People Seem To Need Data Processing"\n(Application, Presentation, Session, Transport, Network, Data Link, Physical)',
    ),
    CheatsheetSection(
      title: 'Transport Layer Protocols: TCP vs. UDP',
      content: 'The Transport Layer manages how packets are delivered between systems, providing two primary service models.',
      bulletPoints: [
        'TCP (Transmission Control Protocol): Connection-oriented. Uses a 3-way handshake (SYN, SYN-ACK, ACK), guarantees delivery, ordering, and congestion control.',
        'UDP (User Datagram Protocol): Connectionless. Lightweight header, sends packets without confirmation. Best for real-time traffic like streaming or gaming.',
      ],
      codeSnippet: 'TCP Header Size: Minimum 20 bytes\nUDP Header Size: Fixed 8 bytes',
    ),
    CheatsheetSection(
      title: 'IP Addressing & Subnetting',
      content: 'Logical addressing allows devices to locate each other across global networks.',
      bulletPoints: [
        'IPv4: 32-bit address represented in dotted-decimal format (e.g. 192.168.1.1). Offers ~4.3 billion addresses.',
        'IPv6: 128-bit address in hexadecimal format (e.g., 2001:db8::ff00:42:8329), solving IPv4 exhaustion.',
        'Subnet Mask: A bitmask dividing an IP into Network portion and Host portion (e.g. 255.255.255.0 or /24 CIDR notation).',
        'Private IP Ranges: Defined in RFC 1918 (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16) for internal use.',
      ],
      codeSnippet: '# View IP addresses on your system\nip address show  # (Linux/macOS)\nipconfig         # (Windows)',
    ),
    CheatsheetSection(
      title: 'Network Services: DNS & DHCP',
      content: 'Infrastructure services that automate device configuration and name resolution.',
      bulletPoints: [
        'DNS (Domain Name System): Hierarchical system translating domain names (google.com) to IP addresses. Uses UDP port 53.',
        'DHCP (Dynamic Host Configuration Protocol): Automatically leases IP addresses, gateway IPs, and DNS settings to devices on startup. Uses UDP ports 67/68.',
        'NAT (Network Address Translation): Modifies IP address information in packet headers while in transit, enabling multiple private IPs to share one public IP.',
      ],
      codeSnippet: '# Lookup IP addresses for a domain\nnslookup google.com\ndig +short google.com',
    ),
  ],
);
