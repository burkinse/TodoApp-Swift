import SwiftUI

struct HomeView: View {
    @State private var folders: [Folder] = [
        Folder(name: "Important", tasks: [
            Task(title: "Swift öğren", isStarred: true, reminderDate: Date()),
            Task(title: "Proje sunumu hazırla")
        ]),
        Folder(name: "Daily", tasks: [
            Task(title: "Market alışverişi", reminderDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())),
            Task(title: "Spor yap", isStarred: true)
        ])
    ]

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
                        // 🔍 **Arama Sonuçları**
                        Section(header: Text("Arama Sonuçları")) {
                            ForEach(filteredTasks, id: \.2.id) { (folderIndex, taskIndex, task) in
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
                                            Text("\(formattedDate(reminderDate))") // 📅 Tarihi göster
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
                    } else {
                        // 📂 **Klasör Listesi**
                        Section(header: Text("Klasörler")) {
                            ForEach(folders.indices, id: \.self) { index in
                                NavigationLink(destination: FolderView(folder: $folders[index], folders: $folders)) {
                                    HStack {
                                        Image(systemName: "folder.fill")
                                            .foregroundColor(.blue)
                                        Text(folders[index].name)
                                            .font(.headline)
                                    }
                                }
                            }
                        }

                        // ⭐ **Öne Çıkan Görevler**
                        if !starredTasks.isEmpty {
                            Section(header: Text("⭐ Öne Çıkan Görevler")) {
                                ForEach(starredTasks, id: \.2.id) { (folderIndex, taskIndex, task) in
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
                                                Text("\(formattedDate(reminderDate))") // 📅 Tarihi göster
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
        }
    }

    // 📅 **Tarihi formatlamak için fonksiyon**
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR") // 🇹🇷 Türkçe tarih formatı
        formatter.dateFormat = "dd MMMM yyyy, HH:mm" // Örnek: "02 Şubat 2025, 14:30"
        return formatter.string(from: date)
    }
}

