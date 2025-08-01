//
//  CreateTaskInteractorInputProtocol.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 25.07.25.
//
import UIKit

protocol CreateTaskInteractorInputProtocol {
    func saveTask(title: String, body: String)
    func updateTask(_ task: TaskModel, title: String, body: String)
}

protocol CreateTaskInteractorOutputProtocol: AnyObject {
    func taskSaved(_ task: TaskModel)
    func taskUpdated(_ task: TaskModel)
}

final class CreateTaskInteractor: CreateTaskInteractorInputProtocol {
    weak var presenter: CreateTaskInteractorOutputProtocol?
    let dataManager: TaskCoreDataManager

    init(dataManager: TaskCoreDataManager) {
        self.dataManager = dataManager
    }

    func saveTask(title: String, body: String) {
        let task = dataManager.createTask(title: title, body: body)
        presenter?.taskSaved(task)
    }
    
    func updateTask(_ task: TaskModel, title: String, body: String) {
        let updatedTask = dataManager.updateTask(id: Int64(task.id), newTitle: title, newDetails: body, completed: task.isCompleted)
        
        guard let updatedTask = updatedTask else { return }
        
        presenter?.taskUpdated(updatedTask)
    }
}
