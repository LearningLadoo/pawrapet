// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificationMessage.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationMessageCollection on Isar {
  IsarCollection<NotificationMessage> get notificationMessages =>
      this.collection();
}

const NotificationMessageSchema = CollectionSchema(
  name: r'NotificationMessage',
  id: 3295979118857253532,
  properties: {
    r'data': PropertySchema(
      id: 0,
      name: r'data',
      type: IsarType.string,
    ),
    r'profileID': PropertySchema(
      id: 1,
      name: r'profileID',
      type: IsarType.long,
    ),
    r'removed': PropertySchema(
      id: 2,
      name: r'removed',
      type: IsarType.bool,
    ),
    r'seen': PropertySchema(
      id: 3,
      name: r'seen',
      type: IsarType.bool,
    )
  },
  estimateSize: _notificationMessageEstimateSize,
  serialize: _notificationMessageSerialize,
  deserialize: _notificationMessageDeserialize,
  deserializeProp: _notificationMessageDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _notificationMessageGetId,
  getLinks: _notificationMessageGetLinks,
  attach: _notificationMessageAttach,
  version: '3.1.0',
);

int _notificationMessageEstimateSize(
  NotificationMessage object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.data.length * 3;
  return bytesCount;
}

void _notificationMessageSerialize(
  NotificationMessage object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.data);
  writer.writeLong(offsets[1], object.profileID);
  writer.writeBool(offsets[2], object.removed);
  writer.writeBool(offsets[3], object.seen);
}

NotificationMessage _notificationMessageDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationMessage(
    data: reader.readString(offsets[0]),
    id: id,
    profileID: reader.readLongOrNull(offsets[1]),
    removed: reader.readBoolOrNull(offsets[2]) ?? false,
    seen: reader.readBoolOrNull(offsets[3]) ?? false,
  );
  return object;
}

P _notificationMessageDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationMessageGetId(NotificationMessage object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _notificationMessageGetLinks(
    NotificationMessage object) {
  return [];
}

void _notificationMessageAttach(
    IsarCollection<dynamic> col, Id id, NotificationMessage object) {
  object.id = id;
}

extension NotificationMessageQueryWhereSort
    on QueryBuilder<NotificationMessage, NotificationMessage, QWhere> {
  QueryBuilder<NotificationMessage, NotificationMessage, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationMessageQueryWhere
    on QueryBuilder<NotificationMessage, NotificationMessage, QWhereClause> {
  QueryBuilder<NotificationMessage, NotificationMessage, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NotificationMessageQueryFilter on QueryBuilder<NotificationMessage,
    NotificationMessage, QFilterCondition> {
  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      dataEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      dataGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      dataLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      dataBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'data',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      dataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      dataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      dataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'data',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      dataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'data',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      dataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      dataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'data',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      profileIDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'profileID',
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      profileIDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'profileID',
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      profileIDEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileID',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      profileIDGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profileID',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      profileIDLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profileID',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      profileIDBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profileID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      removedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'removed',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterFilterCondition>
      seenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seen',
        value: value,
      ));
    });
  }
}

extension NotificationMessageQueryObject on QueryBuilder<NotificationMessage,
    NotificationMessage, QFilterCondition> {}

extension NotificationMessageQueryLinks on QueryBuilder<NotificationMessage,
    NotificationMessage, QFilterCondition> {}

extension NotificationMessageQuerySortBy
    on QueryBuilder<NotificationMessage, NotificationMessage, QSortBy> {
  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      sortByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      sortByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      sortByProfileID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileID', Sort.asc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      sortByProfileIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileID', Sort.desc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      sortByRemoved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'removed', Sort.asc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      sortByRemovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'removed', Sort.desc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      sortBySeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seen', Sort.asc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      sortBySeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seen', Sort.desc);
    });
  }
}

extension NotificationMessageQuerySortThenBy
    on QueryBuilder<NotificationMessage, NotificationMessage, QSortThenBy> {
  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      thenByData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.asc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      thenByDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'data', Sort.desc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      thenByProfileID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileID', Sort.asc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      thenByProfileIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileID', Sort.desc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      thenByRemoved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'removed', Sort.asc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      thenByRemovedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'removed', Sort.desc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      thenBySeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seen', Sort.asc);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QAfterSortBy>
      thenBySeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seen', Sort.desc);
    });
  }
}

extension NotificationMessageQueryWhereDistinct
    on QueryBuilder<NotificationMessage, NotificationMessage, QDistinct> {
  QueryBuilder<NotificationMessage, NotificationMessage, QDistinct>
      distinctByData({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'data', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QDistinct>
      distinctByProfileID() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profileID');
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QDistinct>
      distinctByRemoved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'removed');
    });
  }

  QueryBuilder<NotificationMessage, NotificationMessage, QDistinct>
      distinctBySeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seen');
    });
  }
}

extension NotificationMessageQueryProperty
    on QueryBuilder<NotificationMessage, NotificationMessage, QQueryProperty> {
  QueryBuilder<NotificationMessage, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationMessage, String, QQueryOperations> dataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'data');
    });
  }

  QueryBuilder<NotificationMessage, int?, QQueryOperations>
      profileIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profileID');
    });
  }

  QueryBuilder<NotificationMessage, bool, QQueryOperations> removedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'removed');
    });
  }

  QueryBuilder<NotificationMessage, bool, QQueryOperations> seenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seen');
    });
  }
}
