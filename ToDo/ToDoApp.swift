//
//  ToDoApp.swift
//  ToDo
//
//  Created by Robert Mayore on 12/11/2020.
//

import SwiftUI

@main
struct ToDoApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct ToDoApp_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
