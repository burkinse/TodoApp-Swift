import SwiftUI

struct HomeView: View {
    @State private var folders: [Folder] = [
        Folder(name: "Important", tasks: [Task(title: "Swift öğren"), Task(title: "Proje sunumu hazırla")]),
        Folder(name: "Daily", tasks: [Task(title: "Market alışverişleri"), Task(title: "Spor yap")])
    ]

    @State private var searchText: String = ""
    @State private var newFolderName: String = ""
    @State private var showAddFolderAlert = false
    @State private var showAddTaskView = false

    // 🔍 **Güncellenmiş Arama Fonksiyonu**
    var filteredTasks: [(folderIndex: Int, taskIndex: Int, task: Task)] {
        let allTasks = folders.enumerated().flatMap { (folderIndex, folder) in
            folder.tasks.enumerated().map { (taskIndex, task) in
                (folderIndex, taskIndex, task)
            }
        }

        // Eğer arama boşsa görevleri göstermeyelim
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return []
        } else {
            return allTasks.filter { taskData in
                let taskTitle = taskData.2.title.lowercased()
                let searchInput = searchText.lowercased()

                return taskTitle.range(of: searchInput, options: .caseInsensitive) != nil
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // 🔍 Search Bar
                HStack {
                    TextField("Görev Ara...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading)

                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = "" // Arama metnini temizle
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
                .padding()

                List {
                    if searchText.isEmpty {
                        // 📂 **Klasörleri Listele**
                        ForEach(folders.indices, id: \.self) { index in
                            NavigationLink(destination: FolderView(folder: $folders[index])) {
                                HStack {
                                    Image(systemName: "folder.fill")
                                        .foregroundColor(.blue)
                                    Text(folders[index].name)
                                        .font(.headline)
                                }
                            }
                        }
                        .onDelete(perform: deleteAtIndex)
                    } else {
                        // 🔎 **Arama Sonuçları (Görevler)**
                        ForEach(filteredTasks, id: \.2.id) { (folderIndex, taskIndex, task) in
                            HStack {
                                Button(action: {
                                    toggleTaskCompletion(folderIndex: folderIndex, taskIndex: taskIndex)
                                }) {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.isCompleted ? .green : .gray)
                                }
                                Text(task.title)
                                    .strikethrough(task.isCompleted, color: .gray)
                                    .foregroundColor(task.isCompleted ? .gray : .black)
                            }
                        }
                    }
                }

                Spacer()

                // 📂 **Klasör Ekle & Görev Ekle Butonları**
                HStack {
                    // 📂 Klasör Ekle Butonu
                    Button(action: {
                        showAddFolderAlert = true
                    }) {
                        HStack {
                            Image(systemName: "folder.badge.plus")
                                .foregroundColor(.blue)
                                .font(.largeTitle)
                            Text("Klasör Ekle")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }

                    Spacer()

                    // ✅ Görev Ekle Butonu
                    Button(action: {
                        showAddTaskView = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .font(.largeTitle)
                            Text("Görev Ekle")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        .padding()
                    }
                    .sheet(isPresented: $showAddTaskView) {
                        AddTaskView(folders: $folders)
                    }
                }
                .padding()
            }
            .alert("Yeni Klasör Adı", isPresented: $showAddFolderAlert) {
                VStack {
                    TextField("Klasör adı girin", text: $newFolderName)
                    Button("Ekle", action: addNewFolder)
                    Button("İptal", role: .cancel) {}
                }
            }
        }
    }

    // ✅ **Görev Tamamlama Fonksiyonu**
    private func toggleTaskCompletion(folderIndex: Int, taskIndex: Int) {
        folders[folderIndex].tasks[taskIndex].isCompleted.toggle()
    }

    // ✅ **Klasör Ekleme Fonksiyonu**
    private func addNewFolder() {
        if !newFolderName.isEmpty {
            let newFolder = Folder(name: newFolderName, tasks: [])
            folders.append(newFolder)
            newFolderName = ""
        }
    }

    // ✅ **Klasör Silme Fonksiyonu**
    private func deleteAtIndex(at offsets: IndexSet) {
        folders.remove(atOffsets: offsets)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

