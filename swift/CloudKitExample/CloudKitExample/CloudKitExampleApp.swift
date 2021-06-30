//
//  CloudKitExampleApp.swift
//  CloudKitExample
//
//  Created by Jinwoo Kim on 6/30/21.
//

import SwiftUI

@main
struct CloudKitExampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
