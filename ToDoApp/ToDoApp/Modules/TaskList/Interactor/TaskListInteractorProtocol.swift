//
//  TaskListInteractorProtocol.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//
import Foundation

protocol TaskListInteractorProtocol: AnyObject {
    func fetchTasks()
}

final class TaskListInteractor: TaskListInteractorProtocol {
    weak var presenter: TaskListPresenterProtocol?

    func fetchTasks() {
        APILoader.shared.loadTasks { [weak self] result in
            switch result {
            case .success(let apiTasks):
                let tasks = apiTasks.map {
                    $0.toTaskModel()
                }
                self?.presenter?.didFetchTasks(tasks)
            case .failure(let error):
                self?.presenter?.didFailToFetchTasks(error)
            }
        }
    }
}
