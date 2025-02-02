import SwiftUI

struct HomeView: View {
    @State private var folders: [Folder] = [
        Folder(name: "Important", tasks: [Task(title: "Swift öğren"), Task(title: "Proje sunumu hazırla")]),
        Folder(name: "Daily", tasks: [Task(title: "Market alışverişi"), Task(title: "Spor yap")])
    ]

    @State private var searchText: String = ""
    @State private var newFolderName: String = ""
    @State private var showAddFolderAlert = false
    @State private var showAddTaskView = false
    @State private var selectedFolderIndex: Int?

    // 📌 **Sadece Görevleri Filtreleme**
    var filteredTasks: [(folderIndex: Int, taskIndex: Int, task: Task)] {
        let allTasks = folders.enumerated().flatMap { (folderIndex, folder) in
            folder.tasks.enumerated().map { (taskIndex, task) in
                (folderIndex, taskIndex, task)
            }
        }
        return searchText.isEmpty ? [] : allTasks.filter { $0.2.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationView {
            VStack {
                // 🔍 **Search Bar (Sadece Görevler İçin)**
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
                    // 🔍 **Sadece Görev Arama Sonuçları**
                    if !searchText.isEmpty {
                        Section(header: Text("Arama Sonuçları")) {
                            ForEach(filteredTasks, id: \.2.id) { (folderIndex, taskIndex, task) in
                                HStack {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(task.isCompleted ? .green : .gray)
                                    VStack(alignment: .leading) {
                                        Text(task.title)
                                            .strikethrough(task.isCompleted, color: .gray)
                                            .foregroundColor(task.isCompleted ? .gray : .black)
                                        Text("Klasör: \(folders[folderIndex].name)") // 📌 Görevin hangi klasörde olduğu gösteriliyor
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                .contentShape(Rectangle()) // Tıklamayı kolaylaştırmak için
                                .onTapGesture {
                                    toggleTaskCompletion(folderIndex: folderIndex, taskIndex: taskIndex)
                                }
                            }
                        }
                    } else {
                        // 📂 **Klasör Listesi (Sadece Search Bar Boşken Görünecek!)**
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
                            .onDelete(perform: deleteAtIndex)
                        }
                    }
                }

                Spacer()

                HStack {
                    Button(action: { showAddFolderAlert = true }) {
                        Label("Klasör Ekle", systemImage: "folder.badge.plus")
                            .font(.headline)
                            .padding()
                    }

                    Spacer()

                    Button(action: { showAddTaskView = true }) {
                        Label("Görev Ekle", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .padding()
                    }
                    .sheet(isPresented: $showAddTaskView) {
                        AddTaskView(folders: $folders, selectedFolderIndex: $selectedFolderIndex)
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

    // 📌 **Klasör Ekleme**
    private func addNewFolder() {
        if !newFolderName.isEmpty {
            folders.append(Folder(name: newFolderName, tasks: []))
            newFolderName = ""
        }
    }

    // 📌 **Klasör Silme**
    private func deleteAtIndex(at offsets: IndexSet) {
        folders.remove(atOffsets: offsets)
    }
}

