//
//  TaskCoreDataManager.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//

import CoreData

final class TaskCoreDataManager {
    static let shared = TaskCoreDataManager()
    private let context = CoreDataStack.shared.context

    private init() {}

    // MARK: - Save API Tasks to Core Data
    func saveTasks(_ tasks: [APITask]) {
        tasks.forEach { apiTask in
            let taskEntity = TaskEntity(context: context)
            taskEntity.id = Int64(apiTask.id)
            taskEntity.title = apiTask.todo
            taskEntity.isCompleted = apiTask.completed
            taskEntity.createdAt = Date()
        }

        CoreDataStack.shared.saveContext()
    }
    
    func createTask(title: String, body: String) -> TaskModel {
        let task = TaskEntity(context: context)
        let newId = Int64(Date().timeIntervalSince1970 * 1000)
        task.id = newId
        task.title = title
        task.details = body
        task.createdAt = Date()
        task.isCompleted = false

        CoreDataStack.shared.saveContext()

        return TaskModel(from: task)
    }


    // MARK: - Fetch Tasks from Core Data
    func fetchTasks() -> [TaskModel] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]

        do {
            let results = try context.fetch(request)
            return results.map { entity in
                TaskModel(
                    id: Int(entity.id),
                    title: entity.title ?? "",
                    details: entity.details ?? "",
                    createdAt: entity.createdAt ?? Date(),
                    isCompleted: entity.isCompleted
                )
            }
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }

    // MARK: - Delete All Tasks
    func deleteAllTasks() {
        let request: NSFetchRequest<NSFetchRequestResult> = TaskEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
            CoreDataStack.shared.saveContext()
        } catch {
            print("Failed to delete tasks: \(error)")
        }
    }
    
    // MARK: - Delete Task by ID
    func deleteTask(byId id: Int, completion: (() -> Void)? = nil) {
        let backgroundContext = CoreDataStack.shared.newBackgroundContext()

        backgroundContext.perform {
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))

            do {
                if let task = try backgroundContext.fetch(request).first {
                    backgroundContext.delete(task)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion?()
                    }
                } else {
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            } catch {
                print("Delete error: \(error)")
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }


    // MARK: - Optional: Update a Task
    func updateTask(id: Int64, newTitle: String, newDetails: String, completed: Bool) -> TaskModel? {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        //request.predicate = NSPredicate(format: "id == %d", id)
        request.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        
        do {
            if let task = try context.fetch(request).first {
                task.title = newTitle
                task.details = newDetails
                task.isCompleted = completed
                task.createdAt = Date()
                CoreDataStack.shared.saveContext()
                return TaskModel(from: task)
            }
        } catch {
            print("Update error: \(error)")
        }
        return nil
    }
    
    
    func updateTaskCompletion(id: Int64, completed: Bool) {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))

        do {
            if let task = try context.fetch(request).first {
                task.isCompleted = completed
                CoreDataStack.shared.saveContext()
            }
        } catch {
            print("Update completion error: \(error)")
        }
    }

}
