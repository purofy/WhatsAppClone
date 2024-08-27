//
//  WhatsAppCloneApp.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 11.06.24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct WhatsAppCloneApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
      WindowGroup {
          RootScreen()
      }
  }
}
