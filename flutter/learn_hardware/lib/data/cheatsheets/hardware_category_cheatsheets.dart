import '../../models/cheatsheet.dart';
import 'hardware_cheatsheet.dart';

final Map<String, Cheatsheet> hardwareCategoryCheatsheets = {
  'Hardware Foundations': hardwareCheatsheet,
  'CPU Architecture': Cheatsheet(
    category: 'CPU Architecture',
    summary: 'Learn how processors execute instructions, predict branches, and coordinate multiple cores.',
    sections: [
      hardwareCheatsheet.sections[0],
      CheatsheetSection(
        title: 'Instruction Execution',
        content: 'Modern CPUs overlap instruction work to increase throughput while preserving the appearance of sequential execution.',
        bulletPoints: [
          'Pipelining divides fetch, decode, execute, memory, and write-back into overlapping stages.',
          'Out-of-order execution runs ready instructions before earlier stalled instructions complete.',
          'Branch prediction guesses control-flow outcomes so the pipeline stays busy.',
          'Cache coherence keeps data consistent when multiple cores hold copies of the same memory.',
        ],
      ),
      CheatsheetSection(
        title: 'CPU Design Choices',
        content: 'Architecture decisions trade latency, throughput, power use, and software compatibility.',
        bulletPoints: [
          'ISA defines instructions, registers, addressing modes, and privilege behavior exposed to software.',
          'SMT lets one physical core schedule multiple logical threads when execution resources are idle.',
          'Turbo and boost technologies raise clock speed when temperature and power budgets allow it.',
          '32-bit and 64-bit designs differ in address width and the size of native integer operations.',
        ],
      ),
    ],
  ),
  'Memory Systems': Cheatsheet(
    category: 'Memory Systems',
    summary: 'Build a clear mental model of caches, RAM technologies, memory channels, and reliability.',
    sections: [
      hardwareCheatsheet.sections[1],
      CheatsheetSection(
        title: 'RAM Architecture',
        content: 'System RAM is organized into modules, channels, ranks, and banks that affect bandwidth and latency.',
        bulletPoints: [
          'DDR transfers data on both clock edges to increase effective bandwidth.',
          'DDR5 increases bandwidth and density while lowering voltage compared with DDR4.',
          'Dual-channel memory uses two matched channels to increase the path available to the memory controller.',
          'DIMM slots connect desktop or server memory modules to the motherboard memory channels.',
        ],
      ),
      CheatsheetSection(
        title: 'Reliability and Retention',
        content: 'Memory systems balance speed with the need to preserve correct data over time and across faults.',
        bulletPoints: [
          'DRAM cells store charge that leaks and therefore require periodic refresh operations.',
          'ECC memory detects and corrects common single-bit errors, which is valuable in servers and workstations.',
          'SRAM uses flip-flops, needs no refresh, and is commonly used for CPU caches.',
          'RAM is volatile; firmware storage and other non-volatile memory retain data without power.',
        ],
      ),
    ],
  ),
  'Storage & I/O': Cheatsheet(
    category: 'Storage & I/O',
    summary: 'Understand flash storage, hard drives, PCIe lanes, storage protocols, and redundancy.',
    sections: [
      hardwareCheatsheet.sections[2],
      CheatsheetSection(
        title: 'Drive Technologies',
        content: 'Storage devices differ in latency, endurance, throughput, cost, and failure modes.',
        bulletPoints: [
          'HDDs use spinning platters and mechanical heads, making random access slower but capacity inexpensive.',
          'SSDs use NAND flash and have no moving parts, delivering lower latency and higher IOPS.',
          'An M.2 slot is a physical connector that can host SATA or PCIe/NVMe devices depending on its keying and wiring.',
          'NVMe is a storage protocol designed for parallel flash access over PCIe.',
        ],
      ),
      CheatsheetSection(
        title: 'RAID and Redundancy',
        content: 'RAID combines drives to change performance, usable capacity, and tolerance for drive failure.',
        bulletPoints: [
          'RAID 0 stripes data for speed but has no redundancy.',
          'RAID 1 mirrors data for redundancy while sacrificing half or more of raw capacity.',
          'RAID 5 distributes data and parity and tolerates one failed drive.',
          'RAID improves availability or performance, but it is not a substitute for independent backups.',
        ],
      ),
    ],
  ),
  'Motherboards & Components': Cheatsheet(
    category: 'Motherboards & Components',
    summary: 'Trace how the motherboard connects compute, expansion, firmware, security, and peripherals.',
    sections: [
      CheatsheetSection(
        title: 'Chipset and Firmware',
        content: 'The motherboard provides the physical and logical connections that let the CPU communicate with the rest of the system.',
        bulletPoints: [
          'The chipset coordinates I/O between the processor, storage, USB devices, and expansion buses.',
          'UEFI initializes hardware and starts the boot process, replacing legacy BIOS workflows on modern systems.',
          'The CMOS battery preserves firmware settings and the real-time clock when the system is unplugged.',
          'Legacy Northbridge and Southbridge roles are now commonly integrated into the CPU and platform controller hub.',
        ],
      ),
      CheatsheetSection(
        title: 'Expansion and Security',
        content: 'Expansion components add capabilities while security hardware establishes a trusted base for the operating system.',
        bulletPoints: [
          'A NIC provides the hardware interface for Ethernet or Wi-Fi communication.',
          'An iGPU shares the processor package and system memory, while a discrete GPU has separate compute and VRAM resources.',
          'A TPM protects keys and supports measured boot, device encryption, and platform attestation.',
          'Motherboard form factor defines physical dimensions, mounting points, expansion layout, and compatible cases.',
        ],
      ),
    ],
  ),
  'Power & Thermals': Cheatsheet(
    category: 'Power & Thermals',
    summary: 'Learn how computers convert power, manage heat, and protect components under demanding workloads.',
    sections: [
      CheatsheetSection(
        title: 'Power Delivery',
        content: 'A stable power path converts wall power and distributes the correct voltage to each component.',
        bulletPoints: [
          'The PSU converts AC mains power into regulated DC rails used by the computer.',
          'A motherboard VRM further regulates voltage for the CPU and other low-voltage components.',
          '80 PLUS measures conversion efficiency, not the total wattage a PSU can deliver.',
          'A UPS provides temporary battery power and protection during an outage or unstable input.',
        ],
      ),
      CheatsheetSection(
        title: 'Thermal Management',
        content: 'Performance is bounded by the ability to move heat away from silicon without exceeding safe temperatures.',
        bulletPoints: [
          'A heat sink increases surface area so heat can move from a chip into air or a liquid loop.',
          'TDP is a thermal design target for cooling and power planning, not a universal peak power limit.',
          'Thermal throttling lowers clock speed when temperature limits are exceeded.',
          'Overclocking raises frequency or voltage and usually requires additional cooling and power headroom.',
        ],
      ),
    ],
  ),
};
