import 'dart:io';

Future<void> check(String path) async {
  final lib = Directory(path);
  final files = <File>[];
  final directories = <Directory>[];
  for (final el in lib.listSync()) {
    if (el is File) {
      files.add(el);
    } else if (el is Directory) {
      directories.add(el);
    } else {
      print('WARNING: lib contains not only files and directories');
    }
  }
  if (!(await _checkFiles(files)) || !(await _checkDirectories(directories))) {
    exit(-1);
  }
}

Future<bool> _checkFiles(List<File> files) async {
  final res = files.length == 1 && files.first.path.endsWith('main.dart');
  if (res) {
    print('DONE: main.dart was found');
  } else {
    print('ERROR: main.dart was not found');
  }
  return res;
}

Future<bool> _checkDirectories(List<Directory> directories) async {
  bool hasErrors = false;
  for (final dir in directories) {
    final path = dir.path;
    final files = dir.listSync();
    if (path.endsWith('di')) {
      print('INFO: di folder was found');
      if (files.length != 1) {
        print('ERROR: di folder structure is not valid');
        hasErrors = true;
        if (files.isNotEmpty && !files.first.path.endsWith('app_dependencies.dart')) {
          print('  --- MSG: app_dependencies.dart was not found');
        } else {
          print('  --- MSG: no files found');
        }
      }
    } else if (path.endsWith('ui')) {
      print('INFO: ui folder was found');
    } else if (path.endsWith('extensions')) {
      print('INFO: extensions folder was found');
      for (final ext in files) {
        if (!ext.path.endsWith('_extensions.dart')) {
          hasErrors = true;
          print('  --- MSG: incorrect extension file name ${ext.path}');
        }
      }
    } else if (path.endsWith('model')) {
      print('INFO: model folder was found');
    } else if (path.endsWith('pages')) {
      print('INFO: pages folder was found');
    } else if (path.endsWith('domain')) {
      print('INFO: domain folder was found');
    } else {
      print('ERROR: find non declare folder $path');
      hasErrors = true;
    }
  }
  return !hasErrors;
}
