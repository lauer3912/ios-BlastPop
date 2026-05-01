import SwiftUI
import CoreHaptics

struct Bubble: Identifiable, Equatable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var shape: BubbleShape
    var isPopped = false

    enum BubbleShape: String, CaseIterable {
        case circle, square, star, heart

        var path: Path {
            switch self {
            case .circle:
                return Path(ellipseIn: CGRect(x: 0, y: 0, width: 1, height: 1))
            case .square:
                return Path(CGRect(x: 0, y: 0, width: 1, height: 1))
            case .star:
                return starPath()
            case .heart:
                return heartPath()
            }
        }

        private func starPath() -> Path {
            var path = Path()
            let points = 5
            let innerRadius: CGFloat = 0.35
            let outerRadius: CGFloat = 0.5
            for i in 0..<points * 2 {
                let radius = i % 2 == 0 ? outerRadius : innerRadius
                let angle = CGFloat(i) * .pi / CGFloat(points) - .pi / 2
                let point = CGPoint(x: 0.5 + radius * cos(angle), y: 0.5 + radius * sin(angle))
                if i == 0 { path.move(to: point) } else { path.addLine(to: point) }
            }
            path.closeSubpath()
            return path
        }

        private func heartPath() -> Path {
            var path = Path()
            path.move(to: CGPoint(x: 0.5, y: 0.85))
            path.addCurve(to: CGPoint(x: 0.5, y: 0.5), control1: CGPoint(x: 0.8, y: 0.7), control2: CGPoint(x: 0.8, y: 0.5))
            path.addCurve(to: CGPoint(x: 0.5, y: 0.85), control1: CGPoint(x: 0.2, y: 0.5), control2: CGPoint(x: 0.2, y: 0.7))
            return path
        }
    }
}

class BubbleManager: ObservableObject {
    @Published var bubbles: [Bubble] = []
    private var hapticEngine: CHHapticEngine?

    init() {
        prepareHaptics()
        generateBubbles()
    }

    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {}
    }

    func generateBubbles() {
        bubbles = (0..<15).map { _ in
            Bubble(
                position: CGPoint(x: CGFloat.random(in: 0.1...0.9), y: CGFloat.random(in: 0.1...0.9)),
                size: CGFloat.random(in: 50...100),
                color: [Color.pink, Color.purple, Color.cyan, Color.yellow, Color.green, Color.orange].randomElement()!,
                shape: Bubble.BubbleShape.allCases.randomElement()!
            )
        }
    }

    func popBubble(_ bubble: Bubble) {
        if let index = bubbles.firstIndex(where: { $0.id == bubble.id }) {
            bubbles.remove(at: index)
            playHaptic()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.bubbles.append(self.createNewBubble())
            }
        }
    }

    func popBubbleAt(_ location: CGPoint, in size: CGSize) {
        let normalizedLocation = CGPoint(x: location.x / size.width, y: location.y / size.height)
        if let bubble = bubbles.first(where: {
            let dx = $0.position.x - normalizedLocation.x
            let dy = $0.position.y - normalizedLocation.y
            return sqrt(dx*dx + dy*dy) < $0.size / size.width
        }) {
            popBubble(bubble)
        }
    }

    private func createNewBubble() -> Bubble {
        Bubble(
            position: CGPoint(x: CGFloat.random(in: 0.1...0.9), y: CGFloat.random(in: 0.1...0.9)),
            size: CGFloat.random(in: 50...100),
            color: [Color.pink, Color.purple, Color.cyan, Color.yellow, Color.green, Color.orange].randomElement()!,
            shape: Bubble.BubbleShape.allCases.randomElement()!
        )
    }

    private func playHaptic() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
}