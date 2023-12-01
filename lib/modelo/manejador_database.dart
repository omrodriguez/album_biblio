import 'album.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManejadorDatabase {
  static FirebaseFirestore db =FirebaseFirestore.instance;
  static String nombreColeccion = 'albumes';
  static CollectionReference coleccion = db.collection(nombreColeccion);
  static final ManejadorDatabase _instance = ManejadorDatabase._();


  ManejadorDatabase._();

  static ManejadorDatabase getInstance() {
    return _instance;
  }

  Future<String> insertarAlbum(Album album) async {
    String result = "";
    await db.collection(nombreColeccion).add(album.toJson()).then(
      (doc) {
        result = doc.id;
      },);
    return result;
  }

  Future<List<Album>> albumes() async {
    QuerySnapshot snapshot = await coleccion.get();
    final List<QueryDocumentSnapshot> docs = snapshot.docs;
    List<Album> listaAlbumes = [];
    for (int i = 0; i < docs.length; i++) {
      DocumentSnapshot doc = docs[i];
      String id = doc.id;
      Map<String, dynamic> datos = doc.data() as Map<String, dynamic>;
      Album album = Album.fromMapID(id, datos);
      listaAlbumes.add(album);
    }
    return listaAlbumes;
  }

  Future<void> actualizarAlbum(Album album) async {
    await db.collection(nombreColeccion).doc(album.id).set(album.toJson())
    .onError((error, stackTrace) => print("Error al actualizar ${album.id}"));
  }

  Future<void> removerAlbum(String id) async {
    await db.collection(nombreColeccion).doc(id).delete()
    .onError((error, stackTrace) => print("Error al borrar $id"));
  }
}
