import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var soundManager: SoundManager
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("isHapticEnabled") private var isHapticEnabled = true
    @AppStorage("isNotificationsEnabled") private var isNotificationsEnabled = false
    @AppStorage("totalPops") private var totalPops = 0
    @AppStorage("totalMinutes") private var totalMinutes = 0
    @AppStorage("streakDays") private var streakDays = 0

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "1a0a2e")
                    .ignoresSafeArea()

                List {
                    Section("Statistics") {
                        HStack {
                            Label("Total Pops", systemImage: "hand.tap.fill")
                            Spacer()
                            Text("\(totalPops)")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Label("Relax Time", systemImage: "clock.fill")
                            Spacer()
                            Text("\(totalMinutes) min")
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Label("Streak", systemImage: "flame.fill")
                            Spacer()
                            Text("\(streakDays) days")
                                .foregroundColor(.orange)
                        }
                    }
                    .listRowBackground(Color(hex: "2a1a3e"))

                    Section("Preferences") {
                        Toggle(isOn: $soundManager.isSoundEnabled) {
                            Label("Sound Effects", systemImage: "speaker.wave.2.fill")
                        }
                        Toggle(isOn: $isHapticEnabled) {
                            Label("Haptic Feedback", systemImage: "hand.tap.fill")
                        }
                        Toggle(isOn: $isDarkMode) {
                            Label("Dark Mode", systemImage: "moon.fill")
                        }
                    }
                    .listRowBackground(Color(hex: "2a1a3e"))

                    Section("Notifications") {
                        Toggle(isOn: $isNotificationsEnabled) {
                            Label("Daily Reminder", systemImage: "bell.fill")
                        }
                        .onChange(of: isNotificationsEnabled) { _, newValue in
                            if newValue {
                                BlastNotificationService.shared.requestAuthorization { granted in
                                    if granted {
                                        BlastNotificationService.shared.scheduleDailyReminder()
                                    }
                                }
                            } else {
                                BlastNotificationService.shared.cancelNotification(identifier: "daily_reminder")
                            }
                        }
                    }
                    .listRowBackground(Color(hex: "2a1a3e"))

                    Section("Support") {
                        Link(destination: URL(string: "https://github.com/lauer3912/ios-BlastPop")!) {
                            Label("Rate App", systemImage: "star.fill")
                        }
                        Link(destination: URL(string: "mailto:support@techidaily.com")!) {
                            Label("Contact Us", systemImage: "envelope.fill")
                        }
                        NavigationLink {
                            PrivacyPolicyView()
                        } label: {
                            Label("Privacy Policy", systemImage: "hand.raised.fill")
                        }
                    }
                    .listRowBackground(Color(hex: "2a1a3e"))

                    Section {
                        HStack {
                            Spacer()
                            VStack {
                                Text("BlastPop")
                                    .font(.headline)
                                Text("Version 1.0.0")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Settings")
        }
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            Color(hex: "1a0a2e")
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Privacy Policy")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Last updated: May 1, 2026")
                        .foregroundColor(.secondary)

                    Text("""
                    BlastPop is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our app.

                    **Information We Collect**
                    - Photo library access (only when you explicitly import images)
                    - Usage statistics (bubble pops, session duration) stored locally on your device
                    - No personal data is transmitted to our servers

                    **Data Storage**
                    - All mood entries and preferences are stored locally on your device
                    - We do not use any cloud services for data storage
                    - You can delete all data by uninstalling the app

                    **Permissions**
                    - Photo Library: Used only for importing photos to add bubbles
                    - No location, camera, or microphone access required

                    **Third Parties**
                    - We do not share any data with third parties
                    - No analytics or tracking services are used

                    **Contact**
                    For privacy concerns, contact: support@techidaily.com
                    """)
                    .foregroundColor(.white.opacity(0.9))
                }
                .padding()
            }
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
        .environmentObject(SoundManager())
}