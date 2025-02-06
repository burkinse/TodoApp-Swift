import SwiftUI
import Foundation

struct HomeView: View {
    @State private var folders: [Folder] = loadFoldersFromFile() // ✅ Load data from JSON
    @State private var searchText: String = "" // 🔍 For search bar
    @State private var showAddTaskView = false
    @State private var selectedFolderIndex: Int?

    // 🔍 **Filter Search Results**
    var filteredTasks: [(folderIndex: Int, taskIndex: Int, task: Task)] {
        let allTasks = folders.enumerated().flatMap { (folderIndex, folder) in
            folder.tasks.enumerated().map { (taskIndex, task) in
                (folderIndex, taskIndex, task)
            }
        }
        return searchText.isEmpty ? [] : allTasks.filter { $0.2.title.localizedCaseInsensitiveContains(searchText) }
    }

    // 🌟 **List Starred Tasks**
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
                    TextField("Search Tasks...", text: $searchText) // Changed to English
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
                        Section(header: Text("Search Results")) { // Changed to English
                            ForEach(filteredTasks, id: \.2.id) { (folderIndex, taskIndex, task) in
                                TaskRow(folderIndex: folderIndex, taskIndex: taskIndex, task: task, folders: $folders)
                            }
                        }
                    } else {
                        Section(header: Text("Folders")) { // Changed to English
                            ForEach(folders.indices, id: \.self) { index in
                                NavigationLink(destination: FolderView(folder: $folders[index], folders: $folders)) {
                                    FolderRow(folder: folders[index])
                                }
                            }
                            .onDelete(perform: deleteFolder) // ✅ Added folder deletion feature
                        }

                        if !starredTasks.isEmpty {
                            Section(header: Text("⭐ Featured Tasks")) { // Changed to English
                                ForEach(starredTasks.indices, id: \.self) { index in
                                    let (folderIndex, taskIndex, task) = starredTasks[index]
                                    TaskRow(folderIndex: folderIndex, taskIndex: taskIndex, task: task, folders: $folders)
                                }
                                .onDelete(perform: deleteStarredTask) // ✅ Added starred task deletion feature
                            }
                        }
                    }
                }

                // ➕ **Add Task Button**
                Button(action: { showAddTaskView = true }) {
                    Label("Add Task", systemImage: "plus.circle.fill") // Changed to English
                        .font(.headline)
                        .padding()
                }
                .sheet(isPresented: $showAddTaskView) {
                    AddTaskView(folders: $folders, selectedFolderIndex: $selectedFolderIndex)
                }
            }
            .onAppear { folders = loadFoldersFromFile() } // ✅ Load from JSON
            .onDisappear { saveFoldersToFile(folders: folders) } // ✅ Save to JSON
        }
    }

    // 📂 **Folder Deletion Function**
    private func deleteFolder(at offsets: IndexSet) {
        folders.remove(atOffsets: offsets)
        saveFoldersToFile(folders: folders) // ✅ Save to JSON
    }

    // 📂 **Featured Task Deletion Function**
    private func deleteStarredTask(at offsets: IndexSet) {
        for index in offsets {
            let (folderIndex, taskIndex, _) = starredTasks[index]
            folders[folderIndex].tasks.remove(at: taskIndex)
        }
        saveFoldersToFile(folders: folders) // ✅ Update JSON
    }
}

// 📅 **Function to format the date**
private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "tr_TR") // Turkish date format
    formatter.dateFormat = "dd MMMM yyyy, HH:mm"
    return formatter.string(from: date)
}

// 📂 **Task Row Component**
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

// 📂 **Folder Row Component**
struct FolderRow: View {
    var folder: Folder

    var body: some View {
        HStack {
            Image(systemName: "folder.fill")
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(folder.name)
                    .font(.headline)
                Text("\(folder.tasks.count) tasks") // Changed to English
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}

