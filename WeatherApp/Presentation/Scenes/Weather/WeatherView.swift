import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            BackgroundGradientView()
                .edgesIgnoringSafeArea(.all)
            
            switch viewModel.viewState {
            case .loading:
                loadingView
            case .error:
                errorView
            case .loaded:
                weatherContentView
            }
        }
        .overlay(refreshButton, alignment: .bottomTrailing)
        .onAppear {
            viewModel.fetchWeather()
        }
    }
        
    private var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            Text("Fetching weather data...")
                .foregroundColor(.white)
                .padding(.top, 20)
        }
    }
    
    private var errorView: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.white)
            Text(viewModel.errorMessage)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
            Button(action: {
                viewModel.fetchWeather()
            }) {
                Text("Retry")
                    .foregroundColor(.blue)
                    .padding()
                    .padding(.horizontal, 32)
                    .background(Color.white)
                    .cornerRadius(20)
            }
        }
        .padding()
    }
    
    private var weatherContentView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Weather animation with floating effect
            LottieDisplayerView(fileName: viewModel.weather.mainCondition.lottieAnimationName)
                .frame(width: 200, height: 200)
            // Temperature
            Text(viewModel.weather.temperature)
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                .padding(.vertical, 8)
            
            // Location
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.white.opacity(0.8))
                Text(viewModel.weather.cityName)
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            // Condition
            Text(viewModel.weather.mainCondition.rawValue.capitalized)
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))
                .padding(.top, 8)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private var refreshButton: some View {
        if viewModel.errorMessage.isEmpty {
            Button(action: {
                viewModel.fetchWeather()
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20)
        }
    }
}
