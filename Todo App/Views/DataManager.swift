//
//  DataManager.swift
//  Todo App
//
//  Created by Burak 2 on 2025-02-03.
//

//
//  DataManager.swift
//  Todo App
//
//  Created by Burak 2 on 2025-02-03.
//

import Foundation

// 📂 **JSON Kaydetme Fonksiyonu**
func saveFoldersToFile(folders: [Folder]) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    do {
        let encodedData = try encoder.encode(folders)
        let url = getDocumentsDirectory().appendingPathComponent("folders.json")
        try encodedData.write(to: url)
    } catch {
        print("⚠️ Klasörleri kaydederken hata: \(error.localizedDescription)")
    }
}

// 📂 **JSON'dan Veri Okuma Fonksiyonu**
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

// 📂 **Belgeler Dizini**
func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}
