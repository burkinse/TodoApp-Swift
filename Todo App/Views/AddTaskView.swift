import SwiftUI

struct AddTaskView: View {
    @Binding var folders: [Folder]
    @Binding var selectedFolderIndex: Int?
    var isAddingInsideFolder: Bool = false // 🆕 Klasör içinden mi çağrıldı?

    @State private var folderNameInput: String = ""
    @State private var newTaskTitle: String = ""
    @State private var isReminderEnabled: Bool = false
    @State private var reminderDate: Date = Date()
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if !isAddingInsideFolder { // 🆕 Eğer klasör içinden eklenmiyorsa göster
                        Text("Klasör Seç")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        Picker("Klasör Seç", selection: $selectedFolderIndex) {
                            Text("Yeni Klasör Oluştur").tag(-1)
                            ForEach(folders.indices, id: \.self) { index in
                                Text(folders[index].name).tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .onAppear {
                            selectedFolderIndex = -1
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

        if isAddingInsideFolder, let selectedFolderIndex = selectedFolderIndex {
            // 📌 Klasör içinden çağrıldıysa sadece mevcut klasöre görev ekle
            folders[selectedFolderIndex].tasks.append(Task(title: newTaskTitle, reminderDate: isReminderEnabled ? reminderDate : nil))
        } else {
            // 📌 Ana sayfadan çağrıldıysa önce klasör seçmeli veya oluşturmalı
            if selectedFolderIndex == -1 {
                guard !folderNameInput.isEmpty else { return }
                let newFolder = Folder(name: folderNameInput, tasks: [Task(title: newTaskTitle, reminderDate: isReminderEnabled ? reminderDate : nil)])
                folders.append(newFolder)
            } else if let selectedIndex = selectedFolderIndex {
                let newTask = Task(title: newTaskTitle, reminderDate: isReminderEnabled ? reminderDate : nil)
                folders[selectedIndex].tasks.append(newTask)
            }
        }

        presentationMode.wrappedValue.dismiss()
    }
}

