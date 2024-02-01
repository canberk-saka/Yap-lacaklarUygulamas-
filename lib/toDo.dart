class toDo {
  int id;
  String yapilacak;
  int gun_id;
  bool tamamlandiMi = false;

  toDo(this.id, this.yapilacak, this.gun_id);

  factory toDo.fromMap(Map<String, dynamic> map) {
    return toDo(map['id'], map['yapilacak'], map['gun_id']);
  }
}
