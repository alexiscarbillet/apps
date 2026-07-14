import '../../models/cheatsheet.dart';

final Cheatsheet hardwareCheatsheet = Cheatsheet(
  category: 'Hardware',
  summary: 'Understanding physical computing architecture, from processor caches to high-speed storage buses and chipsets.',
  sections: [
    CheatsheetSection(
      title: 'CPU Architecture & Cache Hierarchies',
      content: 'The Central Processing Unit (CPU) executes code instructions using a fetch-decode-execute loop, relying on ultra-fast local memory layers.',
      bulletPoints: [
        'Registers: The smallest and fastest storage units located inside the CPU core, holding active instruction data.',
        'L1 Cache: Extremely fast, small (kilobytes), and located directly inside each core (separate for data and instructions).',
        'L2 Cache: Slightly larger than L1, slightly slower, dedicated to individual cores or shared between pairs.',
        'L3 Cache: Much larger (megabytes), slower than L1/L2, shared across all CPU cores on the chip.',
      ],
      codeSnippet: '// CPU Memory Access Times (Approximate Guidance)\nRegisters: < 1 ns\nL1 Cache:  ~ 1-2 ns\nL2 Cache:  ~ 3-5 ns\nL3 Cache:  ~ 10-15 ns\nMain RAM:  ~ 60-100 ns',
    ),
    CheatsheetSection(
      title: 'Memory vs. Storage',
      content: 'System memory (RAM) and long-term storage (SSD/HDD) differ significantly in speed, volatility, and data structures.',
      bulletPoints: [
        'RAM (Random Access Memory): Volatile (loses data on power loss), byte-addressable, and extremely fast read/write speeds.',
        'NAND Flash (SSDs): Non-volatile (retains data), block-addressable. Requires blocks to be erased before page writes.',
        'SRAM vs DRAM: SRAM (Static, used in CPU caches, uses flip-flops, no refresh needed) vs DRAM (Dynamic, used in RAM, uses capacitors, must be refreshed thousands of times per second).',
      ],
      codeSnippet: '// RAM Types:\n- DDR4 (Double Data Rate 4): Standard memory interfaces\n- DDR5: Increased bandwidth, lower voltage, higher density',
    ),
    CheatsheetSection(
      title: 'Buses & Storage Protocols',
      content: 'Buses are communication pathways between hardware components. The storage interface protocol determines the maximum throughput.',
      bulletPoints: [
        'PCIe (Peripheral Component Interconnect Express): High-speed serial bus standard connecting graphics cards, SSDs, and network adapters.',
        'NVMe (Non-Volatile Memory Express): A communication protocol designed specifically for flash memory, utilizing PCIe lanes for minimal latency.',
        'SATA: Legacy interface protocol designed for spinning hard drives (capped at ~600MB/s).',
        'PCIe Lanes: Indicated by x1, x4, x8, x16 (representing physical copper traces transferring data in parallel).',
      ],
      codeSnippet: 'NVMe Speed: Up to 7000+ MB/s (Gen 4 x4)\nSATA III Speed: Max ~ 600 MB/s',
    ),
    CheatsheetSection(
      title: 'Processors: GPU vs. TPU',
      content: 'Modern processing demands specialized compute units optimized for different math operations.',
      bulletPoints: [
        'GPU (Graphics Processing Unit): Thousands of simple cores running in parallel. Ideal for graphics rendering and floating-point vector math (matrix calculations).',
        'TPU (Tensor Processing Unit): Custom ASIC chip designed by Google specifically to accelerate TensorFlow neural network operations (highly optimized matrix multiplication).',
      ],
      codeSnippet: 'CPU: MIMD (Multiple Instruction, Multiple Data) - Optimized for low-latency serial tasks\nGPU: SIMD (Single Instruction, Multiple Data) - Optimized for high-throughput parallel tasks',
    ),
  ],
);
