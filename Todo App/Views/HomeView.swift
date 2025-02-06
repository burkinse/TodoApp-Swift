import SwiftUI
import Foundation

struct HomeView: View {
    @State private var folders: [Folder] = loadFoldersFromFile() // ✅ JSON’dan veri yükleme
    @State private var searchText: String = "" // 🔍 Search bar için
    @State private var showAddTaskView = false
    @State private var selectedFolderIndex: Int?

    // 🔍 **Arama Sonuçlarını Filtreleme**
    var filteredTasks: [(folderIndex: Int, taskIndex: Int, task: Task)] {
        let allTasks = folders.enumerated().flatMap { (folderIndex, folder) in
            folder.tasks.enumerated().map { (taskIndex, task) in
                (folderIndex, taskIndex, task)
            }
        }
        return searchText.isEmpty ? [] : allTasks.filter { $0.2.title.localizedCaseInsensitiveContains(searchText) }
    }

    // 🌟 **Yıldızlı Görevleri Listeleme**
    var starredTasks: [(folderIndex: Int, taskIndex: Int, task: Task)] {
        folders.enumerated().flatMap { (folderIndex, folder) in
            folder.tasks.enumerated().compactMap { (taskIndex, task) in
                task.isStarred ? (folderIndex, taskIndex, task) : nil
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // 🔍 **Search Bar**
                HStack {
                    TextField("Görev Ara...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)

                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
                .padding()

                List {
                    if !searchText.isEmpty {
                        Section(header: Text("Arama Sonuçları")) {
                            ForEach(filteredTasks, id: \.2.id) { (folderIndex, taskIndex, task) in
                                TaskRow(folderIndex: folderIndex, taskIndex: taskIndex, task: task, folders: $folders)
                            }
                        }
                    } else {
                        Section(header: Text("Klasörler")) {
                            ForEach(folders.indices, id: \.self) { index in
                                NavigationLink(destination: FolderView(folder: $folders[index], folders: $folders)) {
                                    FolderRow(folder: folders[index])
                                }
                            }
                            .onDelete(perform: deleteFolder) // ✅ Klasörleri silme özelliği eklendi
                        }

                        if !starredTasks.isEmpty {
                            Section(header: Text("⭐ Öne Çıkan Görevler")) {
                                ForEach(starredTasks.indices, id: \.self) { index in
                                    let (folderIndex, taskIndex, task) = starredTasks[index]
                                    TaskRow(folderIndex: folderIndex, taskIndex: taskIndex, task: task, folders: $folders)
                                }
                                .onDelete(perform: deleteStarredTask) // ✅ Öne çıkan görevleri silme özelliği eklendi
                            }
                        }
                    }
                }

                // ➕ **Görev Ekle Butonu**
                Button(action: { showAddTaskView = true }) {
                    Label("Görev Ekle", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .padding()
                }
                .sheet(isPresented: $showAddTaskView) {
                    AddTaskView(folders: $folders, selectedFolderIndex: $selectedFolderIndex)
                }
            }
            .onAppear { folders = loadFoldersFromFile() } // ✅ JSON’dan yükleme
            .onDisappear { saveFoldersToFile(folders: folders) } // ✅ JSON’a kaydetme
        }
    }

    // 📂 **Klasör Silme Fonksiyonu**
    private func deleteFolder(at offsets: IndexSet) {
        folders.remove(atOffsets: offsets)
        saveFoldersToFile(folders: folders) // ✅ JSON’a kaydet
    }

    // 📂 **Öne Çıkan Görevi Silme Fonksiyonu**
    private func deleteStarredTask(at offsets: IndexSet) {
        for index in offsets {
            let (folderIndex, taskIndex, _) = starredTasks[index]
            folders[folderIndex].tasks.remove(at: taskIndex)
        }
        saveFoldersToFile(folders: folders) // ✅ JSON güncelle
    }
}

// 📅 **Tarihi formatlamak için fonksiyon**
private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "tr_TR")
    formatter.dateFormat = "dd MMMM yyyy, HH:mm"
    return formatter.string(from: date)
}

// 📂 **Görev Satırı Componenti**
struct TaskRow: View {
    var folderIndex: Int
    var taskIndex: Int
    var task: Task
    @Binding var folders: [Folder]

    var body: some View {
        HStack {
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .green : .gray)
                .onTapGesture {
                    folders[folderIndex].tasks[taskIndex].isCompleted.toggle()
                }

            VStack(alignment: .leading) {
                Text(task.title)
                    .foregroundColor(task.isCompleted ? .gray : .black)

                if let reminderDate = task.reminderDate {
                    Text("\(formattedDate(reminderDate))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Image(systemName: task.isStarred ? "star.fill" : "star")
                .foregroundColor(task.isStarred ? .yellow : .gray)
                .onTapGesture {
                    folders[folderIndex].tasks[taskIndex].isStarred.toggle()
                }
        }
    }
}

// 📂 **Klasör Satırı Componenti**
struct FolderRow: View {
    var folder: Folder

    var body: some View {
        HStack {
            Image(systemName: "folder.fill")
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(folder.name)
                    .font(.headline)
                Text("\(folder.tasks.count) görev")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}

