import 'package:notlar_uygulamasi/Gunler.dart';
import 'package:notlar_uygulamasi/VeriTabaniYardimcisi.dart';

class Gunlerdao {
  Future<void> gunEkle(String gunAdi) async {
    var db = await VeriTabaniYardimcisi().veriTabaniErisim();

    var bilgiler = Map<String, dynamic>();
    bilgiler["gun_Adi"] = gunAdi;

    await db.insert("Gunler", bilgiler);
  }

  Future<List<Gunler>> tumGunleriGetir() async {
    var db = await VeriTabaniYardimcisi().veriTabaniErisim();

    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM Gunler");

    return List.generate(maps.length, (i) {
      var satir = maps[i];
      return Gunler(satir["id"], satir["gun_adi"]);
    });
  }

  Future<void> gunSil(String gunAdi) async {
    var db = await VeriTabaniYardimcisi().veriTabaniErisim();
    await db.rawDelete("DELETE FROM Gunler WHERE gun_adi = ?", [gunAdi]);
  }
}
