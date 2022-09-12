import Foundation
import CoreData

class TaskAddViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var priority: Priority = .medium
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func save() {
        let task = TaskItem(context: context)
        task.name = title
        task.priority = priority.rawValue
        task.createdAt = Date()
        task.store()
    }
}
