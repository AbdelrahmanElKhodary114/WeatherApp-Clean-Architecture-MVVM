import SwiftUI

struct ProfileView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2),
                                                       Color(red: 0.2, green: 0.15, blue: 0.3)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            
            // Floating bubbles background
            BubbleBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Profile image with pulse animation
                    ZStack {
                        Circle()
                            .fill(AngularGradient(gradient: Gradient(colors: [.blue, .purple, .pink]),
                                                  center: .center,
                                                  angle: .degrees(isAnimating ? 360 : 0)))
                            .frame(width: 180, height: 180)
                            .shadow(color: .purple.opacity(0.6), radius: 20)
                            .animation(Animation.linear(duration: 6).repeatForever(autoreverses: false), value: isAnimating)
                        
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 120))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    .onAppear {
                        isAnimating = true
                    }
                    
                    // Name with cool typography
                    Text("Abdelrahman Elkhodary")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .purple.opacity(0.5), radius: 5, x: 0, y: 2)
                    
                    // Info cards
                    VStack(spacing: 20) {
                        ProfileCard(icon: "envelope.fill",
                                    title: "Email",
                                    value: "abdelrahman.elkhodary114@gmail.com",
                                    color: .blue)
                        
                        ProfileCard(icon: "phone.fill",
                                    title: "Phone",
                                    value: "+20123545898",
                                    color: .green)
                        
                        ProfileCard(icon: "location.fill",
                                    title: "Location",
                                    value: "Cairo, Egypt",
                                    color: .orange)
                    }
                    .padding(.horizontal, 20)
                    
                    // Social links
                    HStack(spacing: 25) {
                        SocialButton(icon: "globe", color: .purple)
                        SocialButton(icon: "camera.fill", color: .pink)
                        SocialButton(icon: "link", color: .blue)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
        }
    }
}

struct ProfileCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.08))
                .shadow(color: color.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct SocialButton: View {
    let icon: String
    let color: Color
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Handle social link tap
        }) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(color)
                        .shadow(color: color.opacity(0.5), radius: 8, x: 0, y: 5)
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
        }
        .pressAction {
            isPressed = true
        } onRelease: {
            isPressed = false
        }
    }
}

struct BubbleBackground: View {
    @State private var bubbles: [Bubble] = []
    
    struct Bubble {
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var opacity: Double
        var speed: Double
    }
    
    init() {
        // Create random bubbles
        for _ in 0..<15 {
            bubbles.append(Bubble(
                x: CGFloat.random(in: 0..<1),
                y: CGFloat.random(in: 0..<1),
                size: CGFloat.random(in: 20..<100),
                opacity: Double.random(in: 0.05..<0.2),
                speed: Double.random(in: 2..<5)
            ))
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<bubbles.count, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(bubbles[index].opacity))
                        .frame(width: bubbles[index].size, height: bubbles[index].size)
                        .position(
                            x: bubbles[index].x * geometry.size.width,
                            y: bubbles[index].y * geometry.size.height
                        )
                        .animation(
                            Animation.linear(duration: bubbles[index].speed)
                                .repeatForever(autoreverses: true),
                            value: bubbles[index].y
                        )
                        .onAppear {
                            // Make bubbles float up and down
                            withAnimation(Animation.linear(duration: bubbles[index].speed).repeatForever(autoreverses: true)) {
                                bubbles[index].y = CGFloat.random(in: 0..<1)
                            }
                        }
                }
            }
        }
    }
}

// Button press effect modifier
extension View {
    func pressAction(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(ButtonPressModifier(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}

struct ButtonPressModifier: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}
