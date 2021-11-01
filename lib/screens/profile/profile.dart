import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/components/snackbar.dart';
import 'package:flutter101/services/firebase_storage_service.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _profilePhoto;
  bool isUploading = false;
  double _progress = 0;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile Page',
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            ),
            tooltip: 'Go to cart page',
          ),
        ),
        body: Center(
          child: Container(
            color: Colors.deepPurple,
            child: Stack(children: [
              Positioned(
                top: 0,
                left: 0,
                child: Center(
                  child: Container(
                    child: _profilePhoto != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 20),
                            child: ClipOval(
                              child: Image.file(_profilePhoto!,
                                  width: width, height: 400, fit: BoxFit.cover),
                            ),
                          )
                        : SizedBox(
                            width: width,
                            height: 400,
                            child: isUploading
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const CircularProgressIndicator(),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        '$_progress %',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      )
                                    ],
                                  )
                                : const Center(
                                    child: Text(
                                        'upload OR click Image to Update your Profile Pic'),
                                  ),
                          ),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2,
                            offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)),
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 450,
                left: width / 2 - 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        iconSize: 34,
                        onPressed: () => pickImage(context, false),
                        icon: const Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.white,
                        )),
                    IconButton(
                        iconSize: 34,
                        onPressed: () => pickImage(context, true),
                        icon: const Icon(
                          Icons.upload_file,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }

  void pickImage(BuildContext context, bool isGalary) async {
    final pickedImage = await ImagePicker()
        .pickImage(source: isGalary ? ImageSource.gallery : ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        isUploading = true;
      });
      String uid = Provider.of<User>(context, listen: false).uid;

      var task = Provider.of<Storage>(context, listen: false)
          .uploadFileToFirebaseStorage(
              File(pickedImage.path), 'profilePhotos/$uid.png');

      task.snapshotEvents.listen(
        (snapshot) {
          debugPrint('Task state: ${snapshot.state}');
          debugPrint(
              'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
          setState(() {
            _progress =
                (snapshot.bytesTransferred / snapshot.totalBytes).round() * 100;
          });
        },
        onError: (e) {
          if (e.code == 'permission-denied') {
            print('User does not have permission to upload to this reference.');
          }
        },
      );

      task.whenComplete(() async {
        try {
          String url = await task.snapshot.ref.getDownloadURL();

          await Provider.of<FireStoreService>(context, listen: false)
              .updateProfilePhoto(uid, url);
          setState(() {
            isUploading = false;
            _profilePhoto = File(pickedImage.path);
          });
        } catch (e) {
          return const CustomSnackBar(
                  seconds: 2,
                  text: 'Something went wrong in image upload try again !',
                  type: 'error')
              .show(context);
        }

        return const CustomSnackBar(
                seconds: 2,
                text: 'image uploaded successfully',
                type: 'success')
            .show(context);
      });
    }
    // else {
    //   const CustomSnackBar(
    //           seconds: 2, text: 'No image is selected, try ga', type: 'error')
    //       .show(context);
    // }
  }
}
