//
//  DataManager.swift
//  Todo App
//
//  Created by Burak 2
//

import Foundation

// 📂 **JSON Save Function**
func saveFoldersToFile(folders: [Folder]) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    do {
        let encodedData = try encoder.encode(folders)
        let url = getDocumentsDirectory().appendingPathComponent("folders.json")
        try encodedData.write(to: url)
    } catch {
        print("⚠️ Error saving folders: \(error.localizedDescription)")
    }
}

// 📂 **JSON Load Function**
func loadFoldersFromFile() -> [Folder] {
    let url = getDocumentsDirectory().appendingPathComponent("folders.json")

    if let data = try? Data(contentsOf: url) {
        let decoder = JSONDecoder()
        if let loadedFolders = try? decoder.decode([Folder].self, from: data) {
            return loadedFolders
        }
    }
    return []
}

// 📂 **Documents Directory**
func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

