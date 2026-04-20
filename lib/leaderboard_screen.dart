import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';
import 'main.dart';

class LeaderboardScreen extends StatelessWidget
{
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [DARK_BG, Color(0xFF120017)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseService.getLeaderboard(),
          builder: (context, snapshot)
          {
            if (!snapshot.hasData)
            {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: docs.length,
              itemBuilder: (context, index)
              {
                final data = docs[index];
                return ListTile(
                  leading: Text(
                    "#${index + 1}",
                    style: const TextStyle(color: NEON_YELLOW),
                  ),
                  title: Text(
                    data["player"],
                    style: const TextStyle(color: NEON_YELLOW),
                  ),
                  trailing: Text(
                    data["score"].toString(),
                    style: const TextStyle(color: NEON_PURPLE),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
