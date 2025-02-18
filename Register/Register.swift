//
//  Register.swift
//  Register
//

import SwiftUI
import os

struct Register {
  static let bundle = "net.syfaro.Register"
  static let logger = Logger(subsystem: bundle, category: "Main")

  static let squareApplicationId = "sandbox-sq0idb-dT6m-hL5rBKyjTl7A8nCNQ"

  static let fallbackThemeColor = Color(red: 255, green: 0, blue: 255)
  static let fallbackURL = URL(string: "https://www.google.com")!

  static let simulatedQRCode =
    #"{"terminalName": "name", "host": "http://localhost:8080", "token": "helloworld"}"#
}
