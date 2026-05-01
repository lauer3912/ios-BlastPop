import SwiftUI

@main
struct BlastPopApp: App {
    @StateObject private var bubbleManager = BubbleManager()
    @StateObject private var soundManager = SoundManager()
    @AppStorage("isDarkMode") private var isDarkMode = true

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bubbleManager)
                .environmentObject(soundManager)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}