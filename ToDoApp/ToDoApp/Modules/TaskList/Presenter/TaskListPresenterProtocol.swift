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
    var router: TaskListRouterProtocol?

    func viewDidLoad() {
        interactor?.fetchTasks()
    }
    
    func didTapEdit(_ task: TaskModel) {
        router?.showEditScreen(for: task)
    }
    
    func didTapShare(_ task: TaskModel) {
        router?.presentShareSheet(for: task)
    }

    func didTapDelete(_ task: TaskModel, at index: Int) {
        view?.deleteRow(at: index)
        interactor?.deleteTask(task, at: index)
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
