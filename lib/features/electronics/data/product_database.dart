import '../domain/electronics_models.dart';

/// Local product database.
/// All specifications are based on publicly available, general reference data.
/// Structured for future migration to a Node.js + MySQL backend.
class ProductDatabase {
  ProductDatabase._();

  static List<ElectronicsProduct> get allProducts => [
    ..._electronicComponents,
    ..._computerComponents,
    ..._laptopComponents,
    ..._remoteControls,
    ..._mobileAccessories,
    ..._computerAccessories,
    ..._electricalProducts,
    ..._audioVideo,
    ..._smartHome,
    ..._networkingDevices,
    ..._cablesConnectors,
    ..._toolsEquipment,
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. ELECTRONIC COMPONENTS
  // ═══════════════════════════════════════════════════════════════════════════
  static final List<ElectronicsProduct> _electronicComponents = [
    ElectronicsProduct(
      id: 'ec_resistor',
      name: 'Resistor',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Resistors',
      imageAsset: 'assets/images/products/resistor.jpg',
      description: 'A resistor is a passive two-terminal electrical component that implements electrical resistance as a circuit element. Resistors reduce current flow, adjust signal levels, divide voltages, bias active elements and terminate transmission lines.',
      workingPrinciple: 'A resistor works on Ohm\'s Law: V = I × R. It opposes the flow of electrical current by converting electrical energy into heat. Resistance value is determined by the material, length and cross-sectional area of the resistive element.',
      applications: [
        'Current limiting in LED circuits',
        'Voltage dividers',
        'Pull-up and pull-down circuits',
        'Signal attenuation',
        'Biasing transistors',
        'RC timing circuits',
      ],
      advantages: [
        'Simple and passive component',
        'Wide range of resistance values available',
        'Low cost and highly reliable',
        'Available in through-hole and SMD packages',
        'No polarity concerns',
      ],
      specifications: [
        const ProductSpec(
          label: 'Type',
          value: 'Carbon Film / Metal Film / Wire Wound',
        ),
        const ProductSpec(
          label: 'Resistance Range',
          value: '0.1 Ω to 10 MΩ (common)',
        ),
        const ProductSpec(label: 'Tolerance', value: '±1%, ±5%, ±10%'),
        const ProductSpec(
          label: 'Power Rating',
          value: '1/8W, 1/4W, 1/2W, 1W, 2W',
        ),
        const ProductSpec(
          label: 'Temperature Coefficient',
          value: '±100 ppm/°C (metal film)',
        ),
        const ProductSpec(
          label: 'Package',
          value: 'Axial, 0402, 0603, 0805 (SMD)',
        ),
      ],
      voltageRange: 'Depends on power rating & resistance',
      powerRating: '1/8W to 2W (common)',
      pinConfiguration: 'Two terminals (non-polarised)',
      relatedProductIds: ['ec_capacitor', 'ec_inductor', 'ec_led'],
      tags: ['passive', 'ohm', 'resistance', 'carbon', 'metal film', 'smd'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ec_capacitor',
      name: 'Capacitor',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Capacitors',
      imageAsset: 'assets/images/products/capacitor.jpg',
      description: 'A capacitor is a passive electronic component that stores electrical energy in an electric field. Consisting of two conductive plates separated by a dielectric material, capacitors are used for filtering, energy storage, timing and decoupling.',
      workingPrinciple: 'A capacitor stores energy by accumulating charge on its plates: C = εA/d. It charges and discharges exponentially with time constant τ = RC, blocking DC while allowing AC signals to pass.',
      applications: [
        'Power supply filtering and decoupling',
        'RC timing circuits',
        'AC coupling (blocking DC)',
        'Energy storage in flash lamps and power supplies',
        'Motor start/run capacitors',
        'Resonant LC filter circuits',
      ],
      advantages: [
        'Rapid energy storage and release',
        'Blocks DC while passing AC signals',
        'High ripple current handling (electrolytic)',
        'Extensive range from pF to Farad supercapacitors',
      ],
      specifications: [
        const ProductSpec(
          label: 'Type',
          value: 'Electrolytic, Ceramic, Film, Tantalum',
        ),
        const ProductSpec(
          label: 'Capacitance Range',
          value: '1 pF to 10,000 µF',
        ),
        const ProductSpec(label: 'Voltage Rating', value: '6.3V to 450V DC'),
        const ProductSpec(label: 'Tolerance', value: '±5%, ±10%, ±20%'),
        const ProductSpec(
          label: 'Package',
          value: 'Radial, Axial, SMD (0402–2220)',
        ),
      ],
      voltageRange: '6.3V to 450V DC',
      pinConfiguration: 'Electrolytic: Polarised (+ longer pin, - stripe); Ceramic: Non-polarised',
      relatedProductIds: ['ec_resistor', 'ec_inductor'],
      tags: [
        'passive',
        'filter',
        'decoupling',
        'electrolytic',
        'ceramic',
        'smd',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ec_diode',
      name: 'Diode (Rectifier / Signal)',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Diodes',
      imageAsset: 'assets/images/products/diode.jpg',
      description: 'A diode allows current to flow primarily in one direction (anode to cathode). Fundamental to AC to DC power rectification, reverse polarity protection, and signal clipping.',
      workingPrinciple: 'Formed by a semiconductor P-N junction. When forward-biased (>0.7V for silicon), current flows easily. When reverse-biased, the depletion barrier widens, blocking reverse current up to the breakdown voltage.',
      applications: [
        'AC to DC Bridge Rectifiers',
        'Reverse polarity protection',
        'Flyback diode for inductive relay/motor spikes',
        'Voltage clamping and clipping',
      ],
      specifications: [
        const ProductSpec(
          label: 'Part Numbers',
          value: '1N4001 to 1N4007, 1N5408, 1N4148',
        ),
        const ProductSpec(
          label: 'Forward Voltage Drop',
          value: '0.6V–0.7V (Silicon), 0.2V–0.4V (Schottky)',
        ),
        const ProductSpec(
          label: 'Reverse Voltage (PIV)',
          value: '50V to 1000V (1N4007: 1000V)',
        ),
        const ProductSpec(
          label: 'Continuous Forward Current',
          value: '1A (1N4007), 3A (1N5408)',
        ),
      ],
      voltageRange: 'Forward: 0.7V; Reverse: up to 1000V',
      currentRating: '1A to 3A',
      pinConfiguration:
          'Anode (A) & Cathode (K, marked by silver/white stripe)',
      relatedProductIds: ['ec_zener', 'ec_led', 'ec_transistor'],
      tags: ['diode', '1n4007', 'rectifier', 'pn junction', 'schottky'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ec_zener',
      name: 'Zener Diode',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Zener Diodes',
      description: 'A Zener diode is designed to operate safely in reverse breakdown mode at a specified voltage (Vz). Used extensively for voltage references and voltage regulation.',
      workingPrinciple: 'When reverse biased beyond its breakdown threshold, Zener tunneling allows reverse current to flow while maintaining a constant voltage drop across its terminals.',
      specifications: [
        const ProductSpec(
          label: 'Common Voltages (Vz)',
          value: '3.3V, 5.1V, 9.1V, 12V, 15V',
        ),
        const ProductSpec(
          label: 'Power Dissipation',
          value: '500 mW (BZX55), 1W (1N47xx)',
        ),
        const ProductSpec(label: 'Package', value: 'DO-35, SOD-123'),
      ],
      voltageRange: 'Zener Breakdown: 2.4V to 200V',
      pinConfiguration: 'Anode & Cathode (Cathode marked with dark band)',
      relatedProductIds: ['ec_diode', 'ec_voltage_reg'],
      tags: ['zener', 'voltage reference', 'breakdown', 'clamping'],
    ),

    ElectronicsProduct(
      id: 'ec_led',
      name: 'LED (Light Emitting Diode)',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'LEDs',
      imageAsset: 'assets/images/products/led.jpg',
      description: 'A semiconductor light source that emits light when current flows through it. Highly efficient, cool-running and durable compared to traditional incandescent lamps.',
      workingPrinciple: 'Electroluminescence: When forward biased, electrons recombine with holes in the semiconductor band gap, releasing energy as photons of specific color wavelengths.',
      applications: [
        'Status indicator lamps',
        'Display backlights & LED matrix panels',
        'Infrared optical remote control emitters',
        'Automotive & household illumination',
      ],
      specifications: [
        const ProductSpec(
          label: 'Forward Voltage (Vf)',
          value: 'Red: 1.8V–2.0V; Green: 2.1V–2.4V; Blue/White: 3.0V–3.3V',
        ),
        const ProductSpec(
          label: 'Forward Current (If)',
          value: '20 mA (standard 5mm indicator)',
        ),
        const ProductSpec(
          label: 'Package Styles',
          value: '3mm, 5mm through-hole; SMD 0603, 0805, 5050',
        ),
      ],
      voltageRange: '1.8V to 3.3V DC (colour dependent)',
      currentRating: '20 mA typical',
      pinConfiguration:
          'Anode (Long lead / +) and Cathode (Short lead / flat edge / -)',
      relatedProductIds: ['ec_resistor', 'ec_diode'],
      tags: ['led', 'indicator', 'light', '5mm', 'rgb', 'diode'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ec_transistor',
      name: 'Transistor (BJT)',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Transistors',
      imageAsset: 'assets/images/products/transistor.jpg',
      description: 'Bipolar Junction Transistors (BJTs) are three-terminal semiconductor devices used to amplify signals or switch electrical power on and off.',
      workingPrinciple: 'Current-controlled device: A small current entering the Base pin (Ib) controls a much larger current between Collector and Emitter (Ic = hFE × Ib).',
      applications: [
        'Relay and motor switching',
        'Audio signal amplification',
        'Logic inverter and gate circuits',
        'Sensor interface buffering',
      ],
      specifications: [
        const ProductSpec(
          label: 'Popular Models',
          value: 'BC547 (NPN), BC557 (PNP), 2N2222 (NPN), 2N3906 (PNP)',
        ),
        const ProductSpec(label: 'Vce Max', value: '45V (BC547), 40V (2N2222)'),
        const ProductSpec(
          label: 'Collector Current (Ic)',
          value: '100 mA (BC547), 800 mA (2N2222)',
        ),
        const ProductSpec(label: 'DC Current Gain (hFE)', value: '110 to 800'),
        const ProductSpec(
          label: 'Package',
          value: 'TO-92 through-hole, SOT-23 SMD',
        ),
      ],
      voltageRange: 'Vce: 40V to 60V max',
      currentRating: '100 mA to 800 mA',
      pinConfiguration: 'Collector (C), Base (B), Emitter (E)',
      relatedProductIds: ['ec_mosfet', 'ec_relay'],
      tags: ['transistor', 'bjt', 'bc547', '2n2222', 'amplifier', 'switch'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ec_mosfet',
      name: 'Power MOSFET (N-Channel)',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'MOSFETs',
      description: 'Metal-Oxide-Semiconductor Field-Effect Transistor (MOSFET) designed to handle high currents and switch at high frequencies with minimal drive power.',
      workingPrinciple: 'Voltage-controlled device: Applying a voltage between Gate and Source creates an electric field that opens a conductive channel between Drain and Source (low Rds(on)).',
      specifications: [
        const ProductSpec(
          label: 'Popular Models',
          value: 'IRFZ44N, IRLZ44N (logic level), IRF540N',
        ),
        const ProductSpec(
          label: 'Drain-Source Voltage (Vds)',
          value: '55V (IRFZ44N), 100V (IRF540N)',
        ),
        const ProductSpec(
          label: 'Continuous Drain Current (Id)',
          value: '49A (IRFZ44N)',
        ),
        const ProductSpec(
          label: 'Rds(on) Resistance',
          value: '17.5 mΩ (IRFZ44N)',
        ),
        const ProductSpec(
          label: 'Gate Threshold (Vgs(th))',
          value: '2.0V–4.0V (Standard); 1.0V–2.0V (Logic-level)',
        ),
        const ProductSpec(
          label: 'Package',
          value: 'TO-220AB with metal heatsink tab',
        ),
      ],
      voltageRange: 'Vds: up to 55V–100V',
      currentRating: 'Up to 49A continuous',
      pinConfiguration:
          'Pin 1: Gate (G), Pin 2: Drain (D / Tab), Pin 3: Source (S)',
      relatedProductIds: ['ec_transistor', 'ec_relay'],
      tags: ['mosfet', 'irfz44n', 'n-channel', 'power', 'switch', 'pwm'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ec_ic_555',
      name: 'IC NE555 Precision Timer',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Integrated Circuits (IC)',
      imageAsset: 'assets/images/products/ic_timer.jpg',
      description: 'The 555 timer IC is a legendary 8-pin precision timing circuit capable of producing accurate time delays or continuous pulse oscillations in Astable, Monostable and Bistable modes.',
      workingPrinciple: 'Contains an internal 3-resistor 5kΩ voltage divider (1/3 Vcc and 2/3 Vcc thresholds), two voltage comparators, an SR flip-flop and an output discharge transistor.',
      applications: [
        'Pulse Width Modulation (PWM) motor control',
        'LED flashers and strobe lights',
        'Tone generators & audio beepers',
        'Switch debounce circuits',
      ],
      specifications: [
        const ProductSpec(
          label: 'Supply Voltage (Vcc)',
          value: '4.5V to 16V DC',
        ),
        const ProductSpec(
          label: 'Max Output Current',
          value: '200 mA (source or sink)',
        ),
        const ProductSpec(
          label: 'Timing Range',
          value: 'Microseconds to hours (via external R & C)',
        ),
        const ProductSpec(label: 'Package', value: 'DIP-8, SOIC-8'),
      ],
      voltageRange: '4.5V to 16V DC',
      currentRating: '200 mA output drive',
      pinConfiguration: '1:GND, 2:Trigger, 3:Output, 4:Reset, 5:Control, 6:Threshold, 7:Discharge, 8:Vcc',
      relatedProductIds: ['ec_resistor', 'ec_capacitor', 'ec_transistor'],
      tags: ['555', 'timer', 'ic', 'ne555', 'oscillator', 'pwm', 'dip8'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ec_arduino_uno',
      name: 'Arduino Uno R3 Microcontroller',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Microcontrollers',
      imageAsset: 'assets/images/products/microcontroller.jpg',
      description: 'Open-source microcontroller development board based on the Microchip ATmega328P 8-bit AVR processor. The global standard for robotics, IoT prototyping and electronics learning.',
      workingPrinciple: 'Executes user C/C++ firmware from flash memory. Interfaces with sensors and actuators through 14 digital I/O pins and 6 analog input channels with an onboard 16 MHz quartz crystal.',
      applications: [
        'Robotics & automated motor control',
        'Sensor data monitoring & telemetry',
        'Home automation controllers',
        'STEM education & engineering prototyping',
      ],
      specifications: [
        const ProductSpec(
          label: 'Microcontroller',
          value: 'ATmega328P (8-bit AVR)',
        ),
        const ProductSpec(
          label: 'Operating Voltage',
          value: '5V DC (Input via Barrel Jack: 7–12V)',
        ),
        const ProductSpec(
          label: 'Digital I/O Pins',
          value: '14 (of which 6 provide PWM output)',
        ),
        const ProductSpec(
          label: 'Analog Input Pins',
          value: '6 (10-bit resolution ADC)',
        ),
        const ProductSpec(
          label: 'Flash Memory',
          value: '32 KB (0.5 KB used by bootloader)',
        ),
        const ProductSpec(
          label: 'SRAM / EEPROM',
          value: '2 KB SRAM / 1 KB EEPROM',
        ),
        const ProductSpec(
          label: 'Clock Speed',
          value: '16 MHz Crystal Oscillator',
        ),
      ],
      voltageRange: '5V internal / 7V–12V external input',
      pinConfiguration: '14 Digital Pins (D0–D13), 6 Analog (A0–A5), Power (5V, 3.3V, GND, Vin)',
      relatedProductIds: ['ec_sensor_dht11', 'ec_relay', 'ec_breadboard'],
      tags: [
        'arduino',
        'uno',
        'atmega328p',
        'microcontroller',
        'embedded',
        'robotics',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ec_voltage_reg',
      name: 'LM7805 5V Voltage Regulator',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Voltage Regulators',
      description: 'Three-terminal positive linear voltage regulator IC that provides a steady, ripple-free 5V DC output from unregulated higher DC inputs.',
      workingPrinciple: 'Uses an internal bandgap reference and error amplifier to maintain a constant 5V output by dissipating excess voltage as heat across an internal series pass transistor.',
      specifications: [
        const ProductSpec(label: 'Output Voltage', value: '5.0V ± 4%'),
        const ProductSpec(label: 'Input Voltage Range', value: '7V to 35V DC'),
        const ProductSpec(
          label: 'Output Current (Max)',
          value: '1.5A (with adequate heatsink)',
        ),
        const ProductSpec(label: 'Dropout Voltage', value: '~2.0V typical'),
        const ProductSpec(label: 'Package', value: 'TO-220 with mounting hole'),
      ],
      voltageRange: 'Input: 7V–35V; Output: Fixed 5V DC',
      currentRating: '1.5A max',
      pinConfiguration:
          'Pin 1: Input (Vin), Pin 2: Ground (GND/Tab), Pin 3: Output (Vout)',
      relatedProductIds: ['ec_capacitor', 'ec_diode'],
      tags: [
        'voltage regulator',
        '7805',
        '5v',
        'to220',
        'linear',
        'power supply',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ec_relay',
      name: '5V SPDT Relay Module',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Relays',
      description: 'Electromechanical switch that allows low-power microcontroller pins (5V) to safely control high-voltage AC/DC loads (up to 250V AC / 10A).',
      workingPrinciple: 'An internal electromagnet coil energized by a 5V signal creates a magnetic field that physically pulls a mechanical armature, switching contacts between Normally Open (NO) and Normally Closed (NC).',
      specifications: [
        const ProductSpec(label: 'Coil Voltage', value: '5V DC (nominal)'),
        const ProductSpec(
          label: 'Contact Rating',
          value: '10A 250V AC / 10A 30V DC',
        ),
        const ProductSpec(
          label: 'Contact Configuration',
          value: 'SPDT (1 Form C: Common, NO, NC)',
        ),
        const ProductSpec(
          label: 'Isolation',
          value: 'Optocoupler optical isolation onboard',
        ),
      ],
      voltageRange: 'Coil: 5V DC; Contacts: Up to 250V AC',
      currentRating: '10A switching capacity',
      pinConfiguration: 'Input: VCC, GND, IN; Output: Common (COM), Normally Open (NO), Normally Closed (NC)',
      relatedProductIds: ['ec_arduino_uno', 'ec_transistor'],
      tags: [
        'relay',
        '5v relay',
        'switch',
        'optocoupler',
        'high voltage',
        'automation',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ec_sensor_dht11',
      name: 'DHT11 Temperature & Humidity Sensor',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Sensors',
      description: 'Basic, ultra low-cost digital temperature and relative humidity composite sensor with single-wire digital protocol communication.',
      workingPrinciple: 'Uses a resistive humidity measurement component and a negative temperature coefficient (NTC) thermistor, read by an onboard 8-bit microcontroller that outputs calibrated digital data.',
      specifications: [
        const ProductSpec(
          label: 'Humidity Range',
          value: '20% to 90% RH (±5% accuracy)',
        ),
        const ProductSpec(
          label: 'Temperature Range',
          value: '0°C to 50°C (±2°C accuracy)',
        ),
        const ProductSpec(label: 'Operating Voltage', value: '3.3V to 5.5V DC'),
        const ProductSpec(
          label: 'Sampling Rate',
          value: '1 Hz (1 reading per second)',
        ),
      ],
      voltageRange: '3.3V to 5.5V DC',
      pinConfiguration:
          'Pin 1: VCC, Pin 2: DATA (1-wire), Pin 3: NC, Pin 4: GND',
      relatedProductIds: ['ec_arduino_uno'],
      tags: [
        'sensor',
        'dht11',
        'temperature',
        'humidity',
        'weather',
        'digital',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ec_inductor',
      name: 'Toroidal Power Inductor',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Inductors',
      description: 'Passive two-terminal electronic component that stores energy in a magnetic field when electric current flows through its coiled wire.',
      workingPrinciple: 'Faraday\'s Law of Induction & Lenz\'s Law: Inductors oppose changes in current: V = L × (di/dt), filtering high-frequency noise in DC-DC converters.',
      specifications: [
        const ProductSpec(
          label: 'Inductance Range',
          value: '10 µH to 1 mH (common)',
        ),
        const ProductSpec(label: 'Current Rating', value: '1A to 10A DC'),
        const ProductSpec(
          label: 'Core Material',
          value: 'Ferrite / Iron Powder Toroid',
        ),
      ],
      relatedProductIds: ['ec_capacitor', 'ec_diode'],
      tags: ['inductor', 'coil', 'choke', 'filter', 'toroid', 'buck converter'],
    ),

    ElectronicsProduct(
      id: 'ec_fuse',
      name: 'Glass Tube Cartridge Fuse',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Fuses',
      description: 'Safety protection device that provides overcurrent protection by melting its internal sacrificial metal filament when excessive current flows.',
      workingPrinciple: 'Joule heating: I²R heat generated by excessive current rapidly reaches the melting point of the metal wire link, opening the circuit permanently.',
      specifications: [
        const ProductSpec(label: 'Dimensions', value: '5mm × 20mm (standard)'),
        const ProductSpec(
          label: 'Current Ratings',
          value: '0.5A, 1A, 2A, 3A, 5A, 10A',
        ),
        const ProductSpec(label: 'Voltage Rating', value: '250V AC'),
        const ProductSpec(
          label: 'Speed Characteristic',
          value: 'Fast-Acting (F) / Slow-Blow (T)',
        ),
      ],
      voltageRange: 'Up to 250V AC',
      relatedProductIds: ['ep_mcb'],
      tags: ['fuse', 'glass fuse', 'protection', 'safety', '5x20mm'],
    ),

    ElectronicsProduct(
      id: 'ec_crystal',
      name: '16 MHz Quartz Crystal Oscillator',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Crystal Oscillators',
      description: 'Precision resonant oscillator that creates an accurate, stable electrical frequency signal using the mechanical resonance of a vibrating piezoelectric quartz crystal.',
      workingPrinciple: 'Inverse Piezoelectric Effect: An alternating electric field across the quartz slice causes precise mechanical vibration at its resonant frequency (16 MHz).',
      specifications: [
        const ProductSpec(label: 'Nominal Frequency', value: '16.000 MHz'),
        const ProductSpec(label: 'Frequency Tolerance', value: '±20 ppm'),
        const ProductSpec(
          label: 'Load Capacitance (CL)',
          value: '18 pF to 22 pF',
        ),
        const ProductSpec(
          label: 'Package',
          value: 'HC-49S low-profile through-hole',
        ),
      ],
      relatedProductIds: ['ec_arduino_uno'],
      tags: ['crystal', 'oscillator', '16mhz', 'clock', 'quartz'],
    ),

    ElectronicsProduct(
      id: 'ec_breadboard',
      name: '830-Point Solderless Breadboard',
      category: ElectronicsCategory.electronicComponents,
      subcategory: 'Breadboards',
      description: 'Reusable construction base for solderless electrical circuit prototyping. Contains spring clips arranged in 5-hole rows with top and bottom power distribution bus rails.',
      specifications: [
        const ProductSpec(
          label: 'Tie Points',
          value: '830 points (630 component points + 200 power points)',
        ),
        const ProductSpec(
          label: 'Bus Rails',
          value: '4 power distribution buses (+ and -)',
        ),
        const ProductSpec(
          label: 'Pitch',
          value: '2.54 mm (0.1") standard DIP pitch',
        ),
      ],
      relatedProductIds: ['ec_arduino_uno', 'ec_resistor', 'ec_led'],
      tags: ['breadboard', 'prototype', 'solderless', '830', 'jumper'],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. COMPUTER COMPONENTS
  // ═══════════════════════════════════════════════════════════════════════════
  static final List<ElectronicsProduct> _computerComponents = [
    ElectronicsProduct(
      id: 'cc_cpu',
      name: 'Desktop Processor (CPU)',
      category: ElectronicsCategory.computerComponents,
      subcategory: 'Processors',
      brand: 'Intel',
      modelNumber: 'Core i9-14900K',
      imageAsset: 'assets/images/products/cpu.jpg',
      description: 'High-performance flagship 24-core desktop processor. Features 8 Performance-cores and 16 Efficient-cores with max turbo frequency up to 6.0 GHz for extreme gaming and content creation.',
      workingPrinciple: 'Executes billions of instructions per second through multi-stage pipelines, out-of-order execution, hybrid architecture scheduling, and shared 36MB Intel Smart Cache.',
      specifications: [
        const ProductSpec(
          label: 'Cores / Threads',
          value: '24 Cores (8P + 16E) / 32 Threads',
        ),
        const ProductSpec(label: 'Max Turbo Frequency', value: 'Up to 6.0 GHz'),
        const ProductSpec(
          label: 'Socket',
          value: 'LGA1700 (Intel 600 & 700 series chipsets)',
        ),
        const ProductSpec(
          label: 'Cache',
          value: '36 MB Intel Smart Cache (L3)',
        ),
        const ProductSpec(
          label: 'Base / Boost TDP',
          value: '125W Base / 253W Max Turbo',
        ),
        const ProductSpec(
          label: 'Memory Support',
          value: 'DDR5-5600 / DDR4-3200 (up to 192GB)',
        ),
      ],
      powerRating: '125W–253W TDP',
      relatedProductIds: ['cc_motherboard', 'cc_ram', 'cc_cooler'],
      tags: ['cpu', 'processor', 'intel', 'i9', '14900k', 'gaming', 'lga1700'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'cc_gpu',
      name: 'GeForce RTX 4080 Graphics Card',
      category: ElectronicsCategory.computerComponents,
      subcategory: 'Graphics Cards',
      brand: 'NVIDIA',
      modelNumber: 'RTX 4080 16GB',
      imageAsset: 'assets/images/products/gpu.jpg',
      description: 'Ultra-enthusiast graphics processing unit powered by the Ada Lovelace architecture. Features 16GB GDDR6X VRAM, 3rd gen RT cores, 4th gen Tensor cores, and DLSS 3 frame generation.',
      workingPrinciple: 'Massively parallel architecture with 9,728 CUDA cores executing vertex, fragment, compute and ray tracing shaders concurrently with dedicated AI acceleration.',
      specifications: [
        const ProductSpec(label: 'VRAM', value: '16 GB GDDR6X (256-bit bus)'),
        const ProductSpec(label: 'CUDA Cores', value: '9,728 Cores'),
        const ProductSpec(label: 'Boost Clock', value: '2.51 GHz'),
        const ProductSpec(label: 'Interface', value: 'PCIe 4.0 x16'),
        const ProductSpec(
          label: 'Power Connectors',
          value: '1 × 16-pin (12VHPWR)',
        ),
        const ProductSpec(
          label: 'Outputs',
          value: '3 × DisplayPort 1.4a, 1 × HDMI 2.1a',
        ),
      ],
      powerRating: '320W TGP (Recommended PSU: 750W+)',
      relatedProductIds: ['cc_psu', 'cc_motherboard'],
      tags: [
        'gpu',
        'rtx4080',
        'nvidia',
        'graphics',
        '16gb',
        'gddr6x',
        '4k gaming',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'cc_ram',
      name: 'Trident Z5 RGB DDR5 Desktop RAM',
      category: ElectronicsCategory.computerComponents,
      subcategory: 'RAM',
      brand: 'G.Skill',
      modelNumber: 'DDR5-6000 32GB (2x16GB)',
      imageAsset: 'assets/images/products/ram.jpg',
      description: 'Ultra-fast dual-channel DDR5 desktop gaming memory kit with sleek brushed aluminium heatspreaders and customizable RGB lighting bar.',
      workingPrinciple: 'High-speed synchronous dynamic random-access memory with dual 32-bit subchannels per DIMM and on-die ECC for superior data integrity at high transfer rates.',
      specifications: [
        const ProductSpec(label: 'Capacity', value: '32 GB (2 × 16 GB kit)'),
        const ProductSpec(label: 'Speed', value: 'DDR5-6000 MT/s'),
        const ProductSpec(label: 'Latency', value: 'CL30-38-38-96'),
        const ProductSpec(label: 'Tested Voltage', value: '1.35V'),
        const ProductSpec(
          label: 'Profiles',
          value: 'Intel XMP 3.0 & AMD EXPO ready',
        ),
      ],
      voltageRange: '1.35V Tested',
      relatedProductIds: ['cc_cpu', 'cc_motherboard'],
      tags: ['ram', 'ddr5', '32gb', 'gskill', 'rgb', '6000mhz', 'memory'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'cc_ssd',
      name: 'Samsung 990 Pro NVMe M.2 SSD',
      category: ElectronicsCategory.computerComponents,
      subcategory: 'SSD',
      brand: 'Samsung',
      modelNumber: 'MZ-V9P2T0B/AM (2TB)',
      imageAsset: 'assets/images/products/ssd.jpg',
      description: 'Blazing-fast PCIe Gen 4.0 x4 internal solid state drive delivering read speeds up to 7,450 MB/s for hardcore PC gamers, tech pros and 4K/8K video editors.',
      workingPrinciple: 'Stores data using 3D V-NAND flash memory cells controlled by Samsung\'s custom Pascal controller with LPDDR4 DRAM cache buffer.',
      specifications: [
        const ProductSpec(label: 'Form Factor', value: 'M.2 2280'),
        const ProductSpec(
          label: 'Interface',
          value: 'PCIe Gen 4.0 x4, NVMe 2.0',
        ),
        const ProductSpec(label: 'Sequential Read', value: 'Up to 7,450 MB/s'),
        const ProductSpec(label: 'Sequential Write', value: 'Up to 6,900 MB/s'),
        const ProductSpec(
          label: 'Endurance (TBW)',
          value: '1,200 TBW for 2TB model',
        ),
      ],
      relatedProductIds: ['cc_motherboard', 'lc_ssd'],
      tags: ['ssd', 'nvme', 'm2', 'samsung', '990pro', '2tb', 'gen4'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'cc_motherboard',
      name: 'ATX Gaming Motherboard',
      category: ElectronicsCategory.computerComponents,
      subcategory: 'Motherboard',
      brand: 'ASUS',
      modelNumber: 'TUF Gaming B650-Plus WiFi',
      description: 'Durable AMD AM5 ATX motherboard with robust 12+2 power stages, PCIe 5.0 M.2 support, DDR5 memory, Realtek 2.5Gb Ethernet and onboard Wi-Fi 6.',
      specifications: [
        const ProductSpec(
          label: 'Socket & Chipset',
          value: 'AMD AM5, AMD B650 Chipset',
        ),
        const ProductSpec(
          label: 'Memory Slots',
          value: '4 × DDR5 DIMM (up to 192GB, 7600+ OC)',
        ),
        const ProductSpec(
          label: 'Expansion Slots',
          value: '1 × PCIe 4.0/5.0 x16, 1 × PCIe 4.0 x16, 2 × PCIe 4.0 x1',
        ),
        const ProductSpec(
          label: 'Storage',
          value: '3 × M.2 slots (1 PCIe 5.0, 2 PCIe 4.0), 4 × SATA 6Gb/s',
        ),
      ],
      relatedProductIds: ['cc_cpu', 'cc_ram', 'cc_gpu'],
      tags: ['motherboard', 'asus', 'am5', 'b650', 'ddr5', 'wifi', 'atx'],
    ),

    ElectronicsProduct(
      id: 'cc_psu',
      name: '750W 80 Plus Gold Modular SMPS',
      category: ElectronicsCategory.computerComponents,
      subcategory: 'SMPS / Power Supply',
      brand: 'Corsair',
      modelNumber: 'RM750e',
      description: 'Fully modular low-noise ATX power supply with ATX 3.0 and PCIe 5.0 compliance. 105°C-rated capacitors deliver rock-solid, clean DC power.',
      specifications: [
        const ProductSpec(label: 'Wattage', value: '750 Watts Continuous'),
        const ProductSpec(
          label: 'Efficiency',
          value: '80 PLUS Gold certified (up to 90%)',
        ),
        const ProductSpec(
          label: 'Modularity',
          value: '100% Fully Modular black flat cables',
        ),
        const ProductSpec(
          label: 'Fan',
          value: '120mm rifle bearing fan with Zero RPM mode',
        ),
      ],
      powerRating: '750W',
      relatedProductIds: ['cc_gpu', 'cc_motherboard'],
      tags: ['psu', 'smps', 'power supply', '750w', '80plus gold', 'corsair'],
    ),

    ElectronicsProduct(
      id: 'cc_hdd',
      name: '2TB Internal 3.5" Hard Disk Drive',
      category: ElectronicsCategory.computerComponents,
      subcategory: 'HDD',
      brand: 'Seagate',
      modelNumber: 'BarraCuda 2TB',
      description: 'Cost-effective high-capacity internal 3.5-inch hard drive for desktop mass storage, game libraries and backups.',
      specifications: [
        const ProductSpec(label: 'Capacity', value: '2 TB'),
        const ProductSpec(label: 'Spindle Speed', value: '7,200 RPM'),
        const ProductSpec(label: 'Interface', value: 'SATA 6 Gb/s'),
        const ProductSpec(label: 'Cache', value: '256 MB multi-tiered caching'),
      ],
      tags: ['hdd', 'hard drive', '2tb', 'seagate', 'sata', 'storage'],
    ),

    ElectronicsProduct(
      id: 'cc_cooler',
      name: 'High-Performance Dual-Tower CPU Cooler',
      category: ElectronicsCategory.computerComponents,
      subcategory: 'CPU Cooler',
      brand: 'DeepCool',
      modelNumber: 'AK620',
      description: 'Dominant dual-tower heatsink CPU air cooler with six copper heat pipes and two fluid dynamic bearing 120mm PWM fans providing 260W TDP heat dissipation.',
      specifications: [
        const ProductSpec(
          label: 'Heat Dissipation (TDP)',
          value: 'Up to 260 Watts',
        ),
        const ProductSpec(
          label: 'Fans',
          value: '2 × 120mm FDB PWM fans (500–1850 RPM)',
        ),
        const ProductSpec(
          label: 'Compatibility',
          value: 'Intel LGA1700/1200/115x, AMD AM5/AM4',
        ),
      ],
      tags: ['cooler', 'cpu cooler', 'heatsink', 'dual tower', 'air cooler'],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. LAPTOP COMPONENTS
  // ═══════════════════════════════════════════════════════════════════════════
  static final List<ElectronicsProduct> _laptopComponents = [
    ElectronicsProduct(
      id: 'lc_battery',
      name: 'Laptop Replacement Battery',
      category: ElectronicsCategory.laptopComponents,
      subcategory: 'Laptop Battery',
      brand: 'Dell',
      modelNumber: 'WDX0R (42Wh 3-Cell)',
      imageAsset: 'assets/images/products/laptop_battery.jpg',
      description: 'Rechargeable internal lithium-ion laptop replacement battery pack with built-in intelligent Battery Management System (BMS) for overcharge, short circuit and thermal protection.',
      workingPrinciple: 'High-density Li-ion polymer cells store electrochemical energy. BMS circuitry communicates with the laptop motherboard via SMBus to report real-time state of charge, cell voltage and cycle count.',
      specifications: [
        const ProductSpec(label: 'Voltage', value: '11.4V DC'),
        const ProductSpec(label: 'Capacity', value: '42 Wh (3500 mAh, 3-Cell)'),
        const ProductSpec(label: 'Chemistry', value: 'Lithium-ion Polymer'),
        const ProductSpec(
          label: 'Compatible Dell Series',
          value: 'Dell Inspiron 13/15 (5567, 5568, 7560, 5368, 5378), Vostro 14/15',
        ),
      ],
      voltageRange: '11.4V DC',
      compatibility: 'Dell Inspiron 13 5368/5378, Inspiron 15 5567/5568/7560',
      laptopBrands: [
        'Dell',
        'HP',
        'Lenovo',
        'ASUS',
        'Acer',
        'MSI',
        'Apple',
        'Samsung',
      ],
      relatedProductIds: ['lc_charger', 'lc_display'],
      tags: ['laptop battery', 'dell', 'wdx0r', 'li-ion', 'replacement'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'lc_display',
      name: '15.6" Full HD 144Hz IPS Laptop Screen',
      category: ElectronicsCategory.laptopComponents,
      subcategory: 'Laptop Display',
      brand: 'BOE / LG Display',
      modelNumber: 'NV156FHM-NX1',
      description: 'Slim matte anti-glare IPS replacement display panel for 15.6-inch gaming and creator laptops with 144Hz refresh rate and wide viewing angles.',
      specifications: [
        const ProductSpec(
          label: 'Screen Size & Aspect',
          value: '15.6 inches, 16:9 widescreen',
        ),
        const ProductSpec(label: 'Resolution', value: '1920 × 1080 (Full HD)'),
        const ProductSpec(label: 'Refresh Rate', value: '144 Hz'),
        const ProductSpec(
          label: 'Interface Connector',
          value: '40-pin eDP connector (bottom right)',
        ),
        const ProductSpec(
          label: 'Panel Technology',
          value: 'IPS (In-Plane Switching), 250 nits',
        ),
      ],
      compatibility: 'Compatible with ASUS TUF, Acer Nitro 5, HP Pavilion Gaming, Lenovo Legion 15.6"',
      laptopBrands: ['ASUS', 'Acer', 'HP', 'Lenovo', 'Dell', 'MSI'],
      tags: [
        'screen',
        'display',
        'laptop screen',
        '15.6 inch',
        '144hz',
        'ips',
        'fhd',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'lc_charger',
      name: '65W USB-C Smart Laptop Charger',
      category: ElectronicsCategory.laptopComponents,
      subcategory: 'Laptop Charger',
      brand: 'HP',
      modelNumber: 'TPN-CA06 (65W USB-C)',
      description: 'Universal USB Power Delivery (USB-PD) replacement laptop AC adapter with intelligent auto-negotiating voltage output.',
      specifications: [
        const ProductSpec(
          label: 'Input Voltage',
          value: '100–240V AC, 50/60 Hz universal',
        ),
        const ProductSpec(
          label: 'Output Profiles',
          value: '5V/3A, 9V/3A, 12V/5A, 15V/4.33A, 20V/3.25A (65W Max)',
        ),
        const ProductSpec(label: 'Connector', value: 'Reversible USB Type-C'),
      ],
      voltageRange: 'Output: 5V to 20V DC (USB PD)',
      powerRating: '65W Max',
      laptopBrands: [
        'HP',
        'Dell',
        'Lenovo',
        'ASUS',
        'Acer',
        'Apple',
        'Samsung',
      ],
      tags: [
        'charger',
        'laptop adapter',
        'usb-c',
        '65w',
        'hp',
        'dell',
        'lenovo',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'lc_keyboard',
      name: 'Replacement Laptop Keyboard',
      category: ElectronicsCategory.laptopComponents,
      subcategory: 'Keyboard',
      brand: 'Lenovo',
      modelNumber: 'ThinkPad T480 / T470 Keyboard',
      description: 'Original layout replacement laptop keyboard with ergonomic curved keycaps, TrackPoint pointing stick and white LED backlighting.',
      specifications: [
        const ProductSpec(
          label: 'Layout',
          value: 'US English QWERTY with TrackPoint',
        ),
        const ProductSpec(
          label: 'Backlight',
          value: 'Yes (White dual-stage LED backlight)',
        ),
        const ProductSpec(
          label: 'Ribbon Connector',
          value: 'Dual flat flexible cables (FFC)',
        ),
      ],
      laptopBrands: ['Lenovo', 'Dell', 'HP', 'ASUS'],
      tags: ['laptop keyboard', 'thinkpad', 'lenovo', 'replacement', 'backlit'],
    ),

    ElectronicsProduct(
      id: 'lc_ram',
      name: '16GB DDR4 SO-DIMM Laptop RAM',
      category: ElectronicsCategory.laptopComponents,
      subcategory: 'Laptop RAM',
      brand: 'Crucial',
      modelNumber: 'CT16G4SFRA32A',
      description: 'High-speed 3200MHz DDR4 260-pin SO-DIMM laptop memory module designed to boost multitasking performance and eliminate system bottlenecks.',
      specifications: [
        const ProductSpec(
          label: 'Form Factor',
          value: '260-pin SO-DIMM (Laptop)',
        ),
        const ProductSpec(label: 'Speed', value: 'DDR4-3200 MT/s (PC4-25600)'),
        const ProductSpec(label: 'Capacity', value: '16 GB'),
        const ProductSpec(label: 'Operating Voltage', value: '1.2V'),
      ],
      laptopBrands: ['Dell', 'HP', 'Lenovo', 'ASUS', 'Acer', 'MSI'],
      tags: ['laptop ram', 'sodimm', 'ddr4', '16gb', '3200mhz', 'crucial'],
    ),

    ElectronicsProduct(
      id: 'lc_fan',
      name: 'Laptop CPU/GPU Cooling Blower Fan',
      category: ElectronicsCategory.laptopComponents,
      subcategory: 'Cooling Fan',
      brand: 'ASUS',
      modelNumber: 'TUF Gaming FX505 Fan Set',
      description: 'Direct replacement high-efficiency centrifugal blower fan for gaming laptop thermal heatsinks with 4-pin PWM speed control.',
      specifications: [
        const ProductSpec(label: 'Operating Voltage', value: 'DC 5V / 0.5A'),
        const ProductSpec(label: 'Connector', value: '4-pin PWM connector'),
      ],
      laptopBrands: ['ASUS', 'Dell', 'HP', 'Lenovo', 'Acer'],
      tags: ['cooling fan', 'blower fan', 'laptop fan', 'heatsink', 'asus'],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. REMOTE CONTROLS
  // ═══════════════════════════════════════════════════════════════════════════
  static final List<ElectronicsProduct> _remoteControls = [
    ElectronicsProduct(
      id: 'rc_tv_samsung',
      name: 'Samsung Smart TV Remote Control',
      category: ElectronicsCategory.remoteControls,
      subcategory: 'TV Remotes',
      brand: 'Samsung',
      modelNumber: 'BN59-01315D',
      imageAsset: 'assets/images/products/tv_remote.jpg',
      description: 'Replacement infrared remote control for Samsung 4K UHD, QLED and Crystal Smart LED TVs. Pre-programmed with instant dedicated Netflix, Prime Video and Zee5 app buttons.',
      workingPrinciple: 'Transmits 38 kHz modulated infrared pulses formatted with the Samsung NEC protocol. The TV\'s IR sensor receives and decodes the 32-bit hex command codes.',
      specifications: [
        const ProductSpec(
          label: 'Connectivity',
          value: 'Infrared (IR) line-of-sight',
        ),
        const ProductSpec(label: 'Carrier Frequency', value: '38 kHz standard'),
        const ProductSpec(
          label: 'Battery Required',
          value: '2 × AAA Alkaline batteries (3V total)',
        ),
        const ProductSpec(
          label: 'Operating Distance',
          value: 'Up to 10 metres (33 feet)',
        ),
        const ProductSpec(
          label: 'Material',
          value: 'Durable ABS plastic with soft silicone buttons',
        ),
      ],
      remoteType: 'Infrared (IR)',
      batteryType: '2 × AAA',
      compatibleModels: [
        'Samsung UA43T5300',
        'Samsung UA43AUE60AKLXL',
        'Samsung UA50AUE60',
        'Samsung UA55AUE60',
        'Samsung QA55Q60A',
        'Samsung QA65Q70A',
        'Samsung Crystal 4K UHD 2018–2024 Series',
      ],
      relatedProductIds: ['rc_tv_lg', 'rc_universal'],
      tags: [
        'samsung',
        'tv remote',
        'smart tv',
        'infrared',
        'replacement',
        'bn59',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'rc_tv_lg',
      name: 'LG Magic Remote with Motion Pointer',
      category: ElectronicsCategory.remoteControls,
      subcategory: 'Smart TV Remotes',
      brand: 'LG',
      modelNumber: 'MR22GN (Magic Remote)',
      description: 'Smart remote control for LG webOS Smart TVs featuring point-and-click motion control, scroll wheel navigation, and built-in microphone for Google Assistant and Alexa voice search.',
      specifications: [
        const ProductSpec(
          label: 'Connectivity',
          value: 'Bluetooth (RF 2.4GHz) + Infrared (IR) dual-mode',
        ),
        const ProductSpec(
          label: 'Motion Sensor',
          value: '6-axis Gyroscope & Accelerometer for mouse pointer',
        ),
        const ProductSpec(
          label: 'Battery Required',
          value: '2 × AA batteries (3V DC)',
        ),
        const ProductSpec(
          label: 'Voice Recognition',
          value: 'Built-in microphone',
        ),
      ],
      remoteType: 'Bluetooth & IR Hybrid',
      batteryType: '2 × AA',
      compatibleModels: [
        'LG OLED C1, C2, C3 Series',
        'LG OLED G1, G2, G3 Series',
        'LG NanoCell NANO75, NANO80 Series',
        'LG UHD UQ7500, UQ8000 Series',
      ],
      tags: [
        'lg',
        'magic remote',
        'mr22gn',
        'motion pointer',
        'voice remote',
        'bluetooth',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'rc_ac_voltas',
      name: 'Voltas Split AC Remote Control',
      category: ElectronicsCategory.remoteControls,
      subcategory: 'AC Remotes',
      brand: 'Voltas',
      modelNumber: 'Voltas All-Weather Inverter Remote',
      description: 'Complete replacement remote controller for Voltas Split and Window Air Conditioners. Features large backlit LCD display, Turbo cool mode, Sleep timer and Swing controls.',
      specifications: [
        const ProductSpec(label: 'Connectivity', value: 'Infrared (IR) 38 kHz'),
        const ProductSpec(
          label: 'Display',
          value: 'Multi-segment LCD with temperature readout',
        ),
        const ProductSpec(label: 'Temperature Range', value: '16°C to 30°C'),
        const ProductSpec(label: 'Battery', value: '2 × AAA batteries'),
      ],
      remoteType: 'Infrared (IR)',
      batteryType: '2 × AAA',
      compatibleModels: [
        'Voltas 123V Vectra',
        'Voltas 183V Vectra Elegant',
        'Voltas 185V Vectra Elite',
        'Voltas 1.5 Ton 3 Star Inverter',
        'Voltas 1.5 Ton 5 Star Inverter',
      ],
      tags: ['voltas', 'ac remote', 'split ac', 'inverter', 'air conditioner'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'rc_ac_daikin',
      name: 'Daikin Inverter AC Remote Control',
      category: ElectronicsCategory.remoteControls,
      subcategory: 'AC Remotes',
      brand: 'Daikin',
      modelNumber: 'ARC480A21',
      description: 'Genuine replacement remote for Daikin 3-Star & 5-Star Inverter Air Conditioners with Econo mode, Coanda airflow and indoor unit silent operation button.',
      specifications: [
        const ProductSpec(label: 'Connectivity', value: 'Infrared (IR)'),
        const ProductSpec(label: 'Display', value: 'High-contrast LCD screen'),
        const ProductSpec(
          label: 'Modes',
          value: 'Cool, Dry, Fan, Auto, Econo, Good Sleep',
        ),
      ],
      remoteType: 'Infrared (IR)',
      batteryType: '2 × AAA',
      compatibleModels: [
        'Daikin FTKM50',
        'Daikin FTKM35',
        'Daikin FTKL50',
        'Daikin FTHT50',
      ],
      tags: ['daikin', 'ac remote', 'inverter', 'econo', 'arc480a21'],
    ),

    ElectronicsProduct(
      id: 'rc_stb_tata',
      name: 'Tata Play HD Set-Top Box Universal Remote',
      category: ElectronicsCategory.remoteControls,
      subcategory: 'Set-Top Box Remotes',
      brand: 'Tata Play',
      modelNumber: 'Tata Play HD/Binge+ Universal Remote',
      description: 'Universal learning remote control for Tata Play (formerly Tata Sky) HD set-top boxes with TV learning capability for Power, Volume and AV source.',
      specifications: [
        const ProductSpec(label: 'Connectivity', value: 'Infrared (IR)'),
        const ProductSpec(
          label: 'Learning Keys',
          value: 'TV Power, Vol+, Vol-, Mute, TV/AV input',
        ),
        const ProductSpec(label: 'Battery', value: '2 × AAA batteries'),
      ],
      remoteType: 'Infrared (IR) with TV Learning',
      batteryType: '2 × AAA',
      compatibleModels: [
        'Tata Sky HD Box',
        'Tata Play HD Box',
        'Tata Play Binge+ 4K Android Box',
      ],
      tags: [
        'tata play',
        'tata sky',
        'set top box',
        'dth remote',
        'learning remote',
      ],
    ),

    ElectronicsProduct(
      id: 'rc_universal',
      name: 'Chunghop Universal TV/AC Learning Remote',
      category: ElectronicsCategory.remoteControls,
      subcategory: 'Universal Remotes',
      brand: 'Chunghop',
      modelNumber: 'RM-L1088 Universal',
      description: 'Multi-brand universal TV replacement remote compatible with over 100 TV brands including Sony, LG, Samsung, Panasonic, Philips, Haier, TCL, Mi, OnePlus and Vu.',
      specifications: [
        const ProductSpec(
          label: 'Brand Compatibility',
          value: '100+ global brands via Auto-Search or Code Table',
        ),
        const ProductSpec(
          label: 'Transmission',
          value: 'High-power wide-angle IR diode',
        ),
      ],
      remoteType: 'Universal Infrared',
      batteryType: '2 × AAA',
      compatibleModels: [
        'All Samsung, LG, Sony, Panasonic, Philips, Haier, Onida, Micromax, Mi TVs',
      ],
      tags: ['universal remote', 'multi-brand', 'tv remote', 'replacement'],
      isFeatured: true,
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 5. MOBILE ACCESSORIES
  // ═══════════════════════════════════════════════════════════════════════════
  static final List<ElectronicsProduct> _mobileAccessories = [
    ElectronicsProduct(
      id: 'ma_charger',
      name: '65W GaN Dual-Port Fast Charger',
      category: ElectronicsCategory.mobileAccessories,
      subcategory: 'Chargers',
      brand: 'Anker',
      modelNumber: '735 Charger (GaNPrime 65W)',
      description: 'Ultra-compact Gallium Nitride (GaN) high-speed wall charger featuring two USB-C ports and one USB-A port with PowerIQ 4.0 dynamic power distribution.',
      specifications: [
        const ProductSpec(label: 'Total Output', value: '65 Watts Max'),
        const ProductSpec(label: 'Ports', value: '2 × USB-C, 1 × USB-A'),
        const ProductSpec(
          label: 'Protocols',
          value: 'USB Power Delivery (PD 3.0), PPS, Quick Charge 4+',
        ),
      ],
      powerRating: '65W Max',
      tags: ['charger', 'fast charger', 'gan', '65w', 'anker', 'type-c'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ma_cable',
      name: '100W Braided USB-C to USB-C Cable',
      category: ElectronicsCategory.mobileAccessories,
      subcategory: 'USB Cables',
      brand: 'Baseus',
      modelNumber: 'Cafule 100W PD Cable (2m)',
      description: 'Heavy-duty nylon braided USB Type-C cable with embedded E-Marker smart chip supporting up to 100W (20V/5A) rapid charging and 480 Mbps data transfer.',
      specifications: [
        const ProductSpec(
          label: 'Max Power',
          value: '100 Watts (20V / 5A) with E-Marker Chip',
        ),
        const ProductSpec(label: 'Length', value: '2.0 metres (6.6 feet)'),
        const ProductSpec(
          label: 'Connector',
          value: 'Dual USB-C with zinc alloy shell',
        ),
      ],
      tags: ['usb-c cable', '100w', 'fast charging', 'braided', 'e-marker'],
    ),

    ElectronicsProduct(
      id: 'ma_powerbank',
      name: '20000 mAh 22.5W Fast Charging Power Bank',
      category: ElectronicsCategory.mobileAccessories,
      subcategory: 'Power Banks',
      brand: 'Xiaomi',
      modelNumber: 'Mi Power Bank 3i 20000mAh',
      description: 'High-capacity portable battery pack with triple port output, two-way 22.5W fast charging and 12-layer advanced circuit chip protection.',
      specifications: [
        const ProductSpec(
          label: 'Battery Capacity',
          value: '20,000 mAh / 74 Wh (Lithium Polymer)',
        ),
        const ProductSpec(
          label: 'Output Ports',
          value: '2 × USB-A (22.5W max), 1 × USB-C (22.5W max)',
        ),
        const ProductSpec(
          label: 'Input Ports',
          value: 'USB-C and Micro-USB (18W fast input)',
        ),
      ],
      tags: ['power bank', '20000mah', 'fast charge', 'mi', 'type-c'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ma_earphones',
      name: 'Type-C Hi-Res In-Ear Earphones',
      category: ElectronicsCategory.mobileAccessories,
      subcategory: 'Earphones',
      brand: 'OnePlus',
      modelNumber: 'Type-C Bullets Earphones',
      description: 'Direct digital audio earphones with built-in high-resolution DAC (Digital-to-Analog Converter) and in-line three-button mic controller.',
      specifications: [
        const ProductSpec(
          label: 'Connector',
          value: 'USB Type-C digital audio',
        ),
        const ProductSpec(label: 'Driver', value: '9.2mm dynamic driver'),
        const ProductSpec(
          label: 'DAC',
          value: 'Built-in 96kHz/24-bit HD audio DAC',
        ),
      ],
      tags: ['earphones', 'type-c', 'dac', 'in-ear', 'oneplus'],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 6. COMPUTER ACCESSORIES
  // ═══════════════════════════════════════════════════════════════════════════
  static final List<ElectronicsProduct> _computerAccessories = [
    ElectronicsProduct(
      id: 'ca_keyboard',
      name: 'Wireless Mechanical Keyboard',
      category: ElectronicsCategory.computerAccessories,
      subcategory: 'Keyboard',
      brand: 'Keychron',
      modelNumber: 'Keychron K2 (75% Layout)',
      description: 'Compact 84-key mechanical keyboard with Mac & Windows compatibility, Bluetooth 5.1 wireless + USB-C wired connection, and tactile Gateron G Pro Brown switches.',
      specifications: [
        const ProductSpec(label: 'Layout', value: '75% Compact (84 keys)'),
        const ProductSpec(
          label: 'Switches',
          value: 'Gateron G Pro Mechanical Brown (tactile)',
        ),
        const ProductSpec(
          label: 'Battery',
          value: '4000 mAh rechargeable li-polymer (up to 240 hrs)',
        ),
      ],
      tags: ['keyboard', 'mechanical', 'wireless', 'bluetooth', 'keychron'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ca_mouse',
      name: 'Wireless Ergonomic Performance Mouse',
      category: ElectronicsCategory.computerAccessories,
      subcategory: 'Mouse',
      brand: 'Logitech',
      modelNumber: 'MX Master 3S',
      description: 'Master series productivity mouse with 8,000 DPI Darkfield sensor that tracks on any surface including glass, Quiet Click switches, and MagSpeed electromagnetic scroll wheel.',
      specifications: [
        const ProductSpec(
          label: 'Sensor',
          value: 'Darkfield high precision (200–8000 DPI)',
        ),
        const ProductSpec(
          label: 'Scroll Wheel',
          value: 'MagSpeed electromagnetic smart-shift wheel',
        ),
        const ProductSpec(
          label: 'Battery Life',
          value: 'Up to 70 days on full charge (USB-C rechargeable)',
        ),
      ],
      tags: ['mouse', 'wireless', 'logitech', 'mx master 3s', 'ergonomic'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ca_monitor',
      name: '27" QHD 165Hz IPS Gaming Monitor',
      category: ElectronicsCategory.computerAccessories,
      subcategory: 'Monitor',
      brand: 'LG',
      modelNumber: 'UltraGear 27GP850-B',
      description: 'Ultra-responsive 27-inch 2560×1440 Nano IPS gaming display with 1ms GtG response time, 165Hz (O/C 180Hz) refresh rate, and NVIDIA G-SYNC / AMD FreeSync Premium support.',
      specifications: [
        const ProductSpec(label: 'Resolution', value: '2560 × 1440 (QHD / 2K)'),
        const ProductSpec(
          label: 'Panel & Color',
          value: 'Nano IPS, DCI-P3 98%, HDR400',
        ),
        const ProductSpec(
          label: 'Ports',
          value: '2 × HDMI 2.0, 1 × DisplayPort 1.4, USB 3.0 Hub',
        ),
      ],
      tags: ['monitor', '27 inch', 'qhd', '165hz', 'ips', 'gaming', 'lg'],
    ),

    ElectronicsProduct(
      id: 'ca_usb_hub',
      name: '7-in-1 USB-C Multiport Docking Hub',
      category: ElectronicsCategory.computerAccessories,
      subcategory: 'USB Hub',
      brand: 'Anker',
      modelNumber: '555 USB-C Hub (8-in-1)',
      description: 'Sleek aluminium expansion dock with 4K@60Hz HDMI video output, 100W Power Delivery pass-through, Gigabit Ethernet, SD card slots, and dual USB 3.2 10Gbps ports.',
      specifications: [
        const ProductSpec(label: 'HDMI Output', value: 'Up to 4K @ 60Hz'),
        const ProductSpec(
          label: 'Pass-Through Charging',
          value: 'Up to 100W USB-C PD input (85W to laptop)',
        ),
        const ProductSpec(
          label: 'Ethernet',
          value: '10/100/1000 Mbps Gigabit RJ45',
        ),
      ],
      tags: ['usb hub', 'dock', 'type-c', 'hdmi 4k', 'ethernet', 'anker'],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 7. ELECTRICAL PRODUCTS
  // ═══════════════════════════════════════════════════════════════════════════
  static final List<ElectronicsProduct> _electricalProducts = [
    ElectronicsProduct(
      id: 'ep_mcb',
      name: 'Single Pole C16 16A MCB',
      category: ElectronicsCategory.electricalProducts,
      subcategory: 'MCB (Miniature Circuit Breaker)',
      brand: 'Schneider Electric',
      modelNumber: 'Acti9 xC60 C16 1P',
      description: 'DIN-rail mounted thermal-magnetic circuit breaker that automatically protects electrical circuits from damage caused by overload and short-circuit faults.',
      workingPrinciple: 'Dual tripping mechanism: A bimetallic strip bends under prolonged thermal overload, while an electromagnetic solenoid rapidly pulls the trip latch during severe short-circuit currents.',
      specifications: [
        const ProductSpec(label: 'Rated Current (In)', value: '16 Amperes'),
        const ProductSpec(
          label: 'Tripping Curve',
          value: 'Type C (trips at 5–10 times rated current)',
        ),
        const ProductSpec(
          label: 'Breaking Capacity (Icn)',
          value: '10 kA at 240V AC (IEC 60898-1)',
        ),
        const ProductSpec(label: 'Poles', value: '1 Pole (1P) Single Phase'),
      ],
      voltageRange: '230V/240V AC',
      currentRating: '16A',
      tags: [
        'mcb',
        'circuit breaker',
        '16a',
        'schneider',
        'overload',
        'protection',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ep_rccb',
      name: '2-Pole 40A 30mA RCCB',
      category: ElectronicsCategory.electricalProducts,
      subcategory: 'RCCB (Residual Current Circuit Breaker)',
      brand: 'Havells',
      modelNumber: 'Euro-II 40A 30mA 2P',
      description: 'High-sensitivity human life protection device against lethal electric shocks and earth leakage electrical fires in residential and commercial buildings.',
      workingPrinciple: 'Toroidal core current balance: Continuously measures the net difference between Phase and Neutral current. An imbalance exceeding 30mA triggers a mechanical trip in under 30 milliseconds.',
      specifications: [
        const ProductSpec(label: 'Rated Current', value: '40 Amperes'),
        const ProductSpec(
          label: 'Sensitivity (IΔn)',
          value: '30 mA (Human shock protection standard)',
        ),
        const ProductSpec(
          label: 'Tripping Time',
          value: '< 30 ms at rated residual current',
        ),
        const ProductSpec(label: 'Poles', value: '2 Pole (Phase + Neutral)'),
      ],
      voltageRange: '240V AC',
      currentRating: '40A (30mA trip)',
      tags: [
        'rccb',
        'elcb',
        'earth leakage',
        'shock protection',
        '30ma',
        'havells',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ep_ups',
      name: '1100VA Line-Interactive Computer UPS',
      category: ElectronicsCategory.electricalProducts,
      subcategory: 'UPS',
      brand: 'APC by Schneider',
      modelNumber: 'Back-UPS BX1100C-IN',
      description: 'Automatic Voltage Regulation (AVR) battery backup power supply designed to protect desktop PCs, home Wi-Fi routers and consoles against blackouts and voltage fluctuations.',
      specifications: [
        const ProductSpec(label: 'Capacity', value: '1100 VA / 660 Watts'),
        const ProductSpec(
          label: 'Input Voltage Range',
          value: '140V to 300V AC with active AVR',
        ),
        const ProductSpec(
          label: 'Battery Type',
          value: 'Maintenance-free sealed lead-acid (12V 7.2Ah × 2)',
        ),
        const ProductSpec(
          label: 'Transfer Time',
          value: 'Under 10 milliseconds',
        ),
      ],
      powerRating: '660W (1100VA)',
      tags: [
        'ups',
        'battery backup',
        'inverter',
        'apc',
        'avr',
        'computer power',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'ep_stabilizer',
      name: 'Digital Automatic Voltage Stabilizer',
      category: ElectronicsCategory.electricalProducts,
      subcategory: 'Voltage Stabilizers',
      brand: 'V-Guard',
      modelNumber: 'V-Guard Magno 410 (for 1.5 Ton AC)',
      description: 'High-efficiency microcontrolled automatic voltage stabilizer with digital status display, high voltage cutoff and intelligent time delay system for inverter air conditioners.',
      specifications: [
        const ProductSpec(
          label: 'Capacity',
          value: '12 Amps (suitable for up to 1.5 Ton AC)',
        ),
        const ProductSpec(
          label: 'Working Range',
          value: '150V to 280V AC input (regulates to 200–240V)',
        ),
        const ProductSpec(
          label: 'Protection',
          value: 'High & low voltage cut-off, thermal overload',
        ),
      ],
      voltageRange: 'Input: 150V–280V AC',
      tags: [
        'stabilizer',
        'voltage stabilizer',
        'v-guard',
        'ac stabilizer',
        'safety',
      ],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 8. AUDIO & VIDEO DEVICES
  // ═══════════════════════════════════════════════════════════════════════════
  static final List<ElectronicsProduct> _audioVideo = [
    ElectronicsProduct(
      id: 'av_speaker',
      name: 'Portable Waterproof Bluetooth Speaker',
      category: ElectronicsCategory.audioVideo,
      subcategory: 'Speakers',
      brand: 'JBL',
      modelNumber: 'JBL Flip 6 (20W)',
      description: 'Rugged IP67 waterproof and dustproof portable Bluetooth 5.1 speaker with 2-way speaker system delivering crystal clear highs and punchy deep bass.',
      specifications: [
        const ProductSpec(
          label: 'Output Power',
          value: '20W RMS (woofer) + 10W RMS (tweeter)',
        ),
        const ProductSpec(
          label: 'Battery Life',
          value: 'Up to 12 hours playback (4800 mAh)',
        ),
        const ProductSpec(
          label: 'Waterproof Rating',
          value: 'IP67 waterproof and dustproof',
        ),
      ],
      powerRating: '30W Total System',
      tags: ['speaker', 'bluetooth', 'jbl', 'waterproof', 'portable audio'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'av_soundbar',
      name: '5.1 Channel Dolby Soundbar with Subwoofer',
      category: ElectronicsCategory.audioVideo,
      subcategory: 'Soundbars',
      brand: 'Sony',
      modelNumber: 'HT-S20R (400W)',
      description: 'Real 5.1 surround sound home cinema system with 3-channel soundbar, wired rear satellite speakers, external subwoofer, and HDMI ARC connectivity.',
      specifications: [
        const ProductSpec(label: 'Total Power Output', value: '400 Watts Peak'),
        const ProductSpec(
          label: 'Audio Channels',
          value: '5.1 Separate Channels (Dolby Digital)',
        ),
        const ProductSpec(
          label: 'Connectivity',
          value: 'HDMI ARC, Optical digital, Bluetooth 5.0, USB',
        ),
      ],
      powerRating: '400W',
      tags: [
        'soundbar',
        'sony',
        '5.1 channel',
        'dolby digital',
        'home theatre',
        'subwoofer',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'av_amplifier',
      name: 'Stereo Class-D Bluetooth Power Amplifier',
      category: ElectronicsCategory.audioVideo,
      subcategory: 'Amplifiers',
      brand: 'Fosi Audio',
      modelNumber: 'BT20A (100W × 2)',
      description: 'Audiophile mini Hi-Fi 2-channel power amplifier based on Texas Instruments TPA3116D2 chip with bass and treble tone control knobs.',
      specifications: [
        const ProductSpec(
          label: 'Max Power Output',
          value: '100 Watts per channel into 4Ω (200W total)',
        ),
        const ProductSpec(
          label: 'Audio Inputs',
          value: 'Bluetooth 5.0 & RCA analog stereo',
        ),
        const ProductSpec(label: 'THD & SNR', value: 'THD ≤ 0.04%, SNR ≥ 98dB'),
      ],
      powerRating: '200W Max',
      tags: ['amplifier', 'hifi', 'class-d', 'bluetooth audio', 'stereo'],
    ),

    ElectronicsProduct(
      id: 'av_mic',
      name: 'USB Studio Condenser Microphone',
      category: ElectronicsCategory.audioVideo,
      subcategory: 'Microphones',
      brand: 'Rode',
      modelNumber: 'NT-USB Mini',
      description: 'Studio-grade compact USB condenser microphone with directional cardioid pickup pattern and built-in headphone amplifier for zero-latency monitoring.',
      specifications: [
        const ProductSpec(
          label: 'Acoustic Principle',
          value: 'Pressure gradient electret condenser',
        ),
        const ProductSpec(
          label: 'Polar Pattern',
          value: 'Cardioid (directional)',
        ),
        const ProductSpec(
          label: 'Sample Rate',
          value: '48 kHz / 24-bit resolution',
        ),
      ],
      tags: ['microphone', 'condenser', 'usb mic', 'rode', 'studio recording'],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 9. SMART HOME DEVICES
  // ═══════════════════════════════════════════════════════════════════════════
  static final List<ElectronicsProduct> _smartHome = [
    ElectronicsProduct(
      id: 'sh_bulb',
      name: 'Wi-Fi RGB Smart LED Bulb',
      category: ElectronicsCategory.smartHome,
      subcategory: 'Smart Bulbs',
      brand: 'Philips',
      modelNumber: 'Philips Wiz 9W B22',
      description: 'Color-tunable 16-million-color Wi-Fi LED smart bulb with no bridge required. Works seamlessly with Google Assistant, Alexa, and Siri Shortcuts.',
      specifications: [
        const ProductSpec(
          label: 'Wattage',
          value: '9 Watts (806 lumens, equivalent to 60W bulb)',
        ),
        const ProductSpec(
          label: 'Base Fitting',
          value: 'B22 Bayonet pin (Indian Standard)',
        ),
        const ProductSpec(
          label: 'Color Temperature',
          value: '2200K to 6500K tunable white + 16M RGB',
        ),
        const ProductSpec(
          label: 'Wireless',
          value: 'Wi-Fi 2.4 GHz + Bluetooth setup',
        ),
      ],
      voltageRange: '220–240V AC',
      powerRating: '9W',
      tags: [
        'smart bulb',
        'philips',
        'rgb',
        'b22',
        'wifi',
        'alexa',
        'google home',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'sh_cctv',
      name: '360° 2K Pan/Tilt Wi-Fi Security Camera',
      category: ElectronicsCategory.smartHome,
      subcategory: 'CCTV Cameras',
      brand: 'TP-Link',
      modelNumber: 'Tapo C210 (2K 3MP)',
      description: 'Pan/tilt indoor smart security camera with 3MP 2K crystal-clear video, night vision up to 30 feet, AI person detection, two-way audio and MicroSD card storage up to 256GB.',
      specifications: [
        const ProductSpec(
          label: 'Video Resolution',
          value: '2K 3MP (2304 × 1296 pixels)',
        ),
        const ProductSpec(
          label: 'Pan & Tilt Range',
          value: '360° horizontal pan, 114° vertical tilt',
        ),
        const ProductSpec(
          label: 'Night Vision',
          value: '850 nm IR LED up to 30 ft (9m) in darkness',
        ),
        const ProductSpec(
          label: 'Audio',
          value: 'Two-way audio (built-in microphone & speaker)',
        ),
      ],
      voltageRange: '9V DC (adapter included)',
      tags: [
        'cctv',
        'camera',
        'ip camera',
        'wifi camera',
        'tapo',
        'security',
        '2k',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'sh_plug',
      name: '16A Smart Wi-Fi Power Plug',
      category: ElectronicsCategory.smartHome,
      subcategory: 'Smart Plugs',
      brand: 'TP-Link',
      modelNumber: 'Tapo P110 (16A Heavy Duty)',
      description: 'Heavy-duty smart plug capable of managing heavy electrical appliances like geysers, ACs and water heaters with real-time energy consumption monitoring.',
      specifications: [
        const ProductSpec(
          label: 'Max Load',
          value: '16 Amps, 3680 Watts peak load',
        ),
        const ProductSpec(
          label: 'Plug Type',
          value: 'Type D (Indian 3-Pin heavy gauge socket)',
        ),
        const ProductSpec(
          label: 'Energy Monitoring',
          value: 'Real-time wattage, historical kWh tracking',
        ),
      ],
      voltageRange: '220–240V AC',
      currentRating: '16A',
      tags: [
        'smart plug',
        '16a',
        'energy monitoring',
        'tapo',
        'wifi plug',
        'geyser',
      ],
    ),

    ElectronicsProduct(
      id: 'sh_switch',
      name: 'Smart Wi-Fi Touch Wall Switch Panel',
      category: ElectronicsCategory.smartHome,
      subcategory: 'Smart Switches',
      brand: 'Sonoff',
      modelNumber: 'Sonoff TX Series 2-Gang',
      description: 'Toughened glass touch wall panel replacing ordinary electrical switches with smartphone remote control, voice control and timer schedules.',
      specifications: [
        const ProductSpec(
          label: 'Gangs',
          value: '2-Gang Independent Touch Switches',
        ),
        const ProductSpec(
          label: 'Max Load',
          value: '2A per gang (400W LED / 600W Resistive)',
        ),
        const ProductSpec(
          label: 'Wiring Requirement',
          value: 'Live + Neutral wire required',
        ),
      ],
      tags: [
        'smart switch',
        'touch switch',
        'wifi switch',
        'sonoff',
        'home automation',
      ],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 10. NETWORKING DEVICES
  // ═══════════════════════════════════════════════════════════════════════════
  static final List<ElectronicsProduct> _networkingDevices = [
    ElectronicsProduct(
      id: 'nd_router',
      name: 'AX3000 Dual-Band Wi-Fi 6 Gigabit Router',
      category: ElectronicsCategory.networkingDevices,
      subcategory: 'Routers',
      brand: 'TP-Link',
      modelNumber: 'Archer AX55',
      description: 'Next-gen Wi-Fi 6 wireless router with speeds up to 2402 Mbps on 5GHz and 574 Mbps on 2.4GHz. Armed with Qualcomm dual-core CPU, 4 high-gain antennas and OFDMA technology.',
      workingPrinciple: 'Modulates digital data across 160MHz channels using 1024-QAM and multi-user MIMO (MU-MIMO) to transmit data to dozens of devices simultaneously without congestion.',
      specifications: [
        const ProductSpec(
          label: 'Speed Tier',
          value: 'AX3000 (2402 Mbps 5GHz + 574 Mbps 2.4GHz)',
        ),
        const ProductSpec(
          label: 'Ethernet Ports',
          value: '1 × Gigabit WAN port, 4 × Gigabit LAN ports',
        ),
        const ProductSpec(
          label: 'USB Support',
          value: '1 × USB 3.0 port for network attached storage',
        ),
        const ProductSpec(
          label: 'Security',
          value: 'WPA3 encryption, TP-Link HomeShield firewall',
        ),
      ],
      voltageRange: '12V DC 2A (adapter included)',
      tags: ['router', 'wifi6', 'ax3000', 'gigabit', 'tp-link', 'archer ax55'],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'nd_switch',
      name: '8-Port Gigabit Unmanaged Ethernet Switch',
      category: ElectronicsCategory.networkingDevices,
      subcategory: 'Network Switches',
      brand: 'D-Link',
      modelNumber: 'DGS-1008A',
      description: 'Plug-and-play desktop network switch providing 8 high-speed 10/100/1000 Mbps auto-sensing Gigabit ports for expanding home or office wired connections.',
      specifications: [
        const ProductSpec(
          label: 'Port Count',
          value: '8 × 10/100/1000 Mbps Gigabit RJ45 ports',
        ),
        const ProductSpec(
          label: 'Switching Capacity',
          value: '16 Gbps backplane bandwidth',
        ),
        const ProductSpec(
          label: 'Features',
          value: 'Auto MDI/MDIX crossover, IEEE 802.3x flow control',
        ),
      ],
      tags: [
        'network switch',
        'gigabit switch',
        '8 port',
        'ethernet',
        'd-link',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'nd_adapter',
      name: 'AC1300 High-Gain Dual-Band USB Wi-Fi Adapter',
      category: ElectronicsCategory.networkingDevices,
      subcategory: 'Wi-Fi Adapters',
      brand: 'TP-Link',
      modelNumber: 'Archer T3U Plus',
      description: 'USB 3.0 dual-band Wi-Fi dongle with external 5dBi adjustable high-gain antenna for powerful computer desktop wireless signal reception.',
      specifications: [
        const ProductSpec(
          label: 'Wireless Speed',
          value: '867 Mbps on 5GHz, 400 Mbps on 2.4GHz',
        ),
        const ProductSpec(label: 'Interface', value: 'USB 3.0 SuperSpeed'),
        const ProductSpec(
          label: 'Antenna',
          value: '180° multi-directional 5dBi antenna',
        ),
      ],
      tags: ['wifi adapter', 'usb wifi', 'dongle', 'tp-link', 'dual band'],
    ),

    ElectronicsProduct(
      id: 'nd_lan_cable',
      name: 'CAT6 High-Speed RJ45 Patch Cable (5m)',
      category: ElectronicsCategory.networkingDevices,
      subcategory: 'LAN Cables',
      brand: 'D-Link',
      modelNumber: 'NCB-C6UGRYR-5 (5m CAT6)',
      description: 'Factory-terminated 24 AWG pure copper twisted-pair network patch cable with gold-plated 50-micron RJ45 connectors for 1 Gbps / 10 Gbps networks.',
      specifications: [
        const ProductSpec(
          label: 'Cable Standard',
          value: 'Category 6 (CAT6, up to 250 MHz)',
        ),
        const ProductSpec(
          label: 'Conductor',
          value: '100% Bare Copper 24 AWG 4-pair UTP',
        ),
        const ProductSpec(label: 'Length', value: '5.0 Metres (16.4 ft)'),
      ],
      tags: ['lan cable', 'cat6', 'ethernet cable', 'rj45', 'networking'],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 11. CABLES & CONNECTORS
  // ═══════════════════════════════════════════════════════════════════════════
  static final List<ElectronicsProduct> _cablesConnectors = [
    ElectronicsProduct(
      id: 'cn_hdmi',
      name: 'Ultra High Speed HDMI 2.1 8K Cable (2m)',
      category: ElectronicsCategory.cablesConnectors,
      subcategory: 'HDMI Cables',
      brand: 'Belkin',
      modelNumber: 'AV10175bt2M-BLK',
      description: 'Certified Ultra High Speed HDMI 2.1 cable supporting 48 Gbps bandwidth for 8K@60Hz and 4K@120Hz gaming with Variable Refresh Rate (VRR) and eARC.',
      specifications: [
        const ProductSpec(
          label: 'Bandwidth',
          value: '48 Gbps (HDMI 2.1 Specification)',
        ),
        const ProductSpec(
          label: 'Resolution Support',
          value: '8K @ 60Hz, 4K @ 120Hz, Dynamic HDR, Dolby Vision',
        ),
        const ProductSpec(
          label: 'Audio Feature',
          value: 'Enhanced Audio Return Channel (eARC)',
        ),
      ],
      tags: [
        'hdmi',
        'hdmi 2.1',
        '8k',
        '4k 120hz',
        'belkin',
        'ps5',
        'gaming cable',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'cn_dp',
      name: 'DisplayPort 1.4 8K Monitor Cable (1.8m)',
      category: ElectronicsCategory.cablesConnectors,
      subcategory: 'DisplayPort Cables',
      brand: 'Cable Matters',
      modelNumber: '102025-1.8m',
      description: 'Gold-plated DisplayPort 1.4 male-to-male cable supporting HBR3 32.4 Gbps bandwidth for 8K@60Hz and high-refresh 4K@144Hz / 2K@240Hz monitors.',
      specifications: [
        const ProductSpec(
          label: 'DisplayPort Version',
          value: 'DisplayPort 1.4 (HBR3, 32.4 Gbps)',
        ),
        const ProductSpec(
          label: 'Resolutions',
          value: '8K @ 60Hz, 4K @ 144Hz, 2K @ 240Hz with HDR and DSC 1.2',
        ),
        const ProductSpec(
          label: 'Connector',
          value: 'Latching DisplayPort gold-plated connectors',
        ),
      ],
      tags: [
        'displayport',
        'dp cable',
        '144hz',
        '240hz',
        'gaming monitor',
        '8k',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'cn_usbc_cable',
      name: '240W USB4 / Thunderbolt 4 Cable (1m)',
      category: ElectronicsCategory.cablesConnectors,
      subcategory: 'USB-C Cables',
      brand: 'UGREEN',
      modelNumber: 'US535 (240W USB4)',
      description: 'Next-gen USB-C cable supporting maximum 240W Extended Power Range (EPR 48V/5A) fast charging and blazing 40 Gbps data transfer with single 8K@60Hz video.',
      specifications: [
        const ProductSpec(
          label: 'Power Delivery',
          value: '240 Watts (USB-PD 3.1 48V/5A EPR)',
        ),
        const ProductSpec(
          label: 'Data Speed',
          value: 'Up to 40 Gbps (Thunderbolt 4 / USB4)',
        ),
        const ProductSpec(
          label: 'Video',
          value: 'Supports single 8K@60Hz or dual 4K@60Hz display',
        ),
      ],
      tags: [
        'usb4',
        'thunderbolt 4',
        '240w',
        'type-c',
        'fast charging',
        '40gbps',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'cn_dc_jack',
      name: '5.5mm × 2.1mm DC Power Connector Cable',
      category: ElectronicsCategory.cablesConnectors,
      subcategory: 'DC Connectors',
      description: 'Standard male and female 5.5mm outer / 2.1mm inner diameter DC power pigtail cable jack for LED strips, CCTV cameras and electronics power supplies.',
      specifications: [
        const ProductSpec(
          label: 'Connector Size',
          value: '5.5mm (outer) × 2.1mm (inner barrel)',
        ),
        const ProductSpec(
          label: 'Voltage & Current',
          value: 'Up to 24V DC / 5A max',
        ),
      ],
      tags: [
        'dc jack',
        'barrel connector',
        '5.5x2.1mm',
        'cctv power',
        'led connector',
      ],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // 12. TOOLS & EQUIPMENT
  // ═══════════════════════════════════════════════════════════════════════════
  static final List<ElectronicsProduct> _toolsEquipment = [
    ElectronicsProduct(
      id: 'te_multimeter',
      name: 'Digital Pocket Multimeter',
      category: ElectronicsCategory.toolsEquipment,
      subcategory: 'Multimeters',
      brand: 'Fluke',
      modelNumber: 'Fluke 101',
      description: 'Legendary compact digital multimeter engineered by Fluke. Features CAT III 600V safety rating, auto-ranging 6000-count LCD, and measures AC/DC voltage, resistance, capacitance and frequency.',
      workingPrinciple: 'Dual-slope integration analog-to-digital converter (ADC) samples voltage and current across precision internal shunts with overload spark-gap protection.',
      specifications: [
        const ProductSpec(
          label: 'DC Voltage',
          value: '600.0 mV to 600.0 V (±0.5% + 3)',
        ),
        const ProductSpec(
          label: 'AC Voltage',
          value: '600.0 mV to 600.0 V (40 Hz to 500 Hz)',
        ),
        const ProductSpec(label: 'Resistance', value: '400.0 Ω to 40.00 MΩ'),
        const ProductSpec(label: 'Capacitance', value: '50.00 nF to 100.0 µF'),
        const ProductSpec(
          label: 'Safety Standard',
          value: 'IEC 61010-1 CAT III 600V',
        ),
      ],
      relatedProductIds: ['te_soldering', 'ec_resistor'],
      tags: [
        'multimeter',
        'fluke',
        'dmm',
        'voltage',
        'resistance',
        'cat3',
        'tester',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'te_soldering',
      name: '65W Digital Soldering Station',
      category: ElectronicsCategory.toolsEquipment,
      subcategory: 'Soldering Equipment',
      brand: 'Hakko',
      modelNumber: 'FX-888D',
      description: 'Professional temperature-adjustable digital soldering station with ceramic heating element, rapid 20-second thermal recovery, and digital password calibration.',
      workingPrinciple: 'Closed-loop sensor controls power delivered to the ceramic heater tip, maintaining set temperature within ±1°C even during heavy ground plane heat-sinking.',
      specifications: [
        const ProductSpec(label: 'Power Consumption', value: '65 Watts'),
        const ProductSpec(
          label: 'Temperature Range',
          value: '50°C to 480°C (120°F to 899°F)',
        ),
        const ProductSpec(
          label: 'Temperature Stability',
          value: '±1°C at idle',
        ),
        const ProductSpec(
          label: 'Tip Type',
          value: 'Hakko T18 series interchangeable tips',
        ),
      ],
      voltageRange: '230V AC Mains input',
      powerRating: '65W',
      relatedProductIds: ['te_multimeter', 'ec_breadboard'],
      tags: [
        'soldering station',
        'hakko',
        'fx888d',
        'solder',
        'pcb rework',
        '65w',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'te_oscilloscope',
      name: '4-Channel 50MHz Digital Storage Oscilloscope',
      category: ElectronicsCategory.toolsEquipment,
      subcategory: 'Oscilloscopes',
      brand: 'Rigol',
      modelNumber: 'DS1054Z (4-Channel 50MHz)',
      description: 'UltraVision digital storage oscilloscope featuring 4 analog channels, 1 GSa/s real-time sampling rate, deep 24 Mpts memory, and 7-inch WVGA color display.',
      workingPrinciple: 'Digitizes input signals via high-speed flash ADCs into acquisition memory, reconstructing waveforms with real-time waveform capture rate of 30,000 wfms/s.',
      specifications: [
        const ProductSpec(
          label: 'Channels & Bandwidth',
          value: '4 Channels, 50 MHz (upgradable to 100 MHz)',
        ),
        const ProductSpec(
          label: 'Real-Time Sample Rate',
          value: '1 GSa/s (single channel), 250 MSa/s (all channels)',
        ),
        const ProductSpec(
          label: 'Memory Depth',
          value: 'Up to 24 Mpts deep memory',
        ),
      ],
      tags: [
        'oscilloscope',
        'rigol',
        'ds1054z',
        '4 channel',
        'dso',
        'waveform',
      ],
      isFeatured: true,
    ),

    ElectronicsProduct(
      id: 'te_dc_psu',
      name: '30V 10A Adjustable Bench DC Power Supply',
      category: ElectronicsCategory.toolsEquipment,
      subcategory: 'Power Supplies',
      brand: 'Wanptek',
      modelNumber: 'WPS3010H',
      description: 'Precision variable DC bench laboratory power supply with 4-digit LED display for voltage, current and wattage with fine and coarse encoder adjustment knobs.',
      specifications: [
        const ProductSpec(
          label: 'Output Voltage',
          value: '0 to 30.00 Volts continuously adjustable',
        ),
        const ProductSpec(
          label: 'Output Current',
          value: '0 to 10.00 Amperes continuously adjustable',
        ),
        const ProductSpec(label: 'Output Power', value: '300 Watts Max'),
        const ProductSpec(
          label: 'Protection',
          value: 'Over-voltage (OVP), over-current (OCP), over-temperature',
        ),
      ],
      tags: [
        'bench power supply',
        'dc supply',
        '30v 10a',
        'lab power',
        'adjustable',
      ],
    ),

    ElectronicsProduct(
      id: 'te_wire_stripper',
      name: 'Automatic Self-Adjusting Wire Stripper',
      category: ElectronicsCategory.toolsEquipment,
      subcategory: 'Hand Tools',
      brand: 'Stanley',
      modelNumber: 'Stanley FatMax 0.2–6.0mm²',
      description: 'Heavy-duty self-adjusting wire stripper and crimper that automatically sizes to wire gauges from 10 to 24 AWG without nicking the copper core.',
      specifications: [
        const ProductSpec(
          label: 'Stripping Range',
          value: '0.2 mm² to 6.0 mm² (10–24 AWG wire)',
        ),
        const ProductSpec(
          label: 'Features',
          value: 'Integrated wire cutter & terminal crimper for 10–22 AWG',
        ),
      ],
      tags: ['wire stripper', 'stanley', 'crimper', 'hand tool', 'cutter'],
    ),
  ];
}
