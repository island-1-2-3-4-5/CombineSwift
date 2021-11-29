//
//  Array+Filtering.swift
//  CombineTest
//
//  Created by Роман on 29.11.2021.
//

import Foundation

// Убираем дубликаты 
public extension Array where Element: Hashable {
  static func removeDuplicates(_ elements: [Element]) -> [Element] {
    var seen = Set<Element>()
    return elements.filter{ seen.insert($0).inserted }
  }
}
