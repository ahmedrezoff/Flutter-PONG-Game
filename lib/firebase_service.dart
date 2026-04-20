import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService
{
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> saveScore({
    required String player,
    required int score,
    required String difficulty,
  }) async
  {
    final query = await _db
        .collection("leaderboard")
        .where("player", isEqualTo: player)
        .limit(1)
        .get();

    if (query.docs.isEmpty)
    {
      await _db.collection("leaderboard").add({
        "player": player,
        "score": score,
        "difficulty": difficulty,
        "time": FieldValue.serverTimestamp(),
      });
    }
    else
    {
      final doc = query.docs.first;
      final existingScore = doc["score"] as int;

      if (score > existingScore)
      {
        await _db.collection("leaderboard").doc(doc.id).update({
          "score": score,
          "difficulty": difficulty,
          "time": FieldValue.serverTimestamp(),
        });
      }
    }
  }

  static Stream<QuerySnapshot> getLeaderboard()
  {
    return _db
        .collection("leaderboard")
        .orderBy("score", descending: true)
        .limit(10)
        .snapshots();
  }
}
