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

    @StateObject var counter = Counter()
    var body: some Scene {
        WindowGroup {
            ContentView(counter: counter)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
