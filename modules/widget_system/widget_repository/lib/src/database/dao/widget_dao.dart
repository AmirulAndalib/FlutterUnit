import 'package:fx_dao/fx_dao.dart';
import '../../model/widget_filter.dart';
import '../po/widget_po.dart';

class WidgetDao with HasDatabase, DbTable {
  @override
  String get createSql => '';

  @override
  String get name => 'widget';

  Future<int> insert(WidgetPo widget) async {
    String addSql = "INSERT INTO "
        "widget(id,name,nameCN,deprecated,family,lever,linkWidget,info) "
        "VALUES (?,?,?,?,?,?,?,?);";
    return database.transaction((tran) async => await tran.rawInsert(addSql, [
          widget.id,
          widget.name,
          widget.nameCN,
          widget.deprecated,
          widget.family,
          widget.lever,
          widget.linkWidget,
          widget.info
        ]));
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    return database.rawQuery("SELECT * FROM widget");
  }

  Future<List<Map<String, dynamic>>> queryByFamily(
    WidgetFamily family, {
    String locale = 'zh-cn',
  }) async {
    return database.rawQuery(
        "SELECT * "
        "FROM widget WHERE family = ? ORDER BY lever DESC",
        [family.index]);
  }

  Future<List<Map<String, dynamic>>> queryByIds(List<int> ids, String? locale) async {
    if (ids.isEmpty) {
      return [];
    }
    String searchSql = """
SELECT 
  widget.id, 
  widget.name,
  widget.family,
  widget.linkWidget,
  widget.lever,
  widget_desc.name AS nameCN, 
  widget_desc.info
FROM widget
INNER JOIN widget_desc 
  ON widget.id = widget_desc.widget_id
WHERE 
  widget_desc.locale = ? AND 
  widget.id in (${'?,' * (ids.length - 1)}?)
ORDER BY 
  lever DESC, widget.id ASC;
    """;

    return database.rawQuery(searchSql, [(locale?? 'zh-cn'), ...ids]);
  }

  Future<List<Map<String, dynamic>>> search(WidgetFilter arguments) async {
    // 保证 name 参数为空时，不进行搜索
    if (arguments.name.isEmpty) {
      return [];
    }

    // * 表示 name 任意
    String name = arguments.name == '*' ? '' : arguments.name;
    bool hasFamily = arguments.family != null;
    String familySql = hasFamily ? ' AND family = ?' : '';
    List<int> familyArg = hasFamily ? [arguments.family!.index] : [];
    List<int> starArg = arguments.stars;
    // 保证在星级参数是 [-1,-1,-1,-1,-1] 时，搜索全星级
    if (arguments.stars.reduce((a, b) => a + b) == -5) {
      starArg = [1, 2, 3, 4, 5];
    }

    String searchSql = """
SELECT 
  widget.id, 
  widget.name,
  widget.family,
  widget.linkWidget,
  widget.lever,
  widget_desc.name AS nameCN, 
  widget_desc.info
FROM widget
INNER JOIN widget_desc 
  ON widget.id = widget_desc.widget_id
WHERE 
widget_desc.locale = ? 
AND (widget.name LIKE ? OR widget_desc.info LIKE ? OR widget_desc.name LIKE ?) 
$familySql 
AND lever IN(?,?,?,?,?) 
ORDER BY 
  lever DESC, widget.id ASC 
LIMIT ? OFFSET ? 
;
    """;

    return database.rawQuery(searchSql,
        [
          arguments.locale?? 'zh-cn',
          "%$name%",
          "%$name%",
          "%$name%",
          ...familyArg,
          ...starArg,
          arguments.pageSize,
          arguments.offset
        ]);
  }

  Future<int> total(WidgetFilter args) async {
    bool hasFamily = args.family != null;
    String familySql = hasFamily ? 'family = ?' : '';
    List<int> familyArg = hasFamily ? [args.family!.index] : [];

    String sql = "SELECT count(id) as `count` FROM widget WHERE $familySql";

    List<Map<String, Object?>> result = await database.rawQuery(sql, familyArg);
    if (result.isNotEmpty) {
      return result.first['count'] as int ?? 0;
    }
    return 0;
  }

  Future<Map<String, dynamic>?> queryWidgetByName(String name) async {
    String sql = "SELECT * FROM widget WHERE name = ?";
    List<Map<String, Object?>> result = await database.rawQuery(sql, [name]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
