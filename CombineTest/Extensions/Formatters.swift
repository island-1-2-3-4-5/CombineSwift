//
//  Formatters.swift
//  CombineTest
//
//  Created by Роман on 29.11.2021.
//

import Foundation


let dayFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "dd"
  return formatter
}()

let monthFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "MMMM"
  return formatter
}()
