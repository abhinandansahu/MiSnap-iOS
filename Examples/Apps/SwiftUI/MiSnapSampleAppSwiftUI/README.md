# MiSnap SwiftUI Sample App

A comprehensive SwiftUI reference application demonstrating MiSnap SDK integration patterns for iOS developers. This sample app showcases all major MiSnap features with clear, copy-paste friendly code and educational comments.

## Features

- **Document Capture** - ID Cards, Passports, Checks with optimized configurations
- **Face Capture** - Selfie modes with AI-based liveness detection and smile capture
- **Voice Capture** - Voice biometric enrollment and verification flows
- **NFC Reading** - Read NFC-enabled passports, ID cards, and driver's licenses
- **Workflow** - Multi-step capture workflows combining multiple features

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- MiSnap SDK License Key (contact your Mitek representative)

## Getting Started

### 1. Configure License Key

Add your MiSnap license key to the `LicenseKey.swift` file located in the `App` folder:

```swift
enum LicenseKey {
    static let key = "YOUR_LICENSE_KEY_HERE"
}
```

Replace `"YOUR_LICENSE_KEY_HERE"` with your actual license key. This centralized approach means you only need to paste your key once - all features (Documents, Face, Voice, NFC, and Workflow) will automatically use this key.

> **Note**: For production apps, store license keys securely using Keychain or fetch them from your server rather than hard-coding them in your application.

### 2. Build and Run

1. Open the project in Xcode
2. Select a target device (iOS 16+ required)
3. Press **Cmd+R** to build and run
4. Grant camera/microphone permissions when prompted

## Project Structure

```
MiSnapSampleAppSwiftUI/
├── App/                              # App configuration
├── Features/
│   ├── Documents/                    # Document capture reference
│   ├── Face/                         # Face capture reference
│   ├── Voice/                        # Voice capture reference
│   ├── NFC/                          # NFC reading reference
│   └── Workflow/                     # Multi-step workflow reference
├── Common/
│   ├── Models/                       # Shared data models
│   ├── UI/                           # Reusable UI components
│   └── Utilities/                    # Helpers and utilities
└── Assets/                           # Localization files
```

Each feature module is self-contained with a View, ViewModel, and UIViewControllerRepresentable wrapper.

## Architecture

### MVVM Pattern

- **View**: SwiftUI views for UI and user interactions
- **ViewModel**: SDK integration, validation, business logic
- **Model**: Result structures and configurations

### Copy-Paste Friendly Design

Each ViewModel intentionally duplicates validation logic (license checks, permissions) rather than using shared utilities. This makes it easy to copy a single feature into your project without dependencies.

### Integration Flow

All features follow a consistent pattern:

1. **License Check** - Verify MiSnap license is valid
2. **Permission Check** - Request camera/microphone permissions
3. **Validation** - Feature-specific checks (disk space, NFC chip detection, etc.)
4. **Configuration** - Build SDK configuration with custom parameters
5. **Presentation** - Show capture screen
6. **Result Handling** - Process captured data (images, MIBI, audio, NFC data)

## Key Files

Each feature has a reference ViewModel containing:
- Educational comments explaining integration steps
- Complete validation flows
- Configuration examples
- Result handling patterns

**Reference ViewModels:**
- `DocumentsViewModel.swift` - Document capture patterns
- `FaceViewModel.swift` - Face capture patterns
- `VoiceViewModel.swift` - Voice enrollment/verification patterns
- `NFCViewModel.swift` - NFC validation and chip detection
- `WorkflowViewModel.swift` - Multi-step workflow orchestration

## Troubleshooting

### License Issues
Verify license key is correctly set in each ViewModel's `setupLicense()` method. Ensure license covers all features you're using.

### NFC Not Working
- Test on physical device (NFC doesn't work in Simulator)
- Ensure device supports NFC (iPhone 7+ with iOS 13+)
- Verify document has NFC chip
- Hold device steady against document during reading

### Disk Space Error
Voice and Workflow features require 10-20 MB minimum disk space. Free up device storage if needed.


## License
This sample application is provided for integration reference. Contact Mitek Systems for MiSnap SDK licensing.

---

**Note**: This is a reference implementation. Production apps should implement additional security measures, error handling, and backend integration according to your requirements.
