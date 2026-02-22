import 'dart:typed_data';

import 'package:anx_reader/config/shared_preference_provider.dart';
import 'package:anx_reader/service/config/service_provider.dart';
import 'package:anx_reader/service/tts/models/tts_voice.dart';
import 'package:flutter/widgets.dart';

// Re-export ConfigItem for convenience
export 'package:anx_reader/service/config/config_item.dart';

// Forward declaration to avoid circular dependency
// ignore: unused_element
abstract class _TtsService {}

/// Base class for all TTS service providers.
abstract class TtsServiceProvider extends ServiceProvider<dynamic> {
  String get serviceId => service.toString().split('.').last;

  /// The display label for this service.
  @override
  String getLabel(BuildContext context);

  /// Generate speech audio from text.
  /// Modified to avoid immediate crash if not implemented.
  Future<Uint8List> speak(
      String text, String? voice, double rate, double pitch) async {
    // Si llegamos aquí, el servicio hijo no implementó la voz. 
    // Retornamos una lista vacía para evitar que la app se detenga bruscamente.
    debugPrint('Advertencia: speak() no implementado para $service');
    return Uint8List(0);
  }

  /// Get available voices for this TTS service.
  Future<List<TtsVoice>> getVoices() async {
    return [];
  }

  /// Convert voice data from API response to TtsVoice model.
  TtsVoice convertVoiceModel(dynamic voiceData) {
    // Retornamos un objeto básico para evitar el error de "Unimplemented"
    return TtsVoice(id: 'default', name: 'Default');
  }

  /// Get the currently selected voice for this service.
  String getSelectedVoice() {
    return Prefs().getTtsVoiceModel(serviceId);
  }

  /// Persist the selected voice for this service.
  void setSelectedVoice(String voice) {
    Prefs().setTtsVoiceModel(serviceId, voice);
  }

  /// Resolve the voice to use.
  String resolveVoice(String? voiceOverride) {
    if (voiceOverride != null && voiceOverride.isNotEmpty) {
      return voiceOverride;
    }
    final selected = getSelectedVoice();
    return selected.isNotEmpty ? selected : 'default';
  }
}
