//
//  WeeklyWeatherViewModel.swift
//  CombineTest
//
//  Created by Роман on 29.11.2021.
//

import Combine
import Foundation

// 1 - Благодаря этим протоколам, свойства модели можно использовать для привязок
// ObservableObject - когда объект, который подписан под этот протокол изменяется или изменияет свои свойства @Published, то он уведомляет об этом своих подписчиков
// Identifiable - объект с этим протоколом, может гарантировать единственность его значений аля синглтон

// 2 - Приписка @Published, позволяет наблюдать за этим объектом, аля издатель

// 3 - это источник данных для вью, вьюха будет подписываться под это свойство и изменять интерфейс при изменении свойства

// 4 - это коллекция ссылок на подписки, без их хранения сетевые запросы работать не будут поддерживаться

// 5 - Делаем запрос данных о погоде с сайта через метод протокола

// 6 - Сопоставляем ответ WeeklyForecastResponse с viewModel для ячейки таблицы, получается что для каждой view во viewController мы формируем собственную viewModel. При DailyWeatherRowViewModel.init, пришедшая модель инициализируется и парсится по своим полям, которые потом передадим в ячейку

// 7 - API возвращает несколько температур в тот же день, в зависимости от времени суток, так чтобы удалить дубликаты, используем расширение для типа Array

// 8 - Говорим, что хотим обновлять интерфейс, согласно пришедшим данным с серва, в главной очереди. Т.е мы получили данные и обработали их не в шлавной очереди, но после мы их хотим получить и дальше работать с ними в главной

// 9 - Запуск Издателя, тут мы и обновляем dataSource - за которым должны следить. Важно отметить, что обработка завершения - успешного или неудачного - происходит отдельно от обработки значений.

// 10 - В случае ошибки, dataSource - делаем пустым

// 11 - При получении данных, обновляем dataSource

// 12 - Добавляем коллекцию отменяемых ссылок(подписок). Как упоминалось ранее, без сохранения этой ссылки сетевой издатель немедленно прекратит работу.
 
//MARK: - 1
class WeeklyWeatherViewModel: ObservableObject, Identifiable {
  
  
//MARK: - 2
  @Published var city: String = ""
  
  
//MARK: - 3
  @Published var dataSource: [DailyWeatherRowViewModel] = []
  
  private let weatherFetcher: WeatherFetchable
  
//MARK: - 4
  private var disposables = Set<AnyCancellable>()
  
  /// этот код и соединяет combine c view
  // 1 сетевой запрос, указываем собственную очередь
  init(weatherFetcher: WeatherFetchable, scheduler: DispatchQueue = DispatchQueue(label: "WeatherViewModel")) {
    self.weatherFetcher = weatherFetcher
    
    // 2 $ - Это означает, что его можно наблюдать, а также можно использовать любой другой доступный метод Publisher
    $city
      // 3 Как только мы создаем наблюдение, параметр $city выдает первое значение, оно пустое, поэтому пропускаем его чтобы избежать лишнего сетевого запроса
      .dropFirst(1)
      // 4 чтобы запрос не срабатывал сразу же как пользователь вводит символ, делаем задержку на пол секунды и отправляем в свою очередь
      .debounce(for: .seconds(0.5), scheduler: scheduler)
      // 5 Включаем наблюдение за событием и обрабатываем с помощью функции fetchWeather
      .sink(receiveValue: fetchWeather(forCity:))
      // 6 Наконец, вы сохраняете отменяемое, как и раньше.
      .store(in: &disposables)
  }

  
  func fetchWeather(forCity city: String) {
    print(#function)
//MARK: - 5
    weatherFetcher.weeklyWeatherForecast(forCity: city)
      .map { response in
//MARK: - 6
        response.list.map(DailyWeatherRowViewModel.init)
      }
    
//MARK: - 7
      .map(Array.removeDuplicates)
    
//MARK: - 8
      .receive(on: DispatchQueue.main)
    
//MARK: - 9
      .sink( receiveCompletion: { [weak self] value in
          guard let self = self else { return }
          switch value {
          case .failure:
            print()
//MARK: - 10
            self.dataSource = []
          case .finished:
            break
          }
        },
        receiveValue: { [weak self] forecast in
          guard let self = self else { return }
//MARK: - 11
          self.dataSource = forecast
        })
    
//MARK: - 12
      .store(in: &disposables)
  }
  
}

//extension WeeklyWeatherViewModel {
//  var currentWeatherView: some View {
//    return WeeklyWeatherBuilder.makeCurrentWeatherView(withCity: city, weatherFetcher: weatherFetcher)
//  }
//}





