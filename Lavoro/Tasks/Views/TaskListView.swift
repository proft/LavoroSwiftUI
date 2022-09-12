import SwiftUI
import CoreData

enum Priority: String, Identifiable, CaseIterable {
    var id: UUID {
        return UUID()
    }
    
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isPresented: Bool = false
    @ObservedObject private var vm: TaskListViewModel
    
    init(vm: TaskListViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.items) { task in
                    TaskRowView(task: task)
                        .onTapGesture {
                            vm.update(task)
                        }
                }
                .onDelete(perform: vm.delete)
            }
            .id(vm.refreshId)
            .listStyle(.plain)
            .padding()
            .navigationTitle("All Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented = true
                    } label: {
                        Label("Add task", systemImage: "plus.circle")
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                // dismiss
            } content: {
                TaskAddView(vm: TaskAddViewModel(context: viewContext))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let ctx = CoreDataManager.shared.persistentContainer.viewContext
        TaskListView(vm: TaskListViewModel(context: ctx))
    }
}
