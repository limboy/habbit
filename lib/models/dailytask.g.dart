// GENERATED CODE - DO NOT MODIFY BY HAND

part of dailytask;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DailyTaskStatus _$completed = const DailyTaskStatus._('completed');
const DailyTaskStatus _$skipped = const DailyTaskStatus._('skipped');
const DailyTaskStatus _$failed = const DailyTaskStatus._('failed');

DailyTaskStatus _$dtsValueOf(String name) {
  switch (name) {
    case 'completed':
      return _$completed;
    case 'skipped':
      return _$skipped;
    case 'failed':
      return _$failed;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<DailyTaskStatus> _$dtsValues =
    new BuiltSet<DailyTaskStatus>(const <DailyTaskStatus>[
  _$completed,
  _$skipped,
  _$failed,
]);

Serializer<DailyTaskStatus> _$dailyTaskStatusSerializer =
    new _$DailyTaskStatusSerializer();
Serializer<DailyTask> _$dailyTaskSerializer = new _$DailyTaskSerializer();

class _$DailyTaskStatusSerializer
    implements PrimitiveSerializer<DailyTaskStatus> {
  @override
  final Iterable<Type> types = const <Type>[DailyTaskStatus];
  @override
  final String wireName = 'DailyTaskStatus';

  @override
  Object serialize(Serializers serializers, DailyTaskStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  DailyTaskStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DailyTaskStatus.valueOf(serialized as String);
}

class _$DailyTaskSerializer implements StructuredSerializer<DailyTask> {
  @override
  final Iterable<Type> types = const [DailyTask, _$DailyTask];
  @override
  final String wireName = 'DailyTask';

  @override
  Iterable serialize(Serializers serializers, DailyTask object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'seq',
      serializers.serialize(object.seq, specifiedType: const FullType(int)),
    ];
    if (object.habitID != null) {
      result
        ..add('habitID')
        ..add(serializers.serialize(object.habitID,
            specifiedType: const FullType(int)));
    }
    if (object.status != null) {
      result
        ..add('status')
        ..add(serializers.serialize(object.status,
            specifiedType: const FullType(DailyTaskStatus)));
    }
    if (object.isToday != null) {
      result
        ..add('isToday')
        ..add(serializers.serialize(object.isToday,
            specifiedType: const FullType(bool)));
    }
    if (object.isYesterday != null) {
      result
        ..add('isYesterday')
        ..add(serializers.serialize(object.isYesterday,
            specifiedType: const FullType(bool)));
    }
    if (object.isSelected != null) {
      result
        ..add('isSelected')
        ..add(serializers.serialize(object.isSelected,
            specifiedType: const FullType(bool)));
    }
    if (object.isFuture != null) {
      result
        ..add('isFuture')
        ..add(serializers.serialize(object.isFuture,
            specifiedType: const FullType(bool)));
    }

    return result;
  }

  @override
  DailyTask deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DailyTaskBuilder();

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
        case 'status':
          result.status = serializers.deserialize(value,
                  specifiedType: const FullType(DailyTaskStatus))
              as DailyTaskStatus;
          break;
        case 'seq':
          result.seq = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'isToday':
          result.isToday = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'isYesterday':
          result.isYesterday = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'isSelected':
          result.isSelected = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'isFuture':
          result.isFuture = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$DailyTask extends DailyTask {
  @override
  final int habitID;
  @override
  final DailyTaskStatus status;
  @override
  final int seq;
  @override
  final bool isToday;
  @override
  final bool isYesterday;
  @override
  final bool isSelected;
  @override
  final bool isFuture;

  factory _$DailyTask([void updates(DailyTaskBuilder b)]) =>
      (new DailyTaskBuilder()..update(updates)).build();

  _$DailyTask._(
      {this.habitID,
      this.status,
      this.seq,
      this.isToday,
      this.isYesterday,
      this.isSelected,
      this.isFuture})
      : super._() {
    if (seq == null) {
      throw new BuiltValueNullFieldError('DailyTask', 'seq');
    }
  }

  @override
  DailyTask rebuild(void updates(DailyTaskBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  DailyTaskBuilder toBuilder() => new DailyTaskBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DailyTask &&
        habitID == other.habitID &&
        status == other.status &&
        seq == other.seq &&
        isToday == other.isToday &&
        isYesterday == other.isYesterday &&
        isSelected == other.isSelected &&
        isFuture == other.isFuture;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, habitID.hashCode), status.hashCode),
                        seq.hashCode),
                    isToday.hashCode),
                isYesterday.hashCode),
            isSelected.hashCode),
        isFuture.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DailyTask')
          ..add('habitID', habitID)
          ..add('status', status)
          ..add('seq', seq)
          ..add('isToday', isToday)
          ..add('isYesterday', isYesterday)
          ..add('isSelected', isSelected)
          ..add('isFuture', isFuture))
        .toString();
  }
}

class DailyTaskBuilder implements Builder<DailyTask, DailyTaskBuilder> {
  _$DailyTask _$v;

  int _habitID;
  int get habitID => _$this._habitID;
  set habitID(int habitID) => _$this._habitID = habitID;

  DailyTaskStatus _status;
  DailyTaskStatus get status => _$this._status;
  set status(DailyTaskStatus status) => _$this._status = status;

  int _seq;
  int get seq => _$this._seq;
  set seq(int seq) => _$this._seq = seq;

  bool _isToday;
  bool get isToday => _$this._isToday;
  set isToday(bool isToday) => _$this._isToday = isToday;

  bool _isYesterday;
  bool get isYesterday => _$this._isYesterday;
  set isYesterday(bool isYesterday) => _$this._isYesterday = isYesterday;

  bool _isSelected;
  bool get isSelected => _$this._isSelected;
  set isSelected(bool isSelected) => _$this._isSelected = isSelected;

  bool _isFuture;
  bool get isFuture => _$this._isFuture;
  set isFuture(bool isFuture) => _$this._isFuture = isFuture;

  DailyTaskBuilder();

  DailyTaskBuilder get _$this {
    if (_$v != null) {
      _habitID = _$v.habitID;
      _status = _$v.status;
      _seq = _$v.seq;
      _isToday = _$v.isToday;
      _isYesterday = _$v.isYesterday;
      _isSelected = _$v.isSelected;
      _isFuture = _$v.isFuture;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DailyTask other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DailyTask;
  }

  @override
  void update(void updates(DailyTaskBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$DailyTask build() {
    final _$result = _$v ??
        new _$DailyTask._(
            habitID: habitID,
            status: status,
            seq: seq,
            isToday: isToday,
            isYesterday: isYesterday,
            isSelected: isSelected,
            isFuture: isFuture);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
