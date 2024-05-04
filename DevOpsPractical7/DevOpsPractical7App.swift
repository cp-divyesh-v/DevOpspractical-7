//
//  DevOpsPractical7App.swift
//  DevOpsPractical7
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import SwiftUI
import FirebaseCore

@main
struct DevOpsPractical7App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContactListView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
