# 💳 Subscription & Trial Implementation Guide

## 🎯 Overview

VoiceBubble needs a subscription system with:
- **1-day free trial** (was 7 days, now fixed)
- **Two plans**: Monthly ($5.99/mo) & Yearly ($49.99/yr)
- **Benefits**: 90 minutes speech-to-text, premium AI models, custom presets, cloud sync, priority support

---

## 🛠️ Recommended Solution: **RevenueCat**

RevenueCat is THE industry standard for Flutter subscriptions (used by Duolingo, Notion, etc.)

### Why RevenueCat?
- ✅ **Handles both iOS & Android** (Google Play & App Store)
- ✅ **Automatic receipt validation**
- ✅ **Free tier** for < $10k/month revenue
- ✅ **Built-in trial management**
- ✅ **Webhooks for backend integration**
- ✅ **Dashboard for analytics**

---

## 📦 Implementation Steps

### 1. Create RevenueCat Account
1. Go to [app.revenuecat.com](https://app.revenuecat.com)
2. Create a new project: **"VoiceBubble"**
3. Get your **API Keys**:
   - Public SDK key (for app)
   - Secret key (for backend)

---

### 2. Set Up Products

#### Google Play Console:
1. Go to **Monetization > Products > Subscriptions**
2. Create subscription IDs:
   - `voicebubble_monthly` → $5.99/month
   - `voicebubble_yearly` → $49.99/year
3. Set **1-day free trial** for both
4. Link products to RevenueCat

#### RevenueCat Dashboard:
1. Go to **Products**
2. Import Google Play products
3. Create **Entitlement**: `premium`
4. Attach both products to `premium` entitlement

---

### 3. Install Flutter Package

```bash
flutter pub add purchases_flutter
```

**pubspec.yaml:**
```yaml
dependencies:
  purchases_flutter: ^6.29.12
```

---

### 4. Initialize RevenueCat

**lib/services/subscription_service.dart:**

```dart
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionService {
  static const String _apiKey = 'YOUR_REVENUECAT_PUBLIC_KEY';
  
  static Future<void> initialize() async {
    await Purchases.setLogLevel(LogLevel.debug);
    
    PurchasesConfiguration configuration = PurchasesConfiguration(_apiKey);
    await Purchases.configure(configuration);
    
    // Set user ID (from Firebase Auth)
    // await Purchases.logIn(userID);
  }
  
  // Check if user has active subscription
  static Future<bool> isPremium() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all['premium']?.isActive ?? false;
    } catch (e) {
      debugPrint('Error checking premium: $e');
      return false;
    }
  }
  
  // Get available offerings
  static Future<Offerings?> getOfferings() async {
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('Error fetching offerings: $e');
      return null;
    }
  }
  
  // Purchase a package
  static Future<bool> purchasePackage(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      return customerInfo.entitlements.all['premium']?.isActive ?? false;
    } catch (e) {
      debugPrint('Purchase error: $e');
      return false;
    }
  }
  
  // Restore purchases
  static Future<bool> restorePurchases() async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.all['premium']?.isActive ?? false;
    } catch (e) {
      debugPrint('Restore error: $e');
      return false;
    }
  }
  
  // Get remaining trial time
  static Future<Duration?> getRemainingTrialTime() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      final entitlement = customerInfo.entitlements.all['premium'];
      
      if (entitlement != null && entitlement.periodType == PeriodType.trial) {
        final expirationDate = DateTime.parse(entitlement.expirationDate!);
        return expirationDate.difference(DateTime.now());
      }
      return null;
    } catch (e) {
      debugPrint('Error getting trial time: $e');
      return null;
    }
  }
}
```

---

### 5. Update Paywall Screen

**lib/screens/paywall/paywall_screen.dart:**

```dart
// In initState:
@override
void initState() {
  super.initState();
  _loadOfferings();
}

Future<void> _loadOfferings() async {
  final offerings = await SubscriptionService.getOfferings();
  if (offerings != null && offerings.current != null) {
    setState(() {
      _currentOffering = offerings.current!;
      // Set packages for monthly & yearly
      _monthlyPackage = _currentOffering!.monthly;
      _yearlyPackage = _currentOffering!.annual;
    });
  }
}

// In Subscribe button:
Future<void> _handleSubscribe() async {
  setState(() => _isLoading = true);
  
  final package = _selectedPlan == 'yearly' ? _yearlyPackage : _monthlyPackage;
  if (package == null) {
    _showError('Subscription not available');
    return;
  }
  
  final success = await SubscriptionService.purchasePackage(package);
  
  setState(() => _isLoading = false);
  
  if (success) {
    widget.onSubscribe();
  }
}

// In Restore button:
Future<void> _handleRestore() async {
  setState(() => _isLoading = true);
  final success = await SubscriptionService.restorePurchases();
  setState(() => _isLoading = false);
  
  if (success) {
    widget.onRestore();
  } else {
    _showError('No purchases found');
  }
}
```

---

### 6. Check Premium Status Throughout App

**Example: Before recording/rewriting:**

```dart
Future<void> _startRecording() async {
  final isPremium = await SubscriptionService.isPremium();
  
  if (!isPremium) {
    // Check if trial is active
    final trialTime = await SubscriptionService.getRemainingTrialTime();
    
    if (trialTime == null || trialTime.isNegative) {
      // Show paywall
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaywallScreen(...)),
      );
      return;
    }
  }
  
  // Continue with recording...
}
```

---

### 7. Backend Integration (Optional but Recommended)

RevenueCat webhooks notify your backend when:
- Trial starts/ends
- Subscription purchased/renewed/cancelled
- Refunds

**Backend endpoint:**
```javascript
// backend/routes/webhooks.js
router.post('/revenuecat', async (req, res) => {
  const event = req.body;
  
  if (event.type === 'INITIAL_PURCHASE') {
    // User subscribed
    await updateUserPremiumStatus(event.app_user_id, true);
  } else if (event.type === 'CANCELLATION') {
    // Subscription cancelled
    await updateUserPremiumStatus(event.app_user_id, false);
  }
  
  res.sendStatus(200);
});
```

---

### 8. Testing

#### Test Subscriptions (Google Play):
1. Add test account in Play Console
2. Use test cards in Google Pay
3. Subscriptions auto-expire after 5 minutes (test mode)

#### RevenueCat Sandbox:
- RevenueCat automatically detects sandbox purchases
- View test transactions in RevenueCat dashboard

---

## 📊 Tracking Usage (90 Minutes)

### Option A: Frontend Tracking (Simple)
Store usage in SharedPreferences:
```dart
class UsageTracker {
  static const String _key = 'speechToTextMinutes';
  
  static Future<double> getRemainingMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    final used = prefs.getDouble(_key) ?? 0.0;
    return max(0, 90.0 - used);
  }
  
  static Future<void> addUsage(double minutes) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getDouble(_key) ?? 0.0;
    await prefs.setDouble(_key, current + minutes);
  }
  
  static Future<void> reset() async {
    // Reset on subscription purchase/renewal
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
```

### Option B: Backend Tracking (Recommended)
Track per user in database:
- More accurate
- Can't be manipulated
- Syncs across devices

---

## 💰 Pricing Strategy

**Current Pricing:**
- Monthly: $5.99/month
- Yearly: $49.99/year (Save 30%)
- Trial: 1 day free

**What You Get:**
- 90 minutes of speech-to-text/month
- Premium AI models (GPT-4)
- Custom presets
- Cloud sync
- Priority support

---

## 🚀 Launch Checklist

- [ ] Create RevenueCat account
- [ ] Set up Google Play subscriptions
- [ ] Configure RevenueCat products & entitlements
- [ ] Add `purchases_flutter` package
- [ ] Implement `SubscriptionService`
- [ ] Update paywall screen
- [ ] Add premium checks throughout app
- [ ] Set up webhooks (optional)
- [ ] Test with sandbox
- [ ] Submit app for review
- [ ] Monitor in RevenueCat dashboard

---

## 📞 Support

**RevenueCat Docs:** https://www.revenuecat.com/docs  
**Flutter Integration:** https://www.revenuecat.com/docs/flutter  
**Community:** RevenueCat Slack

---

## 💡 Important Notes

1. **Trial Period:** Users get 1 day free trial, then charged
2. **Cancellation:** Users can cancel anytime in Google Play
3. **Refunds:** Handle via RevenueCat webhooks
4. **Family Sharing:** Can be enabled in Google Play Console
5. **Promo Codes:** Generate in Google Play Console

---

**FRONTEND vs BACKEND Logic:**

✅ **FRONTEND (Recommended for v1.0):**
- RevenueCat SDK handles everything
- Quick to implement
- Works offline (cached entitlements)
- Good for MVP

✅ **BACKEND (For future versions):**
- Track usage server-side
- Prevent manipulation
- Advanced analytics
- Multi-device sync

**For Play Store launch, use FRONTEND-ONLY with RevenueCat SDK. Backend can be added later!**

