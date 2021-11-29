//
//  HTTPNetworkRequest.swift
//  CombineTest
//
//  Created by Роман on 29.11.2021.
//

// Этот объект отвечает за выборку информации из OpenWeatherMap API, анализ данных и предоставление их потребителю.
import Foundation
import Combine


protocol WeatherFetchable {
  // Вы будете использовать первый метод для первого экрана, чтобы отобразить прогноз погоды на следующие пять дней.
  /// - AnyPublisher - то, что будет выполняться после того, как вы на них подпишетесь.
  /// - Первый параметр относится к типу, которой он возвращает, если вычисление прошло успешно
  /// - Второй параметр это тип ошибки
  func weeklyWeatherForecast(forCity city: String) -> AnyPublisher<WeeklyForecastResponse, WeatherError>
  
  // Второй вы будете использовать для просмотра более подробной информации о погоде.
  func currentWeatherForecast(forCity city: String) -> AnyPublisher<CurrentWeatherForecastResponse, WeatherError>
}



class WeatherFetcher {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
}

// MARK: - OpenWeatherMap API
private extension WeatherFetcher {
  struct OpenWeatherAPI {
    static let scheme = "https"
    static let host = "api.openweathermap.org"
    static let path = "/data/2.5"
    static let key = "4f6192813fa5998637425d2413c5b0aa"
  }
  
  // возвращает компоненты сетевого запроса на неделю
  func makeWeeklyForecastComponents(withCity city: String) -> URLComponents {
    var components = URLComponents()
    components.scheme = OpenWeatherAPI.scheme
    components.host = OpenWeatherAPI.host
    components.path = OpenWeatherAPI.path + "/forecast"
    
    components.queryItems = [
      URLQueryItem(name: "q", value: city),
      URLQueryItem(name: "mode", value: "json"),
      URLQueryItem(name: "units", value: "metric"),
      URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
    ]
    
    return components
  }
  
  // возвращает компоненты сетевого запроса на день
  func makeCurrentDayForecastComponents(withCity city: String) -> URLComponents {
    var components = URLComponents()
    components.scheme = OpenWeatherAPI.scheme
    components.host = OpenWeatherAPI.host
    components.path = OpenWeatherAPI.path + "/weather"
    
    components.queryItems = [
      URLQueryItem(name: "q", value: city),
      URLQueryItem(name: "mode", value: "json"),
      URLQueryItem(name: "units", value: "metric"),
      URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
    ]
    
    return components
  }
  
  
  
}



// Реализация методов протокола
// MARK: - WeatherFetchable
extension WeatherFetcher: WeatherFetchable {
  func weeklyWeatherForecast(forCity city: String) -> AnyPublisher<WeeklyForecastResponse, WeatherError> {
    return forecast(with: makeWeeklyForecastComponents(withCity: city)) // forecast принимает URLComponents, а функция makeWeeklyForecastComponents их возвращает, значит ее можно передать как вычисляемое свойство
  }

  func currentWeatherForecast(forCity city: String) -> AnyPublisher<CurrentWeatherForecastResponse, WeatherError> {
    return forecast(with: makeCurrentDayForecastComponents(withCity: city))
  }

  // возвращает какой-то объект подписанный под протокол Decodable, либо ошибку
  private func forecast<T>(with components: URLComponents) -> AnyPublisher<T, WeatherError> where T: Decodable {
    
    // извлекаем url из компонентов, если неудача, то возвращаем ошибку ЧЕРЕЗ ОПЕРАТОР Fail
    guard let url = components.url else {
      let error = WeatherError.network(description: "Couldn't create URL")
      return Fail(error: error).eraseToAnyPublisher()
      ///Используйте eraseToAnyPublisher (), чтобы предоставить нижестоящему подписчику экземпляр AnyPublisher, а не фактический тип этого издателя. Эта форма стирания типов сохраняет абстракцию за пределами границ API, например между различными модулями. Когда вы выставляете своих издателей как тип AnyPublisher, вы можете со временем изменить базовую реализацию, не затрагивая существующих клиентов.
    }

    // Возвращает издателя, который обертывает задачу данных сеанса URL для заданного запроса URL.
    /// Издатель публикует данные, когда задача завершается, или завершает ее, если задача завершается с ошибкой.
    return session.dataTaskPublisher(for: URLRequest(url: url))
      // Преобразует любую ошибку вышестоящего издателя в новую ошибку.
      .mapError { error in
        ///Используйте оператор Publisher / mapError (_ :), когда вам нужно заменить один тип ошибки другим, или когда нижестоящему оператору нужно, чтобы типы ошибок его входных данных совпадали.
        .network(description: error.localizedDescription) // идет автоматическая привязка к WeatherError
      }
      // Преобразуем данные, поступающие с серва в виде Json в полноценный объект
    /// Поскольку нас интересует только первое значение, испускаемое сетевым запросом, то .max(1)
      .flatMap(maxPublishers: .max(1)) { pair in
        decode(pair.data)
      }

      // если это не использовать, то придется переносить полный тип, возвращаемый flatMap Publishers.FlatMap<AnyPublisher<_, WeatherError>, Publishers.MapError<URLSession.DataTaskPublisher, WeatherError>>
    // чтобы не возиться с этим типом, мы его стираем до типа AnyPublisher
      .eraseToAnyPublisher()
  }
}

