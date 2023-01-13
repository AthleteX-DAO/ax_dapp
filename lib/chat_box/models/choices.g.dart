// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'choices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Choice _$ChoiceFromJson(Map<String, dynamic> json) => Choice(
      text: json['text'] as String,
      index: json['index'] as int,
      finishReason: json['finish_reason'] as String,
    );

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
      'text': instance.text,
      'index': instance.index,
      'finish_reason': instance.finishReason,
    };
