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
                        Text("Klasör Seç")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        Picker("Klasör Seç", selection: $selectedFolderIndex) {
                            Text("Yeni Klasör Ekle").tag(-1) // ✅ Varsayılan olarak seçili olacak
                            ForEach(folders.indices, id: \.self) { index in
                                Text(folders[index].name).tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                        .onAppear {
                            selectedFolderIndex = -1 // ✅ Varsayılan olarak "Yeni Klasör Ekle" seçili
                        }

                        if selectedFolderIndex == -1 {
                            TextField("Yeni Klasör Adını Girin", text: $folderNameInput)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        }
                    }

                    TextField("Görev Adını Girin", text: $newTaskTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Toggle("Hatırlatıcı Ekle", isOn: $isReminderEnabled)
                        .padding(.horizontal)

                    if isReminderEnabled {
                        DatePicker("Hatırlatma Zamanı", selection: $reminderDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                    }

                    Toggle("Yıldızlı Görev", isOn: $isStarred)
                        .padding(.horizontal)

                    Button(action: { addTask() }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                            Text("Görevi Ekle")
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
            .navigationTitle("Yeni Görev Ekle")
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

        presentationMode.wrappedValue.dismiss()
    }
}
