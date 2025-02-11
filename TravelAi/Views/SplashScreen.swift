import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color("AccentColor")
                .ignoresSafeArea()
            
            VStack {
                Text("TravelAI")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .opacity(isAnimating ? 1 : 0)
                
                Image(systemName: "airplane")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .opacity(isAnimating ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    SplashScreen()
} 