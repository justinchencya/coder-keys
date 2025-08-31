//
//  ProgrammerKeyboardApp.swift
//  ProgrammerKeyboard
//
//  Created by Justin Chen on 8/30/25.
//

import SwiftUI

@main
struct ProgrammerKeyboardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
