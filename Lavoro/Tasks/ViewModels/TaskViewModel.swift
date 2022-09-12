import Foundation
import CoreData

extension TaskItem: BaseModel {
    static var all: NSFetchRequest<TaskItem> {
        let request = TaskItem.fetchRequest()
        request.sortDescriptors = []
        return request
    }
}

class TaskListViewModel: NSObject, ObservableObject {
    @Published var items = [TaskViewModel]()
    @Published var refreshId = UUID()
    
    private(set) var context: NSManagedObjectContext
    private let fetchedController: NSFetchedResultsController<TaskItem>
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        fetchedController = NSFetchedResultsController(fetchRequest: TaskItem.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        fetchedController.delegate = self
        
        do {
            try fetchedController.performFetch()
            guard let items = fetchedController.fetchedObjects else { return }
            self.items = items.map(TaskViewModel.init)
        } catch {
            print(error)
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let taskVM = items[index]
            
            do {
                // find by id example
                //guard let taskExist = try context.existingObject(with: task.id) as? TaskItem else { return }
                //try taskExist.delete()
                
                try taskVM.task.delete()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func update(_ taskVM: TaskViewModel) {
        taskVM.task.isCompleted.toggle()
        taskVM.task.store()
        refreshId = UUID()
    }
}

extension TaskListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let items = controller.fetchedObjects as? [TaskItem] else { return }
        self.items = items.map(TaskViewModel.init)
    }
}

struct TaskViewModel: Identifiable {
    var task: TaskItem
    
    init(task: TaskItem) {
        self.task = task
    }
    
    var id: NSManagedObjectID {
        task.objectID
    }
    
    var name: String {
        task.name ?? ""
    }
    
    var priority: String {
        task.priority ?? ""
    }
    
    var isCompleted: Bool {
        return task.isCompleted
    }
}
