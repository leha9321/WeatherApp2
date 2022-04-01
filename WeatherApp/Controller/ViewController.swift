//
//  ViewController.swift
//  WeaterApp
//
//  Created by Алексей Трофимов on 31.03.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var feelsTempLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    
    var networkManager = Network()
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.onCompletion = { [weak self] curentWeather in
            guard let self = self else { return }
            self.updateInterface(weather: curentWeather)
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
    }
    
    @IBAction func searchCityPressed(_ sender: UIButton) {
        self.searchAlert(title: "Enter city name", message: nil, style: .alert) { [unowned self] cityName in
            self.networkManager.fetchWeather(requestType: .cityName(city: cityName))
        }
    }
    func updateInterface(weather: CurentWeather){
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.tempLabel.text = weather.temperatureString
            self.feelsTempLabel.text = weather.feelsLikeTemperatureString
            self.weatherImage.image = UIImage(systemName: weather.systemIcon)
        }
    }
    
}

extension ViewController {
    
    func searchAlert(title: String?, message: String?, style: UIAlertController.Style, complitionHandler: @escaping (String)-> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addTextField { textField in
            textField.placeholder = "Moscow"
        }
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textField = alert.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                complitionHandler(city)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(search)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        networkManager.fetchWeather(requestType: .coordinate(latitude: latitude, longitude: longitude))
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

}

