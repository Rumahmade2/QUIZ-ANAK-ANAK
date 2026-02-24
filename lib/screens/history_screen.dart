import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/score_result.dart';
import '../services/storage_service.dart';
import 'result_screen.dart';
import '../data/sample_data.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<ScoreResult>> _future;

  @override
  void initState() {
    super.initState();
    _future = StorageService.getResults();
  }

  void _refresh() {
    setState(() {
      _future = StorageService.getResults();
    });
  }

  Future<void> _export() async {
    final path = await StorageService.exportCsv();
    try {
      await Share.shareXFiles([XFile(path)], text: 'Riwayat Kuis');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('CSV diekspor ke: $path')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Kuis'),
        actions: [
          IconButton(
            onPressed: () async {
              await StorageService.clearResults();
              _refresh();
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(onPressed: _export, icon: const Icon(Icons.file_download)),
        ],
      ),
      body: FutureBuilder<List<ScoreResult>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done)
            return const Center(child: CircularProgressIndicator());
          final list = snap.data ?? [];
          if (list.isEmpty)
            return const Center(child: Text('Tidak ada riwayat'));
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final r = list[list.length - 1 - index]; // show newest first
              return ListTile(
                title: Text('${r.subject} - ${r.score}/${r.total}'),
                subtitle: Text('${r.date.toLocal()} - ${r.user}'),
                onTap: () {
                  final questions = sampleQuizzes[r.subject] ?? [];
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ResultScreen(result: r, questions: questions),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
