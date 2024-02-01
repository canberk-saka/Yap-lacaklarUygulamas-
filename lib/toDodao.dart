import 'package:notlar_uygulamasi/VeriTabaniYardimcisi.dart';
import 'package:notlar_uygulamasi/toDo.dart';

class toDodao {
  /* Future<List<toDo>> tumToDolar() async {
    var db = await VeriTabaniYardimcisi().veriTabaniErisim();

    List<Map<String, dynamic>> maps = await db.rawQuery("Select * from toDo");

    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return toDo(
          satir["id"], satir["yapilacak"], satir["gun_id"], satir["gun_Adi"]);
    });
  }
*/
  Future<void> toDoEkle(String yapilacak, int gun_id) async {
    var db = await VeriTabaniYardimcisi().veriTabaniErisim();

    var bilgiler = Map<String, dynamic>();
    bilgiler["yapilacak"] = yapilacak;
    bilgiler["gun_id"] = gun_id;

    await db.insert("toDo", bilgiler);
  }

  Future<List<toDo>> tumToDolar() async {
    var db = await VeriTabaniYardimcisi().veriTabaniErisim();

    List<Map<String, dynamic>> maps = await db.rawQuery("Select * from toDo");

    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return toDo(satir["id"], satir["yapilacak"], satir["gun_id"]);
    });
  }

  Future<void> toDoSil(int id) async {
    var db = await VeriTabaniYardimcisi().veriTabaniErisim();
    await db.delete("toDo", where: "id = ?", whereArgs: [id]);
  }

  Future<void> tumToDolariSil() async {
    var db = await VeriTabaniYardimcisi().veriTabaniErisim();
    await db.delete("toDo");
  }

  Future<List<toDo>> gununToDoListesi(int gunId) async {
    var db = await VeriTabaniYardimcisi().veriTabaniErisim();
    var result = await db.query(
      "toDo",
      where: "gun_id = ?",
      whereArgs: [gunId],
    );
    return result.map((e) => toDo.fromMap(e)).toList();
  }
}
