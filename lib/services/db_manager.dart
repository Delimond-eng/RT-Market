import 'sqlite_db_helper.dart';

class DbManager {
  static Future<void> createTables() async {
    try {
      await SqliteDbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS users(user_id INTEGER NOT NULL PRIMARY KEY, user_name TEXT, user_role TEXT, user_phone TEXT, user_pass TEXT)");
      await SqliteDbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS ventes(vente_id INTEGER NOT NULL PRIMARY KEY,vente_qte INTEGER, vente_date TEXT, produit_id INTEGER NOT NULL, unite_id INTEGER, user_id INTEGER NOT NULL)");
      await SqliteDbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS unites(unite_id INTEGER NOT NULL PRIMARY KEY, unite_libelle TEXT)");
      await SqliteDbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS produits(produit_id INTEGER NOT NULL PRIMARY KEY,produit_code TEXT, produit_libelle TEXT, produit_photo TEXT, produit_date_exp TEXT, produit_prix TEXT, unite_id INTEGER, user_id INTEGER NOT NULL)");
      await SqliteDbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS stocks(stock_id INTEGER NOT NULL PRIMARY KEY,stock_qte_entree INTEGER,stock_qte_sortie INTEGER, stock_date_ref TEXT, unite_id INTEGER, produit_id INTEGER NOT NULL, user_id INTEGER NOT NULL)");
      print("tables created");
      await SqliteDbHelper.createTable(
          "CREATE TABLE IF NOT EXISTS tests(test_id INTEGER NOT NULL PRIMARY KEY, test_label TEXT, test_date INTEGER NOT NULL)");
    } catch (e) {
      print("error from creating tables $e");
    }
  }
}
