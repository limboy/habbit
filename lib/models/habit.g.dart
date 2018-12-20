// GENERATED CODE - DO NOT MODIFY BY HAND

part of habit;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Habit> _$habitSerializer = new _$HabitSerializer();

class _$HabitSerializer implements StructuredSerializer<Habit> {
  @override
  final Iterable<Type> types = const [Habit, _$Habit];
  @override
  final String wireName = 'Habit';

  @override
  Iterable serialize(Serializers serializers, Habit object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'title',
      serializers.serialize(object.title,
          specifiedType: const FullType(String)),
      'created',
      serializers.serialize(object.created, specifiedType: const FullType(int)),
    ];
    if (object.habitID != null) {
      result
        ..add('habitID')
        ..add(serializers.serialize(object.habitID,
            specifiedType: const FullType(int)));
    }
    if (object.isSelected != null) {
      result
        ..add('isSelected')
        ..add(serializers.serialize(object.isSelected,
            specifiedType: const FullType(bool)));
    }

    return result;
  }

  @override
  Habit deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new HabitBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'habitID':
          result.habitID = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'created':
          result.created = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'isSelected':
          result.isSelected = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Habit extends Habit {
  @override
  final int habitID;
  @override
  final String title;
  @override
  final int created;
  @override
  final bool isSelected;

  factory _$Habit([void updates(HabitBuilder b)]) =>
      (new HabitBuilder()..update(updates)).build();

  _$Habit._({this.habitID, this.title, this.created, this.isSelected})
      : super._() {
    if (title == null) {
      throw new BuiltValueNullFieldError('Habit', 'title');
    }
    if (created == null) {
      throw new BuiltValueNullFieldError('Habit', 'created');
    }
  }

  @override
  Habit rebuild(void updates(HabitBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  HabitBuilder toBuilder() => new HabitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Habit &&
        habitID == other.habitID &&
        title == other.title &&
        created == other.created &&
        isSelected == other.isSelected;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, habitID.hashCode), title.hashCode), created.hashCode),
        isSelected.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Habit')
          ..add('habitID', habitID)
          ..add('title', title)
          ..add('created', created)
          ..add('isSelected', isSelected))
        .toString();
  }
}

class HabitBuilder implements Builder<Habit, HabitBuilder> {
  _$Habit _$v;

  int _habitID;
  int get habitID => _$this._habitID;
  set habitID(int habitID) => _$this._habitID = habitID;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  int _created;
  int get created => _$this._created;
  set created(int created) => _$this._created = created;

  bool _isSelected;
  bool get isSelected => _$this._isSelected;
  set isSelected(bool isSelected) => _$this._isSelected = isSelected;

  HabitBuilder();

  HabitBuilder get _$this {
    if (_$v != null) {
      _habitID = _$v.habitID;
      _title = _$v.title;
      _created = _$v.created;
      _isSelected = _$v.isSelected;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Habit other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Habit;
  }

  @override
  void update(void updates(HabitBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Habit build() {
    final _$result = _$v ??
        new _$Habit._(
            habitID: habitID,
            title: title,
            created: created,
            isSelected: isSelected);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
