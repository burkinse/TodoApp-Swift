//
//  AddTaskView.swift
//  Todo App
//
//  Created by Burak 2 on 2025-01-31.
//

import SwiftUI

struct AddTaskView: View {
    @Binding var folders: [Folder]
    
    @State private var selectedFolderIndex: Int = 0
    @State private var newFolderName: String = ""
    @State private var newTaskTitle: String = ""
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Text("Görevi hangi klasöre eklemek istersiniz?")
                    .font(.headline)
                    .padding()

                // 📂 Mevcut Klasör Seçimi veya Yeni Klasör Adı Girişi
                Picker("Klasör Seç", selection: $selectedFolderIndex) {
                    ForEach(0..<folders.count, id: \.self) { index in
                        Text(folders[index].name).tag(index)
                    }
                    Text("Yeni Klasör Oluştur").tag(folders.count)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedFolderIndex == folders.count {
                    TextField("Yeni Klasör Adı", text: $newFolderName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }

                // 📌 Görev Adı Girişi
                TextField("Görev Adını Girin", text: $newTaskTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Spacer()

                // ✅ Kaydet Butonu
                Button(action: {
                    saveTask()
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.title)
                        Text("Kaydet")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding()
                }
            }
            .navigationTitle("Görev Ekle")
            .navigationBarItems(leading: Button("İptal") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func saveTask() {
        guard !newTaskTitle.isEmpty else { return }
        
        if selectedFolderIndex == folders.count {
            // Yeni klasör oluşturulacaksa
            if !newFolderName.isEmpty {
                let newFolder = Folder(name: newFolderName, tasks: [Task(title: newTaskTitle)])
                folders.append(newFolder)
            }
        } else {
            // Mevcut klasöre görev ekleme
            folders[selectedFolderIndex].tasks.append(Task(title: newTaskTitle))
        }

        presentationMode.wrappedValue.dismiss() // Sayfayı kapat
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(folders: .constant([
            Folder(name: "Important", tasks: []),
            Folder(name: "Daily", tasks: [])
        ]))
    }
}
