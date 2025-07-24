//
//  TaskListPresenterProtocol.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//
import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    func didFetchTasks(_ tasks: [TaskModel])
    func didFailToFetchTasks(_ error: Error)
}

final class TaskListPresenter {
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?

    func viewDidLoad() {
        interactor?.fetchTasks()
    }
}

extension TaskListPresenter: TaskListPresenterProtocol {
    func didFetchTasks(_ tasks: [TaskModel]) {
        view?.showTasks(tasks)
    }

    func didFailToFetchTasks(_ error: Error) {
        view?.showError("Failed to fetch tasks: \(error.localizedDescription)")
    }
}
