//
//  WeatherAppSwiftUiApp.swift
//  WeatherAppSwiftUi
//
//  Created by Meritocrat on 12/6/21.
//

import SwiftUI

@main
struct WeatherAppSwiftUiApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let viewModel = WeatherViewModel(weatherService: weatherService )
            WeatherView(viewModel: viewModel)
        }
    }
}
