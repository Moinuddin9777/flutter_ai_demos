import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:typed_data';


class SpamDetectorScreen extends StatefulWidget {
  const SpamDetectorScreen({super.key});

  @override
  _SpamDetectorScreenState createState() => _SpamDetectorScreenState();
}

class _SpamDetectorScreenState extends State<SpamDetectorScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _prediction;
  String? _confidence;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  // Load the TFLite model
  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/spam_model.tflite",
      labels: "assets/labels.txt",
    );
  }

  // Preprocess the input text
  List<int> _preprocessText(String text) {
    List<String> vocab = _loadVocab();
    List<String> words = text.toLowerCase().split(' ');
    List<int> indices = [];

    for (String word in words) {
      int index = vocab.indexOf(word);
      if (index != -1) {
        indices.add(index); // Add the index if the word is in the vocab
      } else {
        indices.add(0); // Add a 0 for unknown words
      }
    }

    // Ensure the input is of fixed length for the model
    int maxLength = 20; // Adjust based on the model's expected input length
    if (indices.length > maxLength) {
      indices = indices.sublist(0, maxLength);
    } else {
      while (indices.length < maxLength) {
        indices.add(0); // Pad with zeros
      }
    }
    return indices;
  }

  // Load the vocabulary (example implementation)
  List<String> _loadVocab() {
    // For demo purposes, we use a hard-coded vocab.
    // In a real case, read from vocab.txt
    return [
      'hi', 'free', 'win', 'congratulations', 'urgent', 'claim', 'prize',
      'call', 'money', 'offer', 'click', 'buy', 'text', 'now', 'exclusive',
      // ... populate with the words from your vocab.txt
    ];
  }

  // Convert list of indices to Uint8List to feed into TFLite model
  Uint8List _convertToUint8List(List<int> indices) {
    return Uint8List.fromList(indices);
  }

  // Run the spam detection
  Future<void> detectSpam(String text) async {
    List<int> inputIndices = _preprocessText(text);
    Uint8List inputBytes = _convertToUint8List(inputIndices);

    var recognitions = await Tflite.runModelOnBinary(
      binary: inputBytes.buffer.asUint8List(),
      numResults: 1,
      threshold: 0.5, // Confidence threshold
    );

    setState(() {
      _prediction = recognitions![0]['label'];
      _confidence = (recognitions[0]['confidence'] * 100.0).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spam Detection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter a message to check for spam',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                detectSpam(_controller.text);
              },
              child: const Text('Check for Spam'),
            ),
            const SizedBox(height: 20),
            _prediction == null
                ? const Text('Enter a message to classify')
                : Text(
                    'Prediction: $_prediction\nConfidence: $_confidence%',
                    style: const TextStyle(fontSize: 16),
                  ),
          ],
        ),
      ),
    );
  }
}
