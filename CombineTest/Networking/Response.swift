//
//  Response.swift
//  CombineTest
//
//  Created by Роман on 29.11.2021.
//

import Foundation



struct WeeklyForecastResponse: Codable {
  let list: [Item]
  
  struct Item: Codable {
    let date: Date
    let main: MainClass
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
      case date = "dt"
      case main
      case weather
    }
  }
  
  struct MainClass: Codable {
    let temp: Double
  }
  
  struct Weather: Codable {
    let main: MainEnum
    let weatherDescription: String
    
    enum CodingKeys: String, CodingKey {
      case main
      case weatherDescription = "description"
    }
  }
  
  enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
  }
}

struct CurrentWeatherForecastResponse: Decodable {
  let coord: Coord
  let main: Main
  
  struct Main: Codable {
    let temperature: Double
    let humidity: Int
    let maxTemperature: Double
    let minTemperature: Double
    
    enum CodingKeys: String, CodingKey {
      case temperature = "temp"
      case humidity
      case maxTemperature = "temp_max"
      case minTemperature = "temp_min"
    }
  }
  
  struct Coord: Codable {
    let lon: Double
    let lat: Double
  }
}



enum WeatherError: Error {
  case parsing(description: String)
  case network(description: String)
}
