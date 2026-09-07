import '../models/cheatsheet.dart';
import 'cheatsheets/cpu_architecture_cheatsheet.dart';
import 'cheatsheets/hardware_foundations_cheatsheet.dart';
import 'cheatsheets/memory_systems_cheatsheet.dart';
import 'cheatsheets/motherboards_components_cheatsheet.dart';
import 'cheatsheets/power_thermals_cheatsheet.dart';
import 'cheatsheets/storage_io_cheatsheet.dart';

final Map<String, Cheatsheet> cheatsheetData = {
	'Hardware Foundations': hardwareFoundationsCheatsheet,
	'CPU Architecture': cpuArchitectureCheatsheet,
	'Memory Systems': memorySystemsCheatsheet,
	'Storage & I/O': storageIoCheatsheet,
	'Motherboards & Components': motherboardsComponentsCheatsheet,
	'Power & Thermals': powerThermalsCheatsheet,
};
