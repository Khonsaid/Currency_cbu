import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static String language = 'lang';

  static Future<void> init() async {
    final dir = await getApplicationCacheDirectory();
    Hive.init(dir.path);

    await Hive.openBox<String>(language);
  }

  static void set(String lang) {
    final box = Hive.box<String>(language);
    box.put(0, lang);
  }

  static String get() {
    final box = Hive.box<String>(language);
    if (box.isEmpty) return 'uz';
    return box.getAt(0) ?? 'uz';
  }
}
