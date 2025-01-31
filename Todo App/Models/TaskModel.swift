//
//  TaskModel.swift
//  Todo App
//
//  Created by Burak 2 on 2025-01-31.
//

import Foundation

// Görev Modeli
struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}

// Klasör Modeli
struct Folder: Identifiable {
    let id = UUID()
    var name: String
    var tasks: [Task]
}
