# Gemma 3n Mobile App

## Overview
Gemma 3n is an AI-powered mobile platform designed to operate entirely offline, ensuring privacy and accessibility. The app leverages on-device AI capabilities to provide impactful features in education, mental health, and accessibility.

## Features
### 1. EduBox – Offline AI Tutor
- **Purpose**: Quality education in low-connectivity zones.
- **Capabilities**:
  - Multilingual tutoring.
  - Real-time assessment.
  - Question answering from visual content.
  - Personalized learning paths.
  - Progress tracking (local storage).

### 2. VibeCheck – Mental Health Companion
- **Purpose**: Live AI therapy and emotional support.
- **Capabilities**:
  - Customizable AI therapist avatars (ethnicity selection).
  - Video call interface with emotion analysis.
  - Voice tone and mood detection.
  - Journaling prompts.
  - Wellness coaching.

### 3. SignBridge – Sign Language Converter
- **Purpose**: Real-time accessibility for Deaf/Hard of Hearing.
- **Capabilities**:
  - Sign language to text conversion.
  - Text to sign language animation.
  - Voice narration of converted text.
  - Multiple sign language support (ASL, BSL, etc.).

## Technical Details
- **Framework**: Flutter (cross-platform).
- **AI Framework**: TensorFlow Lite / ONNX Runtime.
- **Camera Processing**: OpenCV / MediaPipe.
- **Audio Processing**: AudioFlinger / AAudio.
- **Storage**: SQLite with encryption.
- **UI Design**: Material Design 3.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/gemma3n.git

2. Navigate to the project directory:
    cd gemma3n

3. Install dependencies
    flutter pub get

4. run the app
    flutter run