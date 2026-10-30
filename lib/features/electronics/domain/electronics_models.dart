/// Electronics product domain models.
/// Designed for future backend API integration (Node.js + MySQL).
/// All technical specifications use only verified, general reference data.
library;

// ── Main Category Enum ────────────────────────────────────────────────────────
enum ElectronicsCategory {
  electronicComponents,
  computerComponents,
  laptopComponents,
  remoteControls,
  mobileAccessories,
  computerAccessories,
  electricalProducts,
  audioVideo,
  smartHome,
  networkingDevices,
  cablesConnectors,
  toolsEquipment,
}

extension ElectronicsCategoryX on ElectronicsCategory {
  String get label {
    switch (this) {
      case ElectronicsCategory.electronicComponents:
        return 'Electronic Components';
      case ElectronicsCategory.computerComponents:
        return 'Computer Components';
      case ElectronicsCategory.laptopComponents:
        return 'Laptop Components';
      case ElectronicsCategory.remoteControls:
        return 'Remote Controls';
      case ElectronicsCategory.mobileAccessories:
        return 'Mobile Accessories';
      case ElectronicsCategory.computerAccessories:
        return 'Computer Accessories';
      case ElectronicsCategory.electricalProducts:
        return 'Electrical Products';
      case ElectronicsCategory.audioVideo:
        return 'Audio & Video';
      case ElectronicsCategory.smartHome:
        return 'Smart Home';
      case ElectronicsCategory.networkingDevices:
        return 'Networking Devices';
      case ElectronicsCategory.cablesConnectors:
        return 'Cables & Connectors';
      case ElectronicsCategory.toolsEquipment:
        return 'Tools & Equipment';
    }
  }

  String get iconAsset {
    switch (this) {
      case ElectronicsCategory.electronicComponents:
        return '⚡';
      case ElectronicsCategory.computerComponents:
        return '🖥️';
      case ElectronicsCategory.laptopComponents:
        return '💻';
      case ElectronicsCategory.remoteControls:
        return '📱';
      case ElectronicsCategory.mobileAccessories:
        return '🔌';
      case ElectronicsCategory.computerAccessories:
        return '🖱️';
      case ElectronicsCategory.electricalProducts:
        return '🔋';
      case ElectronicsCategory.audioVideo:
        return '🔊';
      case ElectronicsCategory.smartHome:
        return '🏠';
      case ElectronicsCategory.networkingDevices:
        return '📶';
      case ElectronicsCategory.cablesConnectors:
        return '🔗';
      case ElectronicsCategory.toolsEquipment:
        return '🔧';
    }
  }

  String get description {
    switch (this) {
      case ElectronicsCategory.electronicComponents:
        return 'Resistors, capacitors, ICs, transistors, sensors and more';
      case ElectronicsCategory.computerComponents:
        return 'CPUs, GPUs, RAM, SSDs, motherboards and power supplies';
      case ElectronicsCategory.laptopComponents:
        return 'Laptop parts, batteries, screens, keyboards and adapters';
      case ElectronicsCategory.remoteControls:
        return 'TV, AC, STB, Smart TV and universal remote controls';
      case ElectronicsCategory.mobileAccessories:
        return 'Chargers, cables, power banks, headphones and cases';
      case ElectronicsCategory.computerAccessories:
        return 'Keyboards, mice, monitors, hubs and cooling solutions';
      case ElectronicsCategory.electricalProducts:
        return 'Switches, MCBs, wires, extension boards and UPS';
      case ElectronicsCategory.audioVideo:
        return 'Speakers, amplifiers, projectors and soundbars';
      case ElectronicsCategory.smartHome:
        return 'Smart bulbs, CCTV, smart plugs and security devices';
      case ElectronicsCategory.networkingDevices:
        return 'Routers, modems, switches and Wi-Fi adapters';
      case ElectronicsCategory.cablesConnectors:
        return 'USB, HDMI, power cables and multi-connectors';
      case ElectronicsCategory.toolsEquipment:
        return 'Multimeters, soldering irons and testing equipment';
    }
  }
}

// ── Specification Entry ───────────────────────────────────────────────────────
class ProductSpec {
  final String label;
  final String value;

  const ProductSpec({required this.label, required this.value});
}

// ── Product Model ─────────────────────────────────────────────────────────────
class ElectronicsProduct {
  final String id;
  final String name;
  final ElectronicsCategory category;
  final String subcategory;
  final String? brand;
  final String? modelNumber;
  final String description;
  final String workingPrinciple;
  final List<String> applications;
  final List<String> advantages;
  final List<ProductSpec> specifications;
  final String? voltageRange;
  final String? currentRating;
  final String? powerRating;
  final String? pinConfiguration;
  final String? compatibility;
  final String? datasheetUrl;
  final String? manufacturerUrl;
  final List<String> relatedProductIds;
  final List<String> tags;
  final List<String> compatibleModels; // for remotes
  final String? remoteType; // IR / RF / Bluetooth
  final String? batteryType;
  final List<String> laptopBrands; // for laptop components
  final String? imageAsset;
  final bool isFeatured;

  const ElectronicsProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.subcategory,
    this.brand,
    this.modelNumber,
    required this.description,
    this.workingPrinciple = '',
    this.imageAsset,
    this.applications = const [],
    this.advantages = const [],
    this.specifications = const [],
    this.voltageRange,
    this.currentRating,
    this.powerRating,
    this.pinConfiguration,
    this.compatibility,
    this.datasheetUrl,
    this.manufacturerUrl,
    this.relatedProductIds = const [],
    this.tags = const [],
    this.compatibleModels = const [],
    this.remoteType,
    this.batteryType,
    this.laptopBrands = const [],
    this.isFeatured = false,
  });

  bool matchesSearch(String query) {
    final q = query.toLowerCase();
    return name.toLowerCase().contains(q) ||
        subcategory.toLowerCase().contains(q) ||
        (brand?.toLowerCase().contains(q) ?? false) ||
        (modelNumber?.toLowerCase().contains(q) ?? false) ||
        description.toLowerCase().contains(q) ||
        tags.any((t) => t.toLowerCase().contains(q)) ||
        compatibleModels.any((m) => m.toLowerCase().contains(q));
  }
}
