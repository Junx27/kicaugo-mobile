import '../../domain/entities/help_center_content.dart';

/// Kontrak sumber data Pusat Bantuan (demo atau API).
abstract class HelpCenterDataSource {
  Future<HelpCenterContent> fetchHelpCenterContent();
}
