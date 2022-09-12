import SwiftUI

struct TaskAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: TaskAddViewModel
    
    //var taskItem: FetchedResults<TaskItem>.Element
    
    init(vm: TaskAddViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter title", text: $vm.title)
                .padding(.horizontal)
                .frame(height: 44)
                .background(Color(hex: "#ededed"))
                .cornerRadius(10)
                //.textFieldStyle(.roundedBorder)
            Picker("Priority", selection: $vm.priority) {
                ForEach(Priority.allCases) { priority in
                    Text(priority.rawValue).tag(priority)
                }
            }.pickerStyle(.segmented)
            
            Button {
                vm.save()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
                    .frame(height: 44)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y: 3)
            
            Spacer()
        }
        .navigationTitle("Add new task")
        .padding()
    }
}
