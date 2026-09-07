import '../../models/flashcard.dart';

final List<Flashcard> hardwareFlashcards = [
  Flashcard(
    frontTitle: 'What is CPU cache?',
    frontSubtitle: 'HARDWARE CONCEPT',
    backTitle: 'CPU Cache',
    backExplanation: 'A small, fast memory located close to the CPU cores that stores frequently accessed data and instructions. Cache reduces latency by avoiding slower main memory accesses.',
    bulletPoints: [
      'L1 cache: smallest and fastest, dedicated per core.',
      'L2 cache: larger than L1, may be per core or shared between cores.',
      'L3 cache: shared across cores, larger but slower than L1/L2.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is the difference between RAM and ROM?',
    frontSubtitle: 'HARDWARE CONCEPT',
    backTitle: 'RAM vs ROM',
    backExplanation: 'RAM is volatile memory used for active working data and programs. ROM is non-volatile memory used to store firmware or permanent system code that remains after power loss.',
    bulletPoints: [
      'RAM: read/write, fast, loses contents when power is removed.',
      'ROM: read-only or write-once, retains data without power.',
      'Modern systems use flash memory for firmware, a type of non-volatile ROM replacement.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is a GPU designed for?',
    frontSubtitle: 'HARDWARE CONCEPT',
    backTitle: 'GPU Purpose',
    backExplanation: 'A GPU is optimized for parallel processing of graphics and vector workloads. It excels at many simple operations across large datasets, which makes it ideal for rendering, machine learning, and compute-intensive tasks.',
    bulletPoints: [
      'Thousands of cores for parallel operations versus a few CPU cores.',
      'Commonly used for rendering, video encoding, AI training, and scientific compute.',
      'Dedicated VRAM stores textures, frame buffers, and large datasets for fast access.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is pipelining in CPU design?',
    frontSubtitle: 'HARDWARE CONCEPT',
    backTitle: 'CPU Pipelining',
    backExplanation: 'Pipelining divides instruction execution into stages, allowing multiple instructions to overlap in time. This increases throughput by keeping CPU execution units busy on different pipeline stages simultaneously.',
    bulletPoints: [
      'Typical stages: fetch, decode, execute, memory access, write-back.',
      'Pipeline hazards: structural, data, and control hazards can stall execution.',
      'Branch prediction helps reduce pipeline flushes from mispredicted branches.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is the difference between SSD and HDD?',
    frontSubtitle: 'HARDWARE CONCEPT',
    backTitle: 'SSD vs HDD',
    backExplanation: 'An HDD uses spinning magnetic platters and moving read/write heads. An SSD uses NAND flash memory with no moving parts, giving much faster access times and higher reliability.',
    bulletPoints: [
      'HDD: higher capacity per dollar, mechanical, slower random access.',
      'SSD: low latency, high IOPS, and no mechanical wear from moving parts.',
      'NVMe SSDs use PCIe for even higher throughput than SATA SSDs.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is hyperthreading / SMT?',
    frontSubtitle: 'HARDWARE CONCEPT',
    backTitle: 'Hyperthreading / SMT',
    backExplanation: 'Simultaneous Multithreading (SMT) presents a single physical CPU core as multiple logical cores. It improves utilization by allowing the core to schedule work from more than one thread when resources would otherwise be idle.',
    bulletPoints: [
      'Intel calls it Hyper-Threading Technology (HTT).',
      'Beneficial for workloads with thread-level parallelism and resource stalls.',
      'Not a substitute for more physical cores; performance gains vary by workload.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is instruction set architecture (ISA)?',
    frontSubtitle: 'HARDWARE CONCEPT',
    backTitle: 'Instruction Set Architecture',
    backExplanation: 'ISA defines the set of machine instructions a processor can execute, along with registers, addressing modes, and data types. It forms the contract between software and hardware.',
    bulletPoints: [
      'Examples: x86, ARM, RISC-V, MIPS.',
      'Software compiled for one ISA cannot run on another without translation or emulation.',
      'ISA-level features include instruction formats, calling conventions, and privilege modes.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is thermal throttling?',
    frontSubtitle: 'HARDWARE CONCEPT',
    backTitle: 'Thermal Throttling',
    backExplanation: 'Thermal throttling reduces CPU or GPU frequency to lower temperature when the device exceeds safe thermal limits. It protects hardware from overheating but decreases performance until temperatures fall.',
    bulletPoints: [
      'Triggered by temperature sensors on the die.',
      'Common in laptops and compact systems with limited cooling.',
      'Good cooling and airflow reduce throttling and maintain performance.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is VT-x / AMD-V?',
    frontSubtitle: 'HARDWARE CONCEPT',
    backTitle: 'Virtualization Extensions',
    backExplanation: 'Processor virtualization extensions (VT-x for Intel, AMD-V for AMD) provide hardware support for virtual machines. They enable guest OS context switches and isolation with lower overhead than pure software virtualization.',
    bulletPoints: [
      'Support nested virtualization in modern CPUs.',
      'Used by hypervisors like VMware, Hyper-V, and KVM.',
      'Provides features like extended page tables and CPU mode switching.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is a power supply efficiency rating?',
    frontSubtitle: 'HARDWARE CONCEPT',
    backTitle: 'PSU Efficiency Rating',
    backExplanation: 'A PSU efficiency rating indicates how much AC power is converted to DC power for the computer. Higher efficiency means less waste heat and lower energy cost.',
    bulletPoints: [
      '80 PLUS ratings: Bronze, Silver, Gold, Platinum, Titanium.',
      'Higher rating means less power lost as heat at common loads.',
      'Efficient PSUs also support stable voltage and quieter operation.',
    ],
    isConcept: true,
  ),
];