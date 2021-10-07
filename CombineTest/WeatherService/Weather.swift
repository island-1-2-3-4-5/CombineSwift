//
//  Weather.swift
//  CombineTest
//
//  Created by Роман on 07.10.2021.
//

import Foundation
import Combine

// кастомная ошибка, будем её использовать
enum ExampleError: Swift.Error {
    case somethingWrong
}

class Weather {
    // тот за кем следят
    private  let weatherPublisher = PassthroughSubject<Int, ExampleError>() // - принимает 2 любых параметра, первый это то в каком типе мы хотим что-то получать, второй это тип ошибки или Never - нет ошибки
    private var subscriber: AnyCancellable?
    
    
    func test() {
        // тот кто следит
        subscriber = weatherPublisher.filter { $0 > 15 }.sink(receiveCompletion: { print($0)}) { value in
            print("Температура сегодня \(value) ℃")
        }
        /// filter - пропускаем значения больше 15
        /// sink - Этот метод создает подписчика и немедленно запрашивает неограниченное количество значений перед возвратом подписчика. Возвращаемое значение должно быть сохранено, иначе поток будет отменен.
        // когда придет новое значение погоды, вызываем того за кем следят и говорим ему чтобы он отсылал новые значения
        weatherPublisher.send(12)
        weatherPublisher.send(14)
        weatherPublisher.send(132)
        weatherPublisher.send(142)
        
        // если случается ошибка
        weatherPublisher.send(completion: Subscribers.Completion<ExampleError>.failure(ExampleError.somethingWrong))
        
    }
    
}
