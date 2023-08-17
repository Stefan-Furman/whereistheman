import 'package:audioplayers/audioplayers.dart';

class Audio{
  static final player = AudioCache();

  static void init() {
    player.load("mixkit-long-pop-2358.wav");
    player.load("zapsplat_sound_design_transition_whoosh_very_fast_airy_001_74594.mp3");
    player.load("mixkit-message-pop-alert-2354.mp3");
  }


  static var message = () => player.play("mixkit-message-pop-alert-2354.mp3");
  static var navigation = () => player.play("zapsplat_sound_design_transition_whoosh_very_fast_airy_001_74594.mp3");
  static var snackbar = () => player.play("mixkit-long-pop-2358.wav");
}