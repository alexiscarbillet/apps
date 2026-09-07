import '../../models/flashcard.dart';

final List<Flashcard> electricityFlashcards = [
  Flashcard(
    frontTitle: 'What is Ohm\'s law?',
    frontSubtitle: 'ELECTRICITY CONCEPT',
    backTitle: 'Ohm\'s Law',
    backExplanation: 'Ohm\'s law relates voltage, current, and resistance in an electrical circuit. It states that V = I × R, meaning voltage equals current times resistance.',
    bulletPoints: [
      'V is voltage in volts, I is current in amperes, R is resistance in ohms.',
      'Higher resistance reduces current for a given voltage.',
      'Used to calculate circuit behavior and component ratings.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is the difference between AC and DC?',
    frontSubtitle: 'ELECTRICITY CONCEPT',
    backTitle: 'AC vs DC',
    backExplanation: 'DC (direct current) flows in one direction. AC (alternating current) changes direction periodically. Power grids use AC because it is easy to transform between voltages and transmit over long distances.',
    bulletPoints: [
      'DC is used in batteries, electronics, and solar panels.',
      'Standard mains AC is 50 Hz or 60 Hz depending on region.',
      'AC can be stepped up or down using transformers efficiently.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is a series circuit?',
    frontSubtitle: 'ELECTRICITY CONCEPT',
    backTitle: 'Series Circuit',
    backExplanation: 'In a series circuit, components are connected end-to-end so current flows through each component sequentially. The same current passes through every component, and voltages add across them.',
    bulletPoints: [
      'Total resistance = R1 + R2 + R3 ...',
      'If one component fails open, the entire circuit stops working.',
      'Series circuits are common in simple indicator lights and string LEDs.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is a parallel circuit?',
    frontSubtitle: 'ELECTRICITY CONCEPT',
    backTitle: 'Parallel Circuit',
    backExplanation: 'In a parallel circuit, components are connected across the same voltage source. Each branch receives the same voltage, and total current is the sum of branch currents.',
    bulletPoints: [
      'Total conductance = G1 + G2 + G3; total resistance is reciprocal of conductances.',
      'A single branch can fail without interrupting other branches.',
      'Home electrical outlets are wired in parallel for independent loads.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What does a capacitor store?',
    frontSubtitle: 'ELECTRICITY CONCEPT',
    backTitle: 'Capacitor',
    backExplanation: 'A capacitor stores electrical energy in an electric field between two conductive plates separated by a dielectric. It resists changes in voltage and is used for filtering, timing, and energy storage.',
    bulletPoints: [
      'Capacitance is measured in farads (F).',
      'In DC circuits, a capacitor eventually blocks steady current once charged.',
      'Common applications: smoothing power supplies, coupling AC signals, and timing circuits.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What does a diode do?',
    frontSubtitle: 'ELECTRICITY CONCEPT',
    backTitle: 'Diode',
    backExplanation: 'A diode allows current to flow in one direction only. It is used for rectification, protecting circuits from reverse polarity, and signal clipping.',
    bulletPoints: [
      'Forward bias conducts current; reverse bias blocks current until breakdown.',
      'A Zener diode can regulate voltage by operating in reverse breakdown.',
      'Light-emitting diodes (LEDs) emit light when forward biased.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is a transformer?',
    frontSubtitle: 'ELECTRICITY CONCEPT',
    backTitle: 'Transformer',
    backExplanation: 'A transformer transfers energy between circuits through magnetic induction. It changes AC voltage levels while maintaining power minus losses.',
    bulletPoints: [
      'Primary winding induces magnetic flux in the core, which induces voltage in the secondary winding.',
      'Step-up transformer increases voltage; step-down decreases voltage.',
      'Works only with AC or changing current, not with DC.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is a circuit breaker?',
    frontSubtitle: 'ELECTRICITY CONCEPT',
    backTitle: 'Circuit Breaker',
    backExplanation: 'A circuit breaker automatically interrupts current flow when the current exceeds a safe threshold. It protects wiring and devices from overheating and fire.',
    bulletPoints: [
      'Can be reset after trip, unlike a fuse which must be replaced.',
      'Common types: thermal-magnetic, ground-fault circuit interrupter (GFCI).',
      'Often installed in electrical panels for each circuit branch.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is power factor?',
    frontSubtitle: 'ELECTRICITY CONCEPT',
    backTitle: 'Power Factor',
    backExplanation: 'Power factor measures how effectively electrical power is converted into useful work. It is the ratio of real power to apparent power in AC circuits and is important for efficient energy use.',
    bulletPoints: [
      'Power factor = cos(φ) where φ is the phase angle between voltage and current.',
      'A lagging power factor is caused by inductive loads like motors and transformers.',
      'Utilities may charge extra for low power factor due to higher apparent power demand.',
    ],
    isConcept: true,
  ),
  Flashcard(
    frontTitle: 'What is Kirchhoff\'s voltage law?',
    frontSubtitle: 'ELECTRICITY CONCEPT',
    backTitle: 'Kirchhoff\'s Voltage Law (KVL)',
    backExplanation: 'KVL states that the sum of voltages around any closed loop is zero. It ensures energy conservation in circuit loops and helps calculate unknown voltages in series and complex circuits.',
    bulletPoints: [
      'Add voltage rises and drops algebraically around a loop.',
      'Used with mesh analysis to solve circuit networks.',
      'In a loop, sources and drops must balance exactly.',
    ],
    isConcept: true,
  ),
];