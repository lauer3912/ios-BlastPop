import SwiftUI

struct MoodWallView: View {
    @State private var moodBubbles: [MoodBubble] = []
    @State private var showAddSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "1a0a2e")
                    .ignoresSafeArea()

                if moodBubbles.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "heart.circle")
                            .font(.system(size: 80))
                            .foregroundColor(.pink.opacity(0.5))
                        Text("Your mood wall is empty")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                        Text("Tap + to add today's mood")
                            .foregroundColor(.white.opacity(0.5))
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 16) {
                            ForEach(moodBubbles) { bubble in
                                MoodBubbleCard(bubble: bubble)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Mood Wall")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddMoodBubbleView { newBubble in
                    moodBubbles.insert(newBubble, at: 0)
                }
            }
        }
    }
}

struct MoodBubble: Identifiable {
    let id = UUID()
    let date: Date
    let mood: MoodColor
    let text: String

    enum MoodColor: String, CaseIterable {
        case happy = "😊 Happy"
        case calm = "😌 Calm"
        case sad = "😢 Sad"
        case angry = "😠 Angry"
        case anxious = "😰 Anxious"

        var color: Color {
            switch self {
            case .happy: return .green
            case .calm: return .blue
            case .sad: return .purple
            case .angry: return .red
            case .anxious: return .orange
            }
        }
    }
}

struct MoodBubbleCard: View {
    let bubble: MoodBubble

    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(bubble.mood.color.gradient)
                .frame(width: 60, height: 60)
                .overlay(
                    Text(bubble.mood.rawValue.prefix(2))
                        .font(.caption)
                        .foregroundColor(.white)
                )

            Text(bubble.date.formatted(.dateTime.day()))
                .font(.caption2)
                .foregroundColor(.white.opacity(0.7))
        }
    }
}

struct AddMoodBubbleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMood: MoodBubble.MoodColor = .happy
    @State private var text = ""

    let onAdd: (MoodBubble) -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "1a0a2e")
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("How are you feeling?")
                        .font(.title2)
                        .foregroundColor(.white)

                    HStack(spacing: 12) {
                        ForEach(MoodBubble.MoodColor.allCases, id: \.self) { mood in
                            Button {
                                selectedMood = mood
                            } label: {
                                Circle()
                                    .fill(mood.color.gradient)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedMood == mood ? Color.white : Color.clear, lineWidth: 3)
                                    )
                            }
                        }
                    }

                    TextField("Write your feeling...", text: $text, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                        .padding(.horizontal)

                    Spacer()
                }
                .padding(.top, 40)
            }
            .navigationTitle("Add Mood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let bubble = MoodBubble(date: Date(), mood: selectedMood, text: text)
                        onAdd(bubble)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MoodWallView()
}