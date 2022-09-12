import SwiftUI

@main
struct LavoroApp: App {
    let persistenceController = CoreDataManager.shared.persistentContainer

    var body: some Scene {
        WindowGroup {
            TaskListView(vm: TaskListViewModel(context: persistenceController.viewContext))
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
