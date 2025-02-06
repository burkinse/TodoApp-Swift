import SwiftUI

struct AddTaskView: View {
    @Binding var folders: [Folder]
    @Binding var selectedFolderIndex: Int?
    var isAddingInsideFolder: Bool = false

    @State private var folderNameInput: String = ""
    @State private var newTaskTitle: String = ""
    @State private var isReminderEnabled: Bool = false
    @State private var reminderDate: Date = Date()
    @State private var isStarred: Bool = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if !isAddingInsideFolder {
                        Text("Select Folder") // Changed to English
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        Picker("Select Folder", selection: $selectedFolderIndex) { // Changed to English
                            Text("Add New Folder").tag(-1) // Changed to English
                            ForEach(folders.indices, id: \.self) { index in
                                Text(folders[index].name).tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                        .onAppear {
                            selectedFolderIndex = -1
                        }

                        if selectedFolderIndex == -1 {
                            TextField("Enter New Folder Name", text: $folderNameInput) // Changed to English
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        }
                    }

                    TextField("Enter Task Name", text: $newTaskTitle) // Changed to English
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Toggle("Add Reminder", isOn: $isReminderEnabled) // Changed to English
                        .padding(.horizontal)

                    if isReminderEnabled {
                        DatePicker("Reminder Time", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute]) // Changed to English
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                    }

                    Toggle("Starred Task", isOn: $isStarred) // Changed to English
                        .padding(.horizontal)

                    Button(action: { addTask() }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                            Text("Add Task") // Changed to English
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(newTaskTitle.isEmpty ? Color.gray : Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    .disabled(newTaskTitle.isEmpty)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Add New Task") // Changed to English
        }
    }

    private func addTask() {
        guard !newTaskTitle.isEmpty else { return }

        let newTask = Task(title: newTaskTitle, isStarred: isStarred, reminderDate: isReminderEnabled ? reminderDate : nil)

        if isAddingInsideFolder, let selectedFolderIndex = selectedFolderIndex {
            folders[selectedFolderIndex].tasks.append(newTask)
        } else {
            if selectedFolderIndex == -1 {
                guard !folderNameInput.isEmpty else { return }
                let newFolder = Folder(name: folderNameInput, tasks: [newTask])
                folders.append(newFolder)
            } else if let selectedIndex = selectedFolderIndex {
                folders[selectedIndex].tasks.append(newTask)
            }
        }

        saveFoldersToFile(folders: folders) // ✅ Added saving to JSON

        presentationMode.wrappedValue.dismiss()
    }
}

