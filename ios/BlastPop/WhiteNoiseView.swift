import SwiftUI

struct WhiteNoiseView: View {
    @EnvironmentObject var soundManager: SoundManager
    @State private var isTimerOn = false
    @State private var timerDuration = 15
    @State private var timeRemaining = 0
    @State private var timer: Timer?

    let durations = [5, 10, 15, 30, 60]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "1a0a2e")
                    .ignoresSafeArea()

                VStack(spacing: 32) {
                    Text("Relax & Pop")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    ZStack {
                        Circle()
                            .stroke(Color.purple.opacity(0.3), lineWidth: 20)
                            .frame(width: 200, height: 200)

                        if isTimerOn && timeRemaining > 0 {
                            Circle()
                                .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(timerDuration * 60))
                                .stroke(Color.purple, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                                .frame(width: 200, height: 200)
                                .rotationEffect(.degrees(-90))
                                .animation(.linear, value: timeRemaining)

                            Text(formatTime(timeRemaining))
                                .font(.system(size: 40, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        } else {
                            VStack {
                                Image(systemName: soundManager.selectedWhiteNoise.icon)
                                    .font(.system(size: 60))
                                    .foregroundColor(.purple)
                                Text(soundManager.selectedWhiteNoise.rawValue)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }

                    if !isTimerOn || timeRemaining > 0 {
                        HStack(spacing: 12) {
                            ForEach(durations, id: \.self) { duration in
                                Button {
                                    timerDuration = duration
                                    timeRemaining = duration * 60
                                } label: {
                                    Text("\(duration)m")
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(timerDuration == duration ? Color.purple : Color.gray.opacity(0.3))
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }

                    Button {
                        if isTimerOn {
                            stopTimer()
                        } else {
                            startTimer()
                        }
                    } label: {
                        HStack {
                            Image(systemName: isTimerOn ? "stop.fill" : "play.fill")
                            Text(isTimerOn ? "Stop" : "Start")
                        }
                        .font(.title2)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(Color.purple.gradient)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }

                    VStack(spacing: 16) {
                        Text("Background Sound")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 16) {
                            ForEach(SoundManager.WhiteNoiseType.allCases, id: \.self) { type in
                                Button {
                                    soundManager.selectedWhiteNoise = type
                                } label: {
                                    VStack(spacing: 8) {
                                        Image(systemName: type.icon)
                                            .font(.title2)
                                        Text(type.rawValue)
                                            .font(.caption)
                                    }
                                    .frame(width: 70, height: 70)
                                    .background(soundManager.selectedWhiteNoise == type ? Color.purple : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                    .padding()

                    Spacer()
                }
                .padding(.top, 40)
            }
        }
    }

    func startTimer() {
        if timeRemaining == 0 { timeRemaining = timerDuration * 60 }
        isTimerOn = true
        soundManager.startWhiteNoise()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
            }
        }
    }

    func stopTimer() {
        isTimerOn = false
        soundManager.stopWhiteNoise()
        timer?.invalidate()
        timer = nil
    }

    func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

#Preview {
    WhiteNoiseView()
        .environmentObject(SoundManager())
}