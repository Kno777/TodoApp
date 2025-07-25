//
//  TaskListInteractorProtocol.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//
import Foundation

protocol TaskListInteractorProtocol: AnyObject {
    func fetchTasks()
    //func deleteTask(_ task: TaskModel)
    func deleteTask(_ task: TaskModel, at index: Int)
    func toggleTaskCompletion(_ task: TaskModel)
    func fetchTasksFromDB() -> [TaskModel]
}

final class TaskListInteractor: TaskListInteractorProtocol {
    weak var presenter: TaskListPresenterProtocol?

    func fetchTasks() {
        APILoader.shared.loadTasks { [weak self] result in
            switch result {
            case .success(let apiTasks):
                let tasks = apiTasks.map {
                    $0
                }
                self?.presenter?.didFetchTasks(tasks)
            case .failure(let error):
                self?.presenter?.didFailToFetchTasks(error)
            }
        }
    }
    
    func deleteTask(_ task: TaskModel, at index: Int) {
        
        print(task.title)
        
        TaskCoreDataManager.shared.deleteTask(byId: task.id)
    }
    
    func toggleTaskCompletion(_ task: TaskModel) {
        let newStatus = !task.isCompleted
        TaskCoreDataManager.shared.updateTaskCompletion(id: task.id, completed: newStatus)
    }
    
    func fetchTasksFromDB() -> [TaskModel] {
        return TaskCoreDataManager.shared.fetchTasks()
    }
}
