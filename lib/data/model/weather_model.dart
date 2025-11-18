import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tasks/core/utils/json_converter.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

@freezed
abstract class WeatherModel with _$WeatherModel {
  const factory WeatherModel({
    @JsonKey(name: 'temperature_2m') required num temperature,
    @JsonKey(name: 'wind_speed_10m') required num windSpeed,
    @JsonKey(name: 'weather_code', fromJson: convertWeatherCode)
    required String weatherDescription,
    @JsonKey(name: 'is_day') required num isDay,
    @JsonKey(fromJson: convertToDateTime, toJson: convertToTimeString) required DateTime time,
  }) = _WeatherModel;

  factory WeatherModel.fromJson(Map<String, Object?> json) =>
      _$WeatherModelFromJson(json);
}

