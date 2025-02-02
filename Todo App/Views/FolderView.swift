import SwiftUI

struct FolderView: View {
    @Binding var folder: Folder
    @Binding var folders: [Folder]
    @State private var showAddTaskView = false

    var body: some View {
        VStack {
            List {
                // 📌 **Aktif (Tamamlanmamış) Görevler**
                Section(header: Text("Aktif Görevler")) {
                    ForEach(folder.tasks.indices.filter { !folder.tasks[$0].isCompleted }, id: \.self) { index in
                        HStack {
                            Button(action: {
                                folder.tasks[index].isCompleted.toggle()
                            }) {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                            Text(folder.tasks[index].title)
                        }
                    }
                    .onDelete(perform: deleteTask)
                }

                // 📌 **Tamamlanan Görevler (En Alta Taşındı)**
                if folder.tasks.contains(where: { $0.isCompleted }) {
                    Section(header: Text("✅ Tamamlananlar")) {
                        ForEach(folder.tasks.indices.filter { folder.tasks[$0].isCompleted }, id: \.self) { index in
                            HStack {
                                Button(action: {
                                    folder.tasks[index].isCompleted.toggle() // ✅ Geri alınabilir!
                                }) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                                Text(folder.tasks[index].title)
                                    .strikethrough(true, color: .gray)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }

            Spacer()

            Button(action: { showAddTaskView = true }) {
                Label("Görev Ekle", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding()
            }
            .sheet(isPresented: $showAddTaskView) {
                AddTaskView(folders: $folders, selectedFolderIndex: .constant(folders.firstIndex(where: { $0.id == folder.id })), isAddingInsideFolder: true)
            }
        }
        .navigationTitle(folder.name)
    }

    private func deleteTask(at offsets: IndexSet) {
        folder.tasks.remove(atOffsets: offsets)
    }
}

