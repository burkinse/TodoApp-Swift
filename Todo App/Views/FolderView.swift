import SwiftUI

struct FolderView: View {
    @Binding var folder: Folder
    @Binding var folders: [Folder]
    @State private var showAddTaskView = false

    var body: some View {
        VStack {
            List {
                Section(header: Text("Aktif Görevler")) {
                    ForEach(folder.tasks.indices, id: \.self) { index in
                        HStack {
                            Image(systemName: folder.tasks[index].isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(folder.tasks[index].isCompleted ? .green : .gray)
                                .onTapGesture {
                                    folder.tasks[index].isCompleted.toggle()
                                    saveFoldersToFile(folders: folders) // ✅ JSON güncelle
                                }

                            VStack(alignment: .leading) {
                                Text(folder.tasks[index].title)
                                    .foregroundColor(folder.tasks[index].isCompleted ? .gray : .black)

                                if let reminderDate = folder.tasks[index].reminderDate {
                                    Text("\(formattedDate(reminderDate))") // 🕒 Tarihi göster
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }

                            Spacer()

                            Image(systemName: folder.tasks[index].isStarred ? "star.fill" : "star")
                                .foregroundColor(folder.tasks[index].isStarred ? .yellow : .gray)
                                .onTapGesture {
                                    folder.tasks[index].isStarred.toggle()
                                    saveFoldersToFile(folders: folders) // ✅ JSON güncelle
                                }
                        }
                    }
                    .onDelete(perform: deleteTask) // ✅ Görev silme eklendi
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

    // 📂 **Görev Silme Fonksiyonu**
    private func deleteTask(at offsets: IndexSet) {
        folder.tasks.remove(atOffsets: offsets)
        saveFoldersToFile(folders: folders) // ✅ JSON güncelle
    }

    // 📅 **Tarihi formatlamak için fonksiyon**
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR") // Türkçe tarih formatı
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        return formatter.string(from: date)
    }
}

