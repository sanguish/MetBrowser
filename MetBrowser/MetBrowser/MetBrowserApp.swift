//
//  MetBrowserApp.swift
//  MetBrowser
//
//  Created by Scott Anguish on 6/12/24.
//

import SwiftUI

@main
struct MetBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .frame(minWidth: 400.0, minHeight: 400.0)
        }
    }
}
