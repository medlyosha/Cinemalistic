//
//  CinemalisticApp.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 14.08.2023.
//

import SwiftUI
@main
struct CinemalisticApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
