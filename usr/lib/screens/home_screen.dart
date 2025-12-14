import 'dart:math';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;
  String? _generatedImageUrl;
  String _selectedStyle = 'Realistic';

  final List<String> _styles = [
    'Realistic',
    'Anime',
    'Cyberpunk',
    'Oil Painting',
    '3D Render',
    'Sketch',
  ];

  Future<void> _generateImage() async {
    if (_promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masukkan deskripsi gambar terlebih dahulu.')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _generatedImageUrl = null;
    });

    // Simulasi delay API call
    await Future.delayed(const Duration(seconds: 3));

    // Simulasi hasil gambar menggunakan Picsum dengan seed random
    // Dalam aplikasi nyata, ini akan memanggil API backend (Supabase Edge Function -> OpenAI/Stable Diffusion)
    final randomSeed = Random().nextInt(10000);
    
    if (mounted) {
      setState(() {
        _generatedImageUrl = 'https://picsum.photos/seed/$randomSeed/512/512';
        _isGenerating = false;
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Photo Generator'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            const Text(
              'Buat Gambar dengan AI',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Masukkan deskripsi imajinasi Anda dan biarkan AI membuatnya menjadi nyata.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Input Section
            TextField(
              controller: _promptController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Contoh: Seekor kucing astronot sedang minum kopi di bulan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 24),

            // Style Selection
            const Text(
              'Pilih Gaya:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _styles.length,
                itemBuilder: (context, index) {
                  final style = _styles[index];
                  final isSelected = _selectedStyle == style;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(style),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStyle = style;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            // Generate Button
            FilledButton.icon(
              onPressed: _isGenerating ? null : _generateImage,
              icon: _isGenerating 
                  ? const SizedBox(
                      width: 20, 
                      height: 20, 
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                    ) 
                  : const Icon(Icons.auto_awesome),
              label: Text(
                _isGenerating ? 'Sedang Membuat...' : 'Generate Foto',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Result Section
            if (_generatedImageUrl != null)
              Column(
                children: [
                  const Text(
                    'Hasil:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      _generatedImageUrl!,
                      width: double.infinity,
                      height: 400,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 400,
                          width: double.infinity,
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // Implementasi download/share nanti
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Fitur simpan akan segera hadir!')),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Simpan'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Implementasi share nanti
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Fitur bagikan akan segera hadir!')),
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Bagikan'),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
