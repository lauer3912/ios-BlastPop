import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)

            MoodWallView()
                .tabItem {
                    Label("Mood", systemImage: "heart.fill")
                }
                .tag(Tab.mood)

            PhotoEditView()
                .tabItem {
                    Label("Photo", systemImage: "photo.fill")
                }
                .tag(Tab.photo)

            WhiteNoiseView()
                .tabItem {
                    Label("Relax", systemImage: "moon.fill")
                }
                .tag(Tab.relax)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
        .tint(Color(hex: "7C6AFF"))
    }
}

enum Tab: String, CaseIterable {
    case home, mood, photo, relax, settings
}