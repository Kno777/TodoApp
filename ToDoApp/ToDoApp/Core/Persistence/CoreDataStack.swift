//
//  CoreDataStack.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//


import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoCoreDatabase")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData failed \(error)")
            }
        }
        return container
    }()

    // Main context (for UI/main thread usage)
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Creates a new private background context
    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Save error: \(error)")
            }
        }
    }
}

