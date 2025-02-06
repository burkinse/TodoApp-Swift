import SwiftUI

struct FolderView: View {
    @Binding var folder: Folder
    @Binding var folders: [Folder]
    @State private var showAddTaskView = false

    var body: some View {
        VStack {
            List {
                Section(header: Text("Active Tasks")) { // Changed to English
                    ForEach(folder.tasks.indices, id: \.self) { index in
                        HStack {
                            Image(systemName: folder.tasks[index].isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(folder.tasks[index].isCompleted ? .green : .gray)
                                .onTapGesture {
                                    folder.tasks[index].isCompleted.toggle()
                                    saveFoldersToFile(folders: folders) // ✅ Update JSON
                                }

                            VStack(alignment: .leading) {
                                Text(folder.tasks[index].title)
                                    .foregroundColor(folder.tasks[index].isCompleted ? .gray : .black)

                                if let reminderDate = folder.tasks[index].reminderDate {
                                    Text("\(formattedDate(reminderDate))") // 🕒 Display date
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }

                            Spacer()

                            Image(systemName: folder.tasks[index].isStarred ? "star.fill" : "star")
                                .foregroundColor(folder.tasks[index].isStarred ? .yellow : .gray)
                                .onTapGesture {
                                    folder.tasks[index].isStarred.toggle()
                                    saveFoldersToFile(folders: folders) // ✅ Update JSON
                                }
                        }
                    }
                    .onDelete(perform: deleteTask) // ✅ Task deletion added
                }
            }

            Spacer()

            Button(action: { showAddTaskView = true }) {
                Label("Add Task", systemImage: "plus.circle.fill") // Changed to English
                    .font(.headline)
                    .padding()
            }
            .sheet(isPresented: $showAddTaskView) {
                AddTaskView(folders: $folders, selectedFolderIndex: .constant(folders.firstIndex(where: { $0.id == folder.id })), isAddingInsideFolder: true)
            }
        }
        .navigationTitle(folder.name)
    }

    // 📂 **Task Deletion Function**
    private func deleteTask(at offsets: IndexSet) {
        folder.tasks.remove(atOffsets: offsets)
        saveFoldersToFile(folders: folders) // ✅ Update JSON
    }

    // 📅 **Function to format the date**
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR") // Turkish date format
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        return formatter.string(from: date)
    }
}

