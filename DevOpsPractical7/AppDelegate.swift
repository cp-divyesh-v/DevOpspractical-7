//
//  AppDelegate.swift
//  DevOpsPractical7
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        configureFirebase()
        return true
    }
}

func configureFirebase() {
    var filePath:String!
#if DEBUG
    filePath = Bundle.main.path(forResource: "GoogleService-Info-dev", ofType: "plist")!
#else
    filePath = Bundle.main.path(forResource: "GoogleService-Info-prod", ofType: "plist")!
#endif

    let options = FirebaseOptions.init(contentsOfFile: filePath)!
    FirebaseApp.configure(options: options)
}
