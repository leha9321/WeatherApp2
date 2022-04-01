//
//  CurentWeather.swift
//  WeaterApp
//
//  Created by Алексей Трофимов on 01.04.2022.
//

import Foundation

struct CurentWeather {
    let cityName: String
    let temperature: Double
    var temperatureString : String {
        return  String(format: "%.0f", temperature)
    }
    
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return  String(format: "%.0f", feelsLikeTemperature)
    }
    let codeId: Int
    var systemIcon: String {
        switch codeId {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.min.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    
    init?(weatherModel: WeatherModel){
        cityName = weatherModel.name
        temperature = weatherModel.main.temp
        feelsLikeTemperature = weatherModel.main.feels_like
        codeId = weatherModel.weather.first!.id
    }
}
