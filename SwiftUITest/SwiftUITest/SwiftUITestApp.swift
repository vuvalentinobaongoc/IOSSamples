//
//  SwiftUITestApp.swift
//  SwiftUITest
//
//  Created by Ngoc Vũ on 25/05/2022.
//

import SwiftUI

@main
struct SwiftUITestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TestLazyStack()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
