import '../entities/help_center_content.dart';

/// Kontrak sumber data halaman Pusat Bantuan.
abstract class HelpCenterRepository {
  Future<HelpCenterContent> fetchHelpCenterContent();
}
