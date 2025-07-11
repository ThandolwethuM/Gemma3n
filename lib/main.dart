import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Gemma3nApp());
}

class Gemma3nApp extends StatelessWidget {
  const Gemma3nApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemma 3n AI Platform',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const EduBoxScreen(),
    const VibeCheckScreen(),
    const SignBridgeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'EduBox',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined),
            selectedIcon: Icon(Icons.psychology),
            label: 'VibeCheck',
          ),
          NavigationDestination(
            icon: Icon(Icons.sign_language_outlined),
            selectedIcon: Icon(Icons.sign_language),
            label: 'SignBridge',
          ),
        ],
      ),
    );
  }
}

// EduBox - Offline AI Tutor

class EduBoxScreen extends StatefulWidget {
  const EduBoxScreen({super.key});

  @override
  State<EduBoxScreen> createState() => _EduBoxScreenState();
}

class _EduBoxScreenState extends State<EduBoxScreen> {
  final TextEditingController _questionController = TextEditingController();
  bool _isListening = false;
  bool _isProcessing = false;
  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduBox - AI Tutor'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_camera),
            onPressed: _takePhoto,
            tooltip: 'Scan textbook',
          ),
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: () => _showProgressDialog(context),
            tooltip: 'Learning progress',
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  message: message.text,
                  isUser: message.isUser,
                  timestamp: message.timestamp,
                );
              },
            ),
          ),
          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      hintText: 'Ask your question...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _isListening ? _stopListening : _startListening,
                  mini: true,
                  backgroundColor: _isListening ? Colors.red : null,
                  child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _isProcessing ? null : () => _sendMessage(_questionController.text),
                  mini: true,
                  child: _isProcessing 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isProcessing = true;
    });
    
    _questionController.clear();
    
    // Simulate AI processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _messages.add(ChatMessage(
          text: _generateAIResponse(text),
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isProcessing = false;
      });
    });
  }

  String _generateAIResponse(String question) {
    // Placeholder AI response logic
    return "I understand you're asking about: '$question'. This is where the Gemma 3n AI would provide a detailed, educational response based on your question. The AI can analyze textbook images, provide explanations, and create personalized learning paths.";
  }

  void _startListening() {
    setState(() {
      _isListening = true;
    });
    // Implement speech-to-text
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
  }

  void _takePhoto() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      // Implement camera functionality for textbook scanning
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera feature will scan textbooks for AI analysis')),
      );
    }
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Learning Progress'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProgressItem('Mathematics', 0.8),
            _buildProgressItem('Science', 0.6),
            _buildProgressItem('Language', 0.9),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String subject, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subject),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: progress),
          Text('${(progress * 100).toInt()}% Complete'),
        ],
      ),
    );
  }
}

// VibeCheck - Mental Health Companion

class VibeCheckScreen extends StatefulWidget {
  const VibeCheckScreen({super.key});

  @override
  State<VibeCheckScreen> createState() => _VibeCheckScreenState();
}

class _VibeCheckScreenState extends State<VibeCheckScreen> {
  bool _isInSession = false;
  String _currentMood = 'neutral';
  String _selectedAvatar = 'default';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VibeCheck - AI Therapy'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _showAvatarSelector,
            tooltip: 'Customize therapist',
          ),
        ],
      ),
      body: _isInSession ? _buildSessionView() : _buildHomeView(),
    );
  }

  Widget _buildHomeView() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'How are you feeling today?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMoodButton('😊', 'happy'),
                      _buildMoodButton('😐', 'neutral'),
                      _buildMoodButton('😢', 'sad'),
                      _buildMoodButton('😰', 'anxious'),
                      _buildMoodButton('😴', 'tired'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _startSession,
            icon: const Icon(Icons.video_call),
            label: const Text('Start Therapy Session'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _openJournal,
            icon: const Icon(Icons.book),
            label: const Text('Open Journal'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionView() {
    return Column(
      children: [
        // AI Therapist Avatar Area
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            color: Colors.grey[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: const Icon(
                    Icons.psychology,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'AI Therapist ($_selectedAvatar)',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        
        // User Video Feed
        Expanded(
          flex: 1,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Video Feed'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('Mood: $_currentMood'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person),
                ),
              ],
            ),
          ),
        ),
        
        // Session Controls
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _endSession,
                icon: const Icon(Icons.stop),
                label: const Text('End Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.pause),
                label: const Text('Pause'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodButton(String emoji, String mood) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentMood = mood;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentMood == mood ? Colors.blue[100] : Colors.grey[200],
          border: Border.all(
            color: _currentMood == mood ? Colors.blue : Colors.grey,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  void _startSession() {
    setState(() {
      _isInSession = true;
    });
  }

  void _endSession() {
    setState(() {
      _isInSession = false;
    });
  }

  void _showAvatarSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Your AI Therapist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Default'),
              leading: const Icon(Icons.psychology),
              onTap: () {
                setState(() {
                  _selectedAvatar = 'default';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Calm Voice'),
              leading: const Icon(Icons.spa),
              onTap: () {
                setState(() {
                  _selectedAvatar = 'calm';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Energetic'),
              leading: const Icon(Icons.energy_savings_leaf),
              onTap: () {
                setState(() {
                  _selectedAvatar = 'energetic';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openJournal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const JournalScreen(),
      ),
    );
  }
}

// SignBridge - Sign Language Converter

class SignBridgeScreen extends StatefulWidget {
  const SignBridgeScreen({super.key});

  @override
  State<SignBridgeScreen> createState() => _SignBridgeScreenState();
}

class _SignBridgeScreenState extends State<SignBridgeScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isCameraActive = false;
  bool _isConverting = false;
  String _convertedText = '';
  String _selectedLanguage = 'ASL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignBridge - Sign Language'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            items: const [
              DropdownMenuItem(value: 'ASL', child: Text('ASL')),
              DropdownMenuItem(value: 'BSL', child: Text('BSL')),
              DropdownMenuItem(value: 'JSL', child: Text('JSL')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Camera Feed
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Stack(
                children: [
                  Center(
                    child: _isCameraActive
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.videocam,
                                size: 64,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 16),
                              const Text('Camera Active - Detecting Signs'),
                              if (_isConverting)
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.videocam_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text('Camera Inactive'),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _toggleCamera,
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('Start Camera'),
                              ),
                            ],
                          ),
                  ),
                  if (_isCameraActive)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: _toggleCamera,
                        child: const Icon(Icons.stop),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Converted Text Display
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Converted Text:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _convertedText.isEmpty ? 'No text detected yet...' : _convertedText,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Text to Sign Input
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Text to Sign Animation:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Enter text to convert to sign language...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _convertTextToSign,
                      icon: const Icon(Icons.sign_language),
                      label: const Text('Convert'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _isCameraActive = !_isCameraActive;
        if (_isCameraActive) {
          _startSignDetection();
        }
      });
    }
  }

  void _startSignDetection() {
    // Simulate sign detection
    Future.delayed(const Duration(seconds: 3), () {
      if (_isCameraActive) {
        setState(() {
          _isConverting = true;
        });
        
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _isConverting = false;
            _convertedText = 'Hello, how are you today?';
          });
        });
      }
    });
  }

  void _convertTextToSign() {
    if (_textController.text.trim().isEmpty) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Converting "${_textController.text}" to $_selectedLanguage signs...'),
      ),
    );
    
    // Here would be the actual text-to-sign conversion logic
    _textController.clear();
  }
}

// Journal Screen for VibeCheck
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _entryController = TextEditingController();
  final List<JournalEntry> _entries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addEntry,
          ),
        ],
      ),
      body: _entries.isEmpty
          ? const Center(
              child: Text('No journal entries yet. Start writing!'),
            )
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      entry.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteEntry(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addEntry() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Journal Entry'),
        content: TextField(
          controller: _entryController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Write your thoughts...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_entryController.text.trim().isNotEmpty) {
                setState(() {
                  _entries.add(JournalEntry(
                    content: _entryController.text.trim(),
                    date: DateTime.now(),
                  ));
                });
                _entryController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
  }
}

// Data Models
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class JournalEntry {
  final String content;
  final DateTime date;

  JournalEntry({
    required this.content,
    required this.date,
  });
}

// UI Components
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isUser 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 12,
                color: isUser 
                    ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                    : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}