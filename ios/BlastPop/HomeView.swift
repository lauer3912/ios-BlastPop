import SwiftUI

struct HomeView: View {
    @EnvironmentObject var bubbleManager: BubbleManager
    @EnvironmentObject var soundManager: SoundManager
    @State private var showPopAnimation = false
    @State private var lastPopLocation: CGPoint = .zero

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(hex: "1a0a2e")
                    .ignoresSafeArea()

                ForEach(bubbleManager.bubbles) { bubble in
                    BubbleView(bubble: bubble)
                        .position(
                            x: bubble.position.x * geometry.size.width,
                            y: bubble.position.y * geometry.size.height
                        )
                        .onTapGesture {
                            lastPopLocation = CGPoint(
                                x: bubble.position.x * geometry.size.width,
                                y: bubble.position.y * geometry.size.height
                            )
                            bubbleManager.popBubble(bubble)
                            soundManager.playPopSound()
                            withAnimation(.spring()) {
                                showPopAnimation = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showPopAnimation = false
                            }
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onEnded { value in
                                    bubbleManager.popBubbleAt(value.location, in: geometry.size)
                                    soundManager.playPopSound()
                                }
                        )
                }

                if showPopAnimation {
                    PopExplosionView(center: lastPopLocation)
                        .transition(.scale.combined(with: .opacity))
                }

                VStack {
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 8) {
                            Label("0", systemImage: "flame.fill")
                                .foregroundColor(.orange)
                            Label("0", systemImage: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        .padding()
                    }
                    Spacer()
                }

                if bubbleManager.bubbles.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        Text("Tap anywhere to pop!")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.5))
                        Button("Generate Bubbles") {
                            bubbleManager.generateBubbles()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .onAppear {
            if bubbleManager.bubbles.isEmpty {
                bubbleManager.generateBubbles()
            }
        }
    }
}

struct BubbleView: View {
    let bubble: Bubble

    var body: some View {
        ZStack {
            bubble.shape.path
                .fill(
                    RadialGradient(
                        colors: [bubble.color.opacity(0.9), bubble.color.opacity(0.6)],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 0.8
                    )
                )
                .frame(width: bubble.size, height: bubble.size)
                .shadow(color: bubble.color.opacity(0.5), radius: 10, x: 0, y: 5)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(0.4), .clear],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: bubble.size * 0.3
                    )
                )
                .frame(width: bubble.size * 0.4, height: bubble.size * 0.4)
                .offset(x: -bubble.size * 0.2, y: -bubble.size * 0.2)
        }
    }
}

struct PopExplosionView: View {
    let center: CGPoint
    @State private var particles: [Particle] = []

    struct Particle: Identifiable {
        let id = UUID()
        var position: CGPoint
        var color: Color
        var scale: CGFloat
    }

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.scale * 20, height: particle.scale * 20)
                    .position(particle.position)
            }
        }
        .onAppear {
            let colors: [Color] = [.yellow, .orange, .pink, .purple, .cyan]
            particles = (0..<12).map { _ in
                let angle = CGFloat.random(in: 0..<2 * .pi)
                let distance = CGFloat.random(in: 50...100)
                return Particle(
                    position: CGPoint(
                        x: center.x + cos(angle) * distance,
                        y: center.y + sin(angle) * distance
                    ),
                    color: colors.randomElement()!,
                    scale: CGFloat.random(in: 0.5...1.5)
                )
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(BubbleManager())
        .environmentObject(SoundManager())
}