import '../../models/cheatsheet.dart';
import 'electricity_cheatsheet.dart';

final Map<String, Cheatsheet> electricityCategoryCheatsheets = {
  'Electrical Foundations': electricityCheatsheet,
  'Circuit Analysis': Cheatsheet(
    category: 'Circuit Analysis',
    summary: 'Analyze voltage, current, resistance, nodes, loops, and circuit behavior.',
    sections: [
      electricityCheatsheet.sections[0],
      electricityCheatsheet.sections[2],
      CheatsheetSection(
        title: 'Network Laws',
        content: 'Kirchhoff laws and equivalent circuits make complex networks easier to analyze.',
        bulletPoints: [
          'Kirchhoff Current Law says current entering a node equals current leaving it.',
          'Kirchhoff Voltage Law says signed voltage changes around a closed loop sum to zero.',
          'Thevenin equivalents reduce a linear network to a voltage source and series resistance.',
          'Norton equivalents reduce a linear network to a current source and parallel resistance.',
        ],
      ),
    ],
  ),
  'AC/DC & Power': Cheatsheet(
    category: 'AC/DC & Power',
    summary: 'Understand alternating and direct current, power conversion, frequency, and power factor.',
    sections: [
      electricityCheatsheet.sections[1],
      CheatsheetSection(
        title: 'Power Conversion',
        content: 'Electrical systems convert, regulate, and distribute energy while managing heat and losses.',
        bulletPoints: [
          'Rectifiers convert AC to DC, while inverters convert DC to AC.',
          'Transformers use electromagnetic induction to change AC voltage levels.',
          'Real power is measured in watts; apparent power is measured in volt-amperes.',
          'Power factor describes how effectively AC current produces useful real power.',
        ],
      ),
    ],
  ),
  'Components & Semiconductors': Cheatsheet(
    category: 'Components & Semiconductors',
    summary: 'Learn what resistors, capacitors, inductors, diodes, transistors, and sensors do.',
    sections: [
      electricityCheatsheet.sections[3],
      CheatsheetSection(
        title: 'Passive Components',
        content: 'Passive components shape voltage, current, timing, filtering, and energy storage without providing gain.',
        bulletPoints: [
          'Resistors limit current and divide voltage while dissipating energy as heat.',
          'Capacitors store energy in an electric field and oppose rapid voltage changes.',
          'Inductors store energy in a magnetic field and oppose rapid current changes.',
          'RC, RL, and RLC networks create filters and timing responses.',
        ],
      ),
    ],
  ),
  'Wiring & Canadian Regulations': Cheatsheet(
    category: 'Wiring & Canadian Regulations',
    summary: 'Build practical wiring knowledge with Canadian code context, conductor types, and protection devices.',
    sections: [
      CheatsheetSection(
        title: 'Canadian Code Context',
        content: 'The Canadian Electrical Code provides the technical foundation for electrical installation rules, while provinces and territories adopt and enforce requirements locally.',
        bulletPoints: [
          'CSA C22.1 is the Canadian Electrical Code reference commonly used for installations.',
          'The locally adopted edition, provincial regulations, permits, and authority having jurisdiction control the work.',
          'Code requirements are not a substitute for a qualified electrician or required inspection.',
          'Conductor ampacity depends on size, material, insulation, temperature, grouping, and installation method.',
        ],
      ),
      CheatsheetSection(
        title: 'Wire and Cable Types',
        content: 'Cable selection depends on the environment, mechanical protection, conductor rating, and approved wiring method.',
        bulletPoints: [
          'NMD90 is commonly used for permitted concealed residential wiring.',
          'RW90 is an insulated conductor used in approved raceways and other wiring methods.',
          'AC90 and TECK90 provide armoured cable constructions for installations requiring mechanical protection.',
          'White or gray commonly identifies the grounded conductor; green or bare identifies bonding or grounding conductors.',
        ],
      ),
      CheatsheetSection(
        title: 'Protection and Safety',
        content: 'Protection devices reduce shock, fire, and equipment damage risks but each device addresses a different hazard.',
        bulletPoints: [
          'Breakers and fuses protect conductors from overcurrent.',
          'GFCI devices detect leakage imbalance and reduce shock risk.',
          'AFCI devices detect dangerous arcing patterns and reduce fire risk.',
          'Bonding creates a low-impedance fault path so protective devices can disconnect power.',
        ],
      ),
    ],
  ),
  'Safety & Applications': Cheatsheet(
    category: 'Safety & Applications',
    summary: 'Apply electrical principles safely in homes, workshops, renewable systems, and industrial equipment.',
    sections: [
      CheatsheetSection(
        title: 'Safe Work Practices',
        content: 'Electrical safety begins by controlling the energy source before touching conductors or equipment.',
        bulletPoints: [
          'De-energize, lock out, tag out, and verify absence of voltage before work.',
          'Use properly rated test equipment and personal protective equipment.',
          'Never assume a conductor is safe because a switch is off; isolate and test it.',
          'Overcurrent, ground-fault, and arc-fault protection address different failure modes.',
        ],
      ),
      CheatsheetSection(
        title: 'Practical Systems',
        content: 'Electrical concepts appear in motors, solar systems, batteries, lighting, controls, and power supplies.',
        bulletPoints: [
          'Motors convert electrical energy into mechanical motion and can draw high starting current.',
          'Photovoltaic cells convert light into DC electricity through the photovoltaic effect.',
          'Batteries store chemical energy and deliver DC power through electrochemical reactions.',
          'LEDs are efficient semiconductor light sources that require current limiting.',
        ],
      ),
    ],
  ),
};
