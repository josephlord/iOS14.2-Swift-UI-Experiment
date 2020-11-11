//
//  iOS14_2SwiftUIExperimentApp.swift
//  iOS14-2SwiftUIExperiment
//
//  Created by Joseph on 11/11/2020.
//

import SwiftUI

@main
struct iOS14_2SwiftUIExperimentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
