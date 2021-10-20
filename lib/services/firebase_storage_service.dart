import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage _storage;
  Storage(this._storage);

  UploadTask uploadFileToFirebaseStorage(File _file, String filePath) {
    return _storage.ref().child(filePath).putFile(_file);
  }

  Future<String> getDownloadLinkofFile(String filePath) async {
    return await _storage.ref(filePath).getDownloadURL();
  }
}
