import 'package:flutter/material.dart';
import 'package:notlar_uygulamasi/GunAdiCevir.dart';
import 'package:notlar_uygulamasi/toDo.dart';
import 'package:notlar_uygulamasi/toDodao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  List<toDo> liste = [];
  List<bool> ustunuCizListesi = [];
  late int selectedGun = 1;
  late int selectedGunId = 1;
  bool bosDolu = true;

  @override
  void initState() {
    super.initState();
    selectedGunId = 0;
    toDoGoster();
  }

  Future<void> BosMu() async {
    try {
      List<toDo> gununToDoListesi =
          await toDodao().gununToDoListesi(selectedGunId);

      if (selectedGunId == 0) {
        setState(() {
          bosDolu = gununToDoListesi.isEmpty;
        });
      } else {
        setState(() {
          bosDolu = gununToDoListesi.isNotEmpty;
        });
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> toDoGoster() async {
    try {
      if (selectedGunId == 0) {
        // Eğer "Tümü" seçiliyse
        liste = await toDodao().tumToDolar();
      } else {
        // Diğer günler seçiliyse
        liste = await toDodao().gununToDoListesi(selectedGunId);
      }

      ustunuCizListesi = List.generate(liste.length, (index) => false);
      setState(() {});

      await BosMu(); // BosMu fonksiyonunu çağır
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> _showAddTodoDialog() async {
    TextEditingController yapilacakController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Yapılacak Ekle'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: yapilacakController,
                    decoration: InputDecoration(labelText: 'Yapılacak'),
                  ),
                  SizedBox(height: 16),
                  DropdownButton<int>(
                    value: selectedGun,
                    onChanged: (value) {
                      setState(() {
                        selectedGun = value!;
                      });
                    },
                    items: const [
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Text('Pazartesi'),
                      ),
                      DropdownMenuItem<int>(
                        value: 2,
                        child: Text('Salı'),
                      ),
                      DropdownMenuItem<int>(
                        value: 3,
                        child: Text('Çarşamba'),
                      ),
                      DropdownMenuItem<int>(
                        value: 4,
                        child: Text('Perşembe'),
                      ),
                      DropdownMenuItem<int>(
                        value: 5,
                        child: Text('Cuma'),
                      ),
                      DropdownMenuItem<int>(
                        value: 6,
                        child: Text('Cumartesi'),
                      ),
                      DropdownMenuItem<int>(
                        value: 7,
                        child: Text('Pazar'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    selectedGun = 1;
                  },
                  child: Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await toDodao().toDoEkle(
                      yapilacakController.text,
                      selectedGun,
                    );
                    selectedGun = 1;
                    Navigator.of(context).pop();
                    toDoGoster();
                  },
                  child: Text('Ekle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Emin misiniz?'),
                    content: Text(
                        'Bütün yapılacakları silmek istediğinize emin misiniz?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Dialog penceresini kapat
                        },
                        child: Text('Hayır'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await toDodao().tumToDolariSil();
                          toDoGoster();
                          Navigator.pop(context); // Dialog penceresini kapat
                        },
                        child: Text('Evet'),
                        style: ElevatedButton.styleFrom(),
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: 'Bütün Yapılacakları Sil',
          )
        ],
        backgroundColor: Colors.blue,
        title: Text('Yapılacaklar Listesi'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue, // Scaffold'ın backgroundColor'ı ile aynı yap
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 70, // Card yüksekliği
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildGunCard('Tümü', 0),
                    _buildGunCard('Pazartesi', 1),
                    _buildGunCard('Salı', 2),
                    _buildGunCard('Çarşamba', 3),
                    _buildGunCard('Perşembe', 4),
                    _buildGunCard('Cuma', 5),
                    _buildGunCard('Cumartesi', 6),
                    _buildGunCard('Pazar', 7),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: bosDolu
                        ? [Color(0xFFC4D9F3), Colors.white]
                        : [Colors.transparent],
                    begin: Alignment.bottomRight,
                    end: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40),
                    bottom: Radius.circular(0),
                  ),
                ),
                child: Stack(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: liste.length,
                      itemBuilder: (context, index) {
                        toDo t = liste[index];
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                ustunuCizListesi[index] =
                                    !ustunuCizListesi[index];
                              });
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                title: Text(
                                  t.yapilacak,
                                  style: TextStyle(
                                    decoration: ustunuCizListesi[index]
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                subtitle: Text("${gunIdToGunAdi(t.gun_id)}"),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    await toDodao().toDoSil(t.id);
                                    toDoGoster();
                                  },
                                ),
                              ),
                              color: Color(0xFFA4C6F5),
                            ),
                          ),
                        );
                      },
                    ),
                    if (!bosDolu)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hiç Yapılacak Eklememişsin',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _showAddTodoDialog();
                              },
                              child: Text('Yapılacak Ekle'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    _showAddTodoDialog();
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGunCard(String gunAdi, int gunId) {
    return Container(
      height: 45,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: selectedGunId == gunId ? Color(0xFF1570E0) : Color(0xFFB2D3F3),
        child: InkWell(
          onTap: () {
            setState(() {
              BosMu();
              print(
                  "                                                                      " +
                      bosDolu.toString());
              selectedGunId = gunId;
            });
            toDoGoster();
          },
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                gunAdi,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
