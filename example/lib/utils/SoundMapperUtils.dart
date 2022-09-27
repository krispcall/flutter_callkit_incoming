import "package:mvp/viewObject/model/sound/Sound.dart";
import "package:mvp/viewObject/model/sound/Sounds.dart";

class SoundMapperUtils {
  static Sound? getSelectedSound(String selectedSound) {
    Sound? selected;
    final List<Sound?> elements =
        soundsList.map((json) => Sound().fromJson(json)).toList();
    if (selectedSound == null) {
      return elements[0];
    }

    for (final element in elements) {
      if (selectedSound
          .toLowerCase()
          .contains(element!.assetUrl!.toLowerCase())) {
        selected = element;
      }
    }
    return selected;
  }

  static List<Sound?> getSoundsList() {
    return soundsList.map((json) => Sound().fromJson(json)).toList();
  }
}
