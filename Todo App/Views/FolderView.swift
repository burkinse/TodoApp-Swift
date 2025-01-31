import SwiftUI

struct FolderView: View {
    @Binding var folder: Folder
    
    @State private var newTaskTitle: String = ""
    @State private var showAddTaskAlert = false

    var body: some View {
        VStack {
            List {
                ForEach(folder.tasks.indices, id: \.self) { index in
                    HStack {
                        Button(action: {
                            toggleTaskCompletion(at: index)
                        }) {
                            Image(systemName: folder.tasks[index].isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(folder.tasks[index].isCompleted ? .green : .gray)
                        }
                        Text(folder.tasks[index].title)
                            .strikethrough(folder.tasks[index].isCompleted, color: .gray)
                            .foregroundColor(folder.tasks[index].isCompleted ? .gray : .black)
                    }
                }
            }
            
            Spacer()
            
            // Görev Ekle Butonu
            Button(action: {
                showAddTaskAlert = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.largeTitle)
                    Text("Görev Ekle")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding()
            }
            .alert("Yeni Görev Adı", isPresented: $showAddTaskAlert) {
                TextField("Görev adı girin", text: $newTaskTitle)
                Button("Ekle", action: addNewTask)
                Button("İptal", role: .cancel) {}
            }
        }
        .navigationTitle(folder.name)
    }

    // Yeni Görev Ekleme Fonksiyonu
    private func addNewTask() {
        if !newTaskTitle.isEmpty {
            let newTask = Task(title: newTaskTitle)
            folder.tasks.append(newTask)  // Klasör içindeki görevler kalıcı olarak güncelleniyor
            newTaskTitle = "" // Input'u temizle
        }
    }

    // Görev Tamamlama / Geri Alma
    private func toggleTaskCompletion(at index: Int) {
        folder.tasks[index].isCompleted.toggle()
    }
}

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView(folder: .constant(Folder(name: "Test", tasks: [Task(title: "Örnek Görev")])))
    }
}

