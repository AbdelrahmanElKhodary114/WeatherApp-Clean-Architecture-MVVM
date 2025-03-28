import SwiftUI

struct MainTabView: View {
    init() {
        // Customize the tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.7) // Semi-transparent black
        
        // Apply to all tab bars in the app
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
            WeatherView()
                .tabItem {
                    Image(systemName: "cloud.sun.fill")
                    Text("Weather")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
        }
        .accentColor(.white)
    }
}
