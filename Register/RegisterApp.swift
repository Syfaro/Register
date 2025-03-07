//
//  RegisterApp.swift
//  Register
//

import ComposableArchitecture
import SwiftUI

@main
struct RegisterApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      if !_XCTIsTesting {
        RegSetupView(
          store: Store(initialState: .init()) {
            RegSetupFeature()
          }
        )
      }
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  @Dependency(\.square) var square

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    square.initialize(launchOptions)

    return true
  }
}
