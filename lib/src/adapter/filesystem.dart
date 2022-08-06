import 'dart:io';

import 'package:utopia_cache/src/adapter.dart';

class Filesystem implements Adapter<String> {
  final String path;

  Filesystem([this.path = '']);

  String _getPath(String filename) {
    var path = '';

    for (var i = 0; i < 4; i++) {
      path = (i < filename.length)
          ? path + Platform.pathSeparator + filename.substring(i, i + 1)
          : '$path${Platform.pathSeparator}x';
    }
    return this.path + path + Platform.pathSeparator + filename;
  }

  @override
  Future<String?> load(String key, [Duration? ttl]) async {
    final file = File(_getPath(key));
    if (await file.exists()) {
      if (ttl != null &&
          file.lastModifiedSync().millisecondsSinceEpoch +
                  (ttl.inSeconds * 1000) <
              DateTime.now().millisecondsSinceEpoch) return null;
      return file.readAsString();
    }
    return null;
  }

  @override
  Future<void> purge(String key) async {
    final file = File(_getPath(key));
    if (file.existsSync()) {
      await file.delete();
    }
  }

  @override
  Future<void> save(String key, String data) async {
    final file = File(_getPath(key));

    if (!file.existsSync()) {
      try {
        file.createSync(recursive: true);
      } catch (e) {
        throw Exception('Can\'t create file ${file.path}');
      }
    }
    file.writeAsStringSync(data);
  }

  @override
  Future<void> close() async {
    throw UnimplementedError();
  }
}
