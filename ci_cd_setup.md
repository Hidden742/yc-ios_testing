# CI/CD Setup Guide

## Overview
This document provides step-by-step instructions to set up continuous integration and deployment for the Youth Club iOS app using GitHub Actions and Codemagic.

## Prerequisites

### Apple Developer Account
1. **Apple Developer Program membership** ($99/year)
2. **App Store Connect access**
3. **iOS Distribution Certificate**
4. **Provisioning Profiles** for App Store distribution
5. **App Store Connect API Key**

### Development Environment
- macOS machine for iOS development
- Xcode 15.0+ installed
- Flutter SDK 3.16+ installed
- Git repository on GitHub

## GitHub Actions Setup

### Step 1: Repository Secrets
Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

```
IOS_CERTIFICATE_BASE64          # Base64 encoded .p12 certificate
IOS_CERTIFICATE_PASSWORD        # Password for .p12 certificate
IOS_PROVISIONING_PROFILE_BASE64 # Base64 encoded provisioning profile
KEYCHAIN_PASSWORD               # Password for build keychain
EXPORT_OPTIONS_PLIST           # Export options plist content
ALTOOL_USERNAME                # Apple ID for App Store uploads
ALTOOL_PASSWORD                # App-specific password for Apple ID
SLACK_WEBHOOK_URL              # Optional: Slack notifications
```

### Step 2: Prepare Certificate and Provisioning Profile

#### Export Certificate:
```bash
# Export certificate from Keychain Access as .p12
# Convert to base64:
base64 -i YourCertificate.p12 | pbcopy
```

#### Export Provisioning Profile:
```bash
# Download from Apple Developer portal
# Convert to base64:
base64 -i YourProfile.mobileprovision | pbcopy
```

#### Create ExportOptions.plist:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>com.youthclub.app</key>
        <string>YOUR_PROVISIONING_PROFILE_NAME</string>
    </dict>
    <key>signingStyle</key>
    <string>manual</string>
</dict>
</plist>
```

### Step 3: App Store Connect API Key
1. Go to App Store Connect → Users and Access → Keys
2. Generate new API key with App Manager role
3. Download the .p8 file
4. Note the Key ID and Issuer ID

## Codemagic Setup

### Step 1: Connect Repository
1. Sign up at [codemagic.io](https://codemagic.io)
2. Connect your GitHub repository
3. Import the `codemagic.yaml` configuration

### Step 2: Environment Variables
Add these in Codemagic dashboard (App Settings → Environment variables):

```
APP_STORE_CONNECT_ISSUER_ID      # From App Store Connect API
APP_STORE_CONNECT_KEY_IDENTIFIER # From App Store Connect API  
APP_STORE_CONNECT_PRIVATE_KEY    # Content of .p8 file
CERTIFICATE_PRIVATE_KEY          # Base64 encoded certificate
CM_PROVISIONING_PROFILE         # Base64 encoded provisioning profile
```

### Step 3: Code Signing
1. Upload iOS Distribution Certificate (.p12)
2. Upload Provisioning Profile
3. Configure bundle identifier: `com.youthclub.app`

## Firebase Setup for CI/CD

### Add GoogleService-Info.plist
1. Download from Firebase Console
2. Add to repository: `ios/Runner/GoogleService-Info.plist`
3. Update `.gitignore` if needed for security

## Build Triggers

### GitHub Actions
- **Push to `main`**: Full build + TestFlight upload
- **Push to `develop`**: Build only (no upload)  
- **Pull Requests**: Build + test only

### Codemagic
- **Push to `main`/`develop`**: TestFlight upload
- **Git tags (`v*.*.*`)**: App Store submission

## TestFlight Distribution

### Manual Steps After CI Build:
1. Go to App Store Connect → TestFlight
2. Add internal testers
3. Add external testers (requires Apple review)
4. Configure test information and release notes

### Automated Release Notes:
The CI pipeline can automatically generate release notes from:
- Git commit messages
- Pull request descriptions  
- CHANGELOG.md file

## App Store Submission Checklist

### Before First Submission:
- [ ] App Store Connect app record created
- [ ] App metadata filled out
- [ ] Screenshots uploaded (all required sizes)
- [ ] App description and keywords optimized
- [ ] Privacy policy URL added
- [ ] Age rating configured
- [ ] Pricing and availability set

### For Each Release:
- [ ] Build uploaded via CI/CD
- [ ] Build processed successfully in TestFlight
- [ ] Internal testing completed
- [ ] External testing completed (if applicable)
- [ ] Release notes prepared
- [ ] Marketing assets updated
- [ ] Submit for review

## Troubleshooting

### Common Issues:
1. **Code signing failures**: Verify certificate/profile validity
2. **Build timeouts**: Check for dependency issues
3. **TestFlight upload failures**: Verify App Store Connect API key permissions

### Debug Commands:
```bash
# Check certificate validity
security find-identity -v -p codesigning

# Verify provisioning profile
security cms -D -i profile.mobileprovision

# Flutter build locally  
flutter build ios --release --verbose
```

## Monitoring and Notifications

### Build Status:
- GitHub: Check Actions tab for build status
- Codemagic: Dashboard shows build history and logs

### Notifications:
- Slack: Configured for success/failure alerts
- Email: Sent to configured recipients  
- GitHub: Status checks on pull requests

## Security Best Practices

1. **Rotate secrets regularly**: Update certificates/profiles annually
2. **Limit access**: Only necessary team members have CI/CD access
3. **Audit logs**: Review build logs for security issues
4. **Secure storage**: Never commit secrets to repository
5. **Environment separation**: Use different configs for dev/prod

---

**Note**: Replace placeholder values with your actual Apple Developer account information before using these configurations.
