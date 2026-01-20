import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../services/assets_provider.dart';
import '../../../../utils/extensions.dart';
import '../../../../utils/theme/ui_values.dart';

class PlayerLogoPicker extends StatefulWidget {
  const PlayerLogoPicker({
    super.key,
  });

  @override
  State<PlayerLogoPicker> createState() => _PickIconState();
}

class _PickIconState extends State<PlayerLogoPicker> {
  static const _totalLogosCount = 10;

  int choosenIcon = -1;

  Future<void> _selectLogo(int index) async {
    setState(() {
      choosenIcon = index;
    });

    await Future.delayed(const Duration(milliseconds: 500)).then(
      (_) {
        _pop(AssetsProvider.playerAssetByIndex(index));
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    if (await Permission.photos.request().isGranted) {
      final picker = ImagePicker();

      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();

        final fileName = path.basename(pickedFile.path);
        final savedImageFile = File('${appDir.path}/$fileName');

        // Decode, resize and save image
        final image = img.decodeImage(await pickedFile.readAsBytes());

        if (image != null) {
          final resizedImage = img.copyResize(
            image,
            height: 256,
            maintainAspect: true,
          );

          await savedImageFile.writeAsBytes(img.encodeJpg(resizedImage));
        } else {
          await File(pickedFile.path).copy(savedImageFile.path);
        }

        _pop(savedImageFile.path);
      }
    }
  }

  void _pop(String newLogo) => Navigator.of(context).pop(newLogo);

  @override
  Widget build(BuildContext context) => Dialog(
        elevation: 0,
        backgroundColor: context.theme.bgrColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: adaptiveOffset,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
        ),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(stdHorizontalOffset),
          height: stdDialogHeight * 1.2,
          width: stdButtonWidth,
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Center(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                reverse: false,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  crossAxisCount: 4,
                ),
                itemCount: _totalLogosCount + 1,
                itemBuilder: (context, index) {
                  if (index == _totalLogosCount) {
                    return GestureDetector(
                      onTap: () => _pickImageFromGallery(),
                      child: Padding(
                        padding: EdgeInsets.all(stdHorizontalOffset / 2),
                        child: Container(
                          height: stdButtonHeight,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1.5,
                              color: context.theme.primaryColor,
                            ),
                          ),
                          child: Icon(
                            Icons.add_a_photo,
                            color: context.theme.primaryColor,
                            size: stdIconSize,
                          ),
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () => _selectLogo(index),
                    child: Padding(
                      padding: EdgeInsets.all(stdHorizontalOffset / 2),
                      child: AnimatedContainer(
                        height: stdButtonHeight,
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: (index == choosenIcon) ? 1.5 : 0,
                            color: (index == choosenIcon)
                                ? context.theme.primaryColor
                                : context.theme.bgrColor,
                          ),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            filterQuality: FilterQuality.medium,
                            fit: BoxFit.cover,
                            image: AssetsProvider.playerIconByIndex(index),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
}
