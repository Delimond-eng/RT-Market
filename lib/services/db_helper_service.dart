import 'package:mongo_dart/mongo_dart.dart';

import '../index.dart';

class DBHelper {
  static Db db = Db("mongodb://localhost:27017/marketdb");

  static Future onCreateDb() async {
    var db = await Db.create("mongodb://localhost:27017/marketdb");
    await db.open();
    try {
      var coll = db.collection("utilisateurs");
      var users = await coll.find().toList();

      if (users.isEmpty || users == null) {
        Vendeur vendeur = Vendeur(
            vendeurNom: "administrateur",
            vendeurRole: "admin",
            vendeurTelephone: "+243",
            vendeurMotDePasse: "12345",
            vendeurUtilisateur: "@admin",
            vendeurStatus: "actif",
            vendeurDateCreation: dateFromString(DateTime.now()));

        Vendeur vendeur1 = Vendeur(
            vendeurNom: "admin vendeur",
            vendeurRole: "vendeur",
            vendeurTelephone: "+243",
            vendeurMotDePasse: "12345",
            vendeurUtilisateur: "@admin-vendeur",
            vendeurStatus: "actif",
            vendeurDateCreation: dateFromString(DateTime.now()));

        await coll.insert(vendeur.toMap());
        await coll.insert(vendeur1.toMap());

        await db.close();
      } else {
        await db.close();
        return;
      }
    } catch (err) {
      print("error mongo oncreate statment $err");
    }
  }

  static Future mongoInsert({String collectionName, Map mapData}) async {
    var db = await Db.create("mongodb://localhost:27017/marketdb");
    await db.open();
    try {
      var coll = db.collection(collectionName);
      var result = await coll.insert(mapData);
      await db.close();
      if (result != null) {
        return result;
      } else {
        return null;
      }
    } catch (error) {
      print("error mongodb $error");
    }
  }

  static Future mongoGetAll({String collectionName}) async {
    var db = await Db.create("mongodb://localhost:27017/marketdb");
    await db.open();
    try {
      var coll = db.collection(collectionName);
      var list = await coll.find().toList();
      await db.close();
      return list;
    } catch (error) {
      print("error mongodb $error");
    }
  }

  static Future mongoFindOne(
      {String collectionName, String field, String where}) async {
    var db = await Db.create("mongodb://localhost:27017/marketdb");
    await db.open();
    try {
      var coll = db.collection(collectionName);
      var list = await coll.find({field: where}).toList();
      await db.close();
      return list;
    } catch (error) {
      print("error mongodb $error");
    }
  }

  static Future mongoDeleteOne({String collectionName, Map selector}) async {
    await db.open();
    try {
      var coll = db.collection(collectionName);
      var result = await coll.deleteOne(selector);
      await db.close();
      if (result != null) {
        return result;
      } else {
        return null;
      }
    } catch (error) {
      print("error mongodb $error");
    }
  }

  static Future insertProductStock({Produit produit, Stock stock}) async {
    var db = await Db.create("mongodb://localhost:27017/marketdb");
    await db.open();
    try {
      var produitsCollection = db.collection('produits');
      var result = await produitsCollection.insert(produit.toMap());
      print(result);
      if (result != null) {
        stock.stockProduitId = produit.produitId;
        var stocksCollection = db.collection('stocks');
        var resultInsert = await stocksCollection.insert(stock.toMap());
        await db.close();
        if (resultInsert != null) {
          return "success";
        }
      }
    } catch (err) {
      print("error from insert product statement !");
    }
  }

  static Future getInnerProductStock() async {
    var db = await Db.create("mongodb://localhost:27017/marketdb");
    await db.open();
    try {
      var coll = db.collection("produits");
      final pipeline = AggregationPipelineBuilder()
          .addStage(
            Lookup(
              from: "stocks",
              localField: "_id",
              foreignField: "stock_produit_id",
              as: "stock",
            ),
          )
          .build();
      var list = await coll.aggregateToStream(pipeline).toList();
      await db.close();
      if (list.isNotEmpty) {
        return list;
      } else {
        return null;
      }
    } catch (err) {
      print("error from pipeline product stock $err");
    }
  }

  static Future inventories() async {
    var db = await Db.create("mongodb://localhost:27017/marketdb");
    await db.open();
    try {
      var coll = db.collection("produits");
      final pipeline = AggregationPipelineBuilder()
          .addStage(
            Lookup(
              from: "stocks",
              localField: "_id",
              foreignField: "stock_produit_id",
              as: "stock",
            ),
          )
          .addStage(
            Lookup(
              from: "ventes",
              localField: "_id",
              foreignField: "vente_produit_id",
              as: "ventes",
            ),
          )
          .build();
      var list = await coll.aggregateToStream(pipeline).toList();
      await db.close();
      if (list.isNotEmpty) {
        return list;
      } else {
        return null;
      }
    } catch (e) {
      print("error from inventories $e");
    }
  }

  static Future innerJoin() async {
    var db = await Db.create("mongodb://localhost:27017/marketdb");
    await db.open();
    try {
      var coll = db.collection("produits");
      final pipeline = AggregationPipelineBuilder()
          .addStage(
            Lookup(
              from: "stocks",
              localField: "_id",
              foreignField: "stock_produit_id",
              as: "stock",
            ),
          )
          .addStage(
            Lookup(
              from: "ventes",
              localField: "_id",
              foreignField: "vente_produit_id",
              as: "ventes",
            ),
          )
          .build();
      var list = await coll.aggregateToStream(pipeline).toList();
      await db.close();
      if (list.isNotEmpty) {
        return list;
      } else {
        return null;
      }
    } catch (e) {
      print("error from inventories $e");
    }
  }

  static Future addStock({Stock stock}) async {
    var db = await Db.create("mongodb://localhost:27017/marketdb");
    await db.open();
    try {
      var stockCollection = db.collection('stocks');
      var currentStock = await stockCollection
          .find({'stock_produit_id': stock.stockProduitId}).toList();
      int lastQte = 0;
      int currentQte = 0;
      currentStock.forEach((e) {
        lastQte = e['stock_qte'];
      });

      if (currentStock.isNotEmpty) {
        currentQte = lastQte + stock.stockQte;
        var res = await stockCollection.modernUpdate(
          {'stock_produit_id': stock.stockProduitId},
          {
            'stock_user_id': stock.userId,
            'stock_produit_id': stock.stockProduitId,
            'stock_produit_pu': stock.stockProduitPrixUnitaire,
            'stock_prix_devise': stock.stockPrixDevise,
            'stock_qte': currentQte,
            'stock_entrees': currentQte + stock.stockSortie,
            'stock_sorties': stock.stockSortie,
            'stock_date': stock.stockDate,
            'stock_status': 'actif',
          },
        );
        await db.close();
        if (res != null) {
          return "success";
        } else {
          return null;
        }
      } else {
        currentQte = stock.stockQte;
        var res = await stockCollection.insert(
          {
            'stock_user_id': stock.userId,
            'stock_produit_id': stock.stockProduitId,
            'stock_produit_pu': stock.stockProduitPrixUnitaire,
            'stock_prix_devise': stock.stockPrixDevise,
            'stock_qte': currentQte,
            'stock_entrees': currentQte,
            'stock_sorties': stock.stockSortie,
            'stock_date': stock.stockDate,
            'stock_status': 'actif',
          },
        );
        await db.close();
        if (res != null) {
          return "success";
        } else {
          return null;
        }
      }
    } catch (err) {
      print('error from stock adding $err');
    }
  }

  static Future checkCostumer({String phone, String nom}) async {
    var db = await Db.create("mongodb://localhost:27017/marketdb");
    await db.open();
    try {
      if (phone.isNotEmpty) {
        var coll = db.collection("clients");
        var res = await coll.find({"client_phone": phone}).toList();
        if (res.isEmpty) {
          await coll.insert({"client_nom": nom, "client_phone": phone});
          if (res != null) {
            //var list = await coll.find({"client_phone": phone}).toList();
            await db.close();
            return null;
          } else {
            await db.close();
            return null;
          }
        } else {
          await db.close();
          return res;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("error from check costumer $e");
    }
  }

  static Future makeVente({List<Map<String, dynamic>> maps}) async {
    var db = await Db.create("mongodb://localhost:27017/marketdb");
    await db.open();
    try {
      var venteColl = db.collection("ventes");
      var result = await venteColl.insertMany(maps, ordered: true);
      if (result != null) {
        int lastQte = 0;
        int lastSortyQty = 0;
        int currentQte = 0;
        int currentSortyQty = 0;
        ObjectId productId;

        var stockCollection = db.collection('stocks');

        for (int i = 0; i < maps.length; i++) {
          int venteQte = maps[i]["vente_qte"];
          ObjectId produitId = maps[i]['vente_produit_id'];
          productId = maps[i]['vente_produit_id'];
          var stock = await stockCollection
              .find({'stock_produit_id': productId}).toList();
          if (stock.isNotEmpty) {
            stock.forEach((e) async {
              lastQte = e["stock_qte"];
              lastSortyQty = e["stock_sorties"];
            });
            currentQte = lastQte - venteQte;
            currentSortyQty = lastSortyQty + venteQte;
            await stockCollection.update(
              where.eq('stock_produit_id', produitId),
              modify.set('stock_sorties', currentSortyQty),
              multiUpdate: true,
            );
            await stockCollection.update(
              where.eq('stock_produit_id', produitId),
              modify.set('stock_qte', currentQte),
              multiUpdate: true,
            );
            await db.close();
          }
          return result;
        }
      } else {
        return null;
      }
    } catch (err) {
      print("error from mongodb ventes statment: $err");
    }
  }

  static Future loginUser({Vendeur find}) async {
    await db.open();
    try {
      var coll = db.collection('utilisateurs');
      var user = await coll.find({
        'vendeur_utilisateur': find.vendeurUtilisateur,
        'vendeur_motpasse': find.vendeurMotDePasse
      }).toList();
      await db.close();
      if (user.isNotEmpty) {
        return user;
      } else {
        return null;
      }
    } catch (err) {
      print("error from login $err");
    }
  }
}
