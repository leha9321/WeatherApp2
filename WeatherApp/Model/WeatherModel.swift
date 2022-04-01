//
//  WeatherModel.swift
//  WeaterApp
//
//  Created by Алексей Трофимов on 01.04.2022.
//

import Foundation

struct WeatherModel: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Main: Decodable {
    let temp, feels_like: Double
}

struct Weather: Decodable {
    let id: Int
}

