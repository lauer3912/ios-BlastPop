import SwiftUI
import AVFoundation

class SoundManager: ObservableObject {
    @Published var isSoundEnabled = true
    @Published var isWhiteNoisePlaying = false
    @Published var selectedWhiteNoise: WhiteNoiseType = .rain
    
    private var audioPlayer: AVAudioPlayer?
    private var whiteNoisePlayer: AVAudioPlayer?
    
    enum WhiteNoiseType: String, CaseIterable {
        case rain = "Rain"
        case ocean = "Ocean"
        case fire = "Fire"
        case forest = "Forest"
        case cafe = "Cafe"
        
        var icon: String {
            switch self {
            case .rain: return "cloud.rain.fill"
            case .ocean: return "water.waves"
            case .fire: return "flame.fill"
            case .forest: return "leaf.fill"
            case .cafe: return "cup.and.saucer.fill"
            }
        }
    }
    
    func playPopSound() {
        guard isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1104)
    }
    
    func toggleWhiteNoise() {
        if isWhiteNoisePlaying {
            stopWhiteNoise()
        } else {
            startWhiteNoise()
        }
    }
    
    func startWhiteNoise() {
        isWhiteNoisePlaying = true
    }
    
    func stopWhiteNoise() {
        isWhiteNoisePlaying = false
        whiteNoisePlayer?.stop()
    }
}