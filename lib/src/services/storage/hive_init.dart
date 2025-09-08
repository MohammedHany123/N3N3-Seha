import 'package:hive_flutter/hive_flutter.dart';

Future<void> initializeHiveStorage() async {
  await Hive.initFlutter();
  // Register adapters here when models are added.
}


