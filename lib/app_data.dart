class AppData {
  static late AppData _instance;

  late String selectedGun;

  AppData._(); // Singleton sınıfı için özel bir kurucu

  static AppData get instance {
    _instance = _instance ?? AppData._(); // Tek bir örnek oluştur

    return _instance;
  }
}
