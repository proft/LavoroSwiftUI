import Foundation
import CoreData

protocol BaseModel {
    static var viewContext: NSManagedObjectContext { get }
    func save() throws
    func store()
    func delete() throws
}

extension BaseModel where Self: NSManagedObject {
    static var viewContext: NSManagedObjectContext {
        CoreDataManager.shared.persistentContainer.viewContext
    }
    
    func save() throws {
        try Self.viewContext.save()
    }
    
    func store() {
        do {
            try Self.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete() throws {
        Self.viewContext.delete(self)
        try save()
    }
}
