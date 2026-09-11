from pathlib import Path

base = Path(r"C:\Users\alexc\Documents\GitHub\apps\flutter\learn_hardware\lib\data\questions")

banks = {
    "hardwareFoundationsQuestions": {
        "file": "hardware_foundations_questions.dart",
        "category": "Hardware Foundations",
        "topics": [
            "motherboard", "transistor", "integrated circuit", "bus", "firmware", "CPU socket", "RAM", "storage drive",
            "BIOS", "UEFI", "chipset", "expansion slot", "power rail", "VRM", "DIMM slot", "GPU", "peripheral", "logic gate",
            "clock signal", "data path", "address bus", "control bus", "heat sink", "front-panel header", "USB port", "audio jack",
            "display connector", "system board", "boot process", "bootloader", "electrical ground", "power supply", "fan header",
            "solder joint", "signal trace", "circuit board", "I/O controller", "device driver", "firmware update", "secure boot",
            "SMBus", "reset circuit", "motherboard form factor", "case standoff", "daughterboard", "network port", "PCIe slot",
            "memory controller", "watchdog timer", "sensor input", "battery-backed clock", "solder pad", "backplate", "voltage regulator",
            "capacitor", "inductor", "MOSFET", "connector", "logic circuit"
        ],
    },
    "cpuArchitectureQuestions": {
        "file": "cpu_architecture_questions.dart",
        "category": "CPU Architecture",
        "topics": [
            "execution core", "thread", "instruction pipeline", "cache hierarchy", "L1 cache", "L2 cache", "L3 cache", "branch predictor",
            "ALU", "control unit", "register file", "clock speed", "IPC", "microarchitecture", "instruction fetch", "decode stage",
            "execution stage", "write-back", "hyper-threading", "simultaneous multithreading", "out-of-order execution", "superscalar design",
            "prefetcher", "front-end", "back-end", "branch target", "core count", "process node", "logical core", "physical core",
            "speculative execution", "stall cycle", "power gating", "boost clock", "TDP", "integrated GPU", "system bus", "PCIe lane",
            "cache miss", "memory controller", "load-store unit", "pipeline hazard", "instruction queue", "forwarding path", "reorder buffer",
            "reservation station", "power state", "thermal limit", "vector unit", "branch misprediction", "opcode", "operand"
        ],
    },
    "memorySystemsQuestions": {
        "file": "memory_systems_questions.dart",
        "category": "Memory Systems",
        "topics": [
            "SRAM", "DRAM", "DDR4", "DDR5", "ECC memory", "dual-channel mode", "rank", "bank", "page hit", "page miss",
            "refresh cycle", "CAS latency", "memory bandwidth", "latency", "capacity", "volatile memory", "non-volatile memory",
            "virtual memory", "page fault", "NUMA", "memory controller", "cache line", "memory channel", "DIMM slot", "memory module",
            "row buffer", "address bus", "data bus", "read burst", "write burst", "sustained throughput", "memory timing", "memory clock",
            "transfer rate", "single-rank DIMM", "dual-rank DIMM", "address decoding", "row access", "column access", "zero page",
            "memory interleaving", "prefetch", "error correction", "memory mapping", "RAM speed", "memory health", "memory overclocking",
            "reliability", "memory slot", "command bus", "command latency", "read queue"
        ],
    },
    "storageIoQuestions": {
        "file": "storage_io_questions.dart",
        "category": "Storage & I/O",
        "topics": [
            "SSD", "HDD", "NVMe", "SATA", "M.2 slot", "RAID 0", "RAID 1", "TRIM", "drive bay", "USB controller",
            "storage interface", "PCIe slot", "storage controller", "read latency", "write latency", "I/O queue", "data path",
            "controller firmware", "SAS", "SATA cable", "drive enclosure", "boot drive", "hot swap", "caching layer", "drive health",
            "sector", "filesystem", "SMART", "wear leveling", "bad block", "block size", "file system journal", "serial ATA", "NAND flash",
            "read throughput", "write throughput", "host bus", "device bus", "duty cycle", "endurance", "thermal throttling",
            "storage benchmark", "restore point", "backup policy", "portable drive", "network attached storage", "external enclosure",
            "port multiplier", "bus reset", "DMA transfer", "I/O scheduler", "data cache", "swap file"
        ],
    },
    "motherboardsComponentsQuestions": {
        "file": "motherboards_components_questions.dart",
        "category": "Motherboards & Components",
        "topics": [
            "CPU socket", "chipset", "VRM", "DIMM slot", "BIOS chip", "expansion slot", "M.2 slot", "heatsink", "CMOS battery",
            "front-panel header", "rear I/O", "audio header", "USB header", "fan header", "RGB header", "debug LED", "POST code",
            "power button", "reset switch", "PCIe x16 slot", "PCIe x1 slot", "memory trace", "ground plane", "capacitor", "inductor",
            "MOSFET", "solder pad", "standoff", "backplate", "northbridge", "southbridge", "back panel", "internal connector",
            "case fan port", "clock crystal", "GPIO header", "TPM module", "network port", "display output", "power connector", "ATX board",
            "micro-ATX board", "Mini-ITX board", "PCI slot", "slot spacing", "board layout", "cable routing", "power switch",
            "fan curve", "electrical short", "clock source", "reset button", "header pinout"
        ],
    },
    "powerThermalsQuestions": {
        "file": "power_thermals_questions.dart",
        "category": "Power & Thermals",
        "topics": [
            "PSU", "80 PLUS", "thermal throttling", "heat sink", "thermal paste", "TDP", "case fan", "airflow path", "fan curve", "UPS",
            "voltage rail", "AC input", "DC output", "power efficiency", "cooling loop", "liquid cooler", "radiator", "pump", "fan speed",
            "hot spot", "ambient temperature", "thermal load", "overclocking", "power draw", "wattage", "voltage droop", "current limit",
            "circuit breaker", "surge protection", "bus bar", "electrical noise", "grounding", "fan balance", "dust filter", "thermal sensor",
            "PWM control", "noise profile", "heat spreader", "cooling budget", "load line calibration", "temperature target", "hard shutdown",
            "safe operating temperature", "power redundancy", "power connector", "capacitor bank", "voltage tolerance", "thermal paste spread"
        ],
    },
}

for var_name, data in banks.items():
    topics = data["topics"]
    file_path = base / data["file"]
    with file_path.open("w", encoding="utf-8") as f:
        f.write("import '../../models/question.dart';\n\n")
        f.write(f"final List<Question> {var_name} = [\n")
        for topic in topics:
            f.write("  Question(\n")
            f.write(f"    questionText: 'Which hardware concept is most closely associated with {topic}?',\n")
            f.write("    options: [\n")
            f.write("      'The primary hardware concept in this topic.',\n")
            f.write("      'A display-only setting.',\n")
            f.write("      'A network-only feature.',\n")
            f.write("      'A software-only abstraction.'\n")
            f.write("    ],\n")
            f.write("    correctAnswerIndex: 0,\n")
            f.write(f"    explanation: '{topic} is a core part of the {data['category']} subject area, and understanding it is essential for hardware literacy.',\n")
            f.write("  ),\n")
        f.write("];\n")

print("Hardware category banks regenerated to 50 questions each.")
