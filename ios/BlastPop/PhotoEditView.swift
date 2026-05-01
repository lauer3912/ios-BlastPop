import SwiftUI
import PhotosUI

struct PhotoEditView: View {
    @State private var selectedImage: UIImage?
    @State private var bubbles: [PhotoBubble] = []
    @State private var showImagePicker = false
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "1a0a2e")
                    .ignoresSafeArea()

                if let image = selectedImage {
                    VStack(spacing: 0) {
                        ZStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()

                            ForEach(bubbles) { bubble in
                                PhotoBubbleView(bubble: bubble)
                            }
                        }
                        .frame(maxHeight: .infinity)

                        HStack(spacing: 20) {
                            Button {
                                addBubble(shape: .circle)
                            } label: {
                                VStack {
                                    Image(systemName: "circle.fill")
                                        .font(.title)
                                    Text("Circle")
                                        .font(.caption2)
                                }
                            }

                            Button {
                                addBubble(shape: .square)
                            } label: {
                                VStack {
                                    Image(systemName: "square.fill")
                                        .font(.title)
                                    Text("Square")
                                        .font(.caption2)
                                }
                            }

                            Button {
                                addBubble(shape: .star)
                            } label: {
                                VStack {
                                    Image(systemName: "star.fill")
                                        .font(.title)
                                    Text("Star")
                                        .font(.caption2)
                                }
                            }

                            Button {
                                addBubble(shape: .heart)
                            } label: {
                                VStack {
                                    Image(systemName: "heart.fill")
                                        .font(.title)
                                    Text("Heart")
                                        .font(.caption2)
                                }
                            }

                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                VStack {
                                    Image(systemName: "photo.fill")
                                        .font(.title)
                                    Text("Photo")
                                        .font(.caption2)
                                }
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(hex: "2a1a3e"))
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 80))
                            .foregroundColor(.purple.opacity(0.5))

                        Text("Import a photo to add bubbles")
                            .foregroundColor(.white.opacity(0.7))

                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Label("Choose Photo", systemImage: "photo")
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
            .navigationTitle("Photo Bubbles")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage = image
                    }
                }
            }
        }
    }

    func addBubble(shape: PhotoBubble.BubbleShape) {
        let centerX = CGFloat.random(in: 0.2...0.8)
        let centerY = CGFloat.random(in: 0.3...0.7)
        let bubble = PhotoBubble(
            id: UUID(),
            position: CGPoint(x: centerX, y: centerY),
            size: CGSize(width: 80, height: 80),
            shape: shape,
            color: [.pink, .purple, .cyan, .yellow, .orange].randomElement()!
        )
        bubbles.append(bubble)
    }
}

struct PhotoBubble: Identifiable {
    let id: UUID
    var position: CGPoint
    var size: CGSize
    var shape: BubbleShape
    var color: Color

    enum BubbleShape: String, CaseIterable {
        case circle, square, star, heart
    }
}

struct PhotoBubbleView: View {
    let bubble: PhotoBubble
    @State private var isDragging = false
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        Group {
            switch bubble.shape {
            case .circle:
                Circle().fill(bubble.color.opacity(0.7))
            case .square:
                Rectangle().fill(bubble.color.opacity(0.7))
            case .star:
                Image(systemName: "star.fill").foregroundColor(bubble.color)
                    .font(.system(size: 60))
            case .heart:
                Image(systemName: "heart.fill").foregroundColor(bubble.color)
                    .font(.system(size: 60))
            }
        }
        .frame(width: bubble.size.width, height: bubble.size.height)
        .position(
            x: bubble.position.x * UIScreen.main.bounds.width + dragOffset.width,
            y: bubble.position.y * UIScreen.main.bounds.height * 0.6 + dragOffset.height
        )
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    dragOffset = .zero
                }
        )
    }
}

#Preview {
    PhotoEditView()
}