//
//  File.swift
//  WeaterApp
//
//  Created by Алексей Трофимов on 31.03.2022.
//

import Foundation
import CoreLocation

struct Network {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    var onCompletion: ((CurentWeather)-> Void)?
    
    func fetchWeather(requestType: RequestType) {
        var urlString = ""
        switch requestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=0af3affdacc7136c6f5423afeae67ca0&units=metric"
        case .coordinate(let latitude, let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=0af3affdacc7136c6f5423afeae67ca0&units=metric"
        }
        performRequest(urlString: urlString)
    }
    
    
    
    func performRequest(urlString: String){
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let curentWeather = self.parseJSON(data: data) {
                    self.onCompletion?(curentWeather)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(data: Data) -> CurentWeather? {
        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(WeatherModel.self, from: data)
            guard let curentWeather = CurentWeather(weatherModel: weatherData)
            else {
                return nil
            }
            return curentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
