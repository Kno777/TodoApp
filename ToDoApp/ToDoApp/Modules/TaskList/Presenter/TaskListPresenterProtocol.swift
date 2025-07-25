//
//  TaskListPresenterProtocol.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//
import Foundation
import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    func didFetchTasks(_ tasks: [TaskModel])
    func didFailToFetchTasks(_ error: Error)
}

final class TaskListPresenter {
    var tasks: [TaskModel] = []
    var viewController: UIViewController?
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?

    func viewDidLoad() {
        interactor?.fetchTasks()
    }
    
    func didTapEdit(_ task: TaskModel) {
        let createVC = CreateTaskRouter.assembleModule(taskToEdit: task, delegate: self)
        viewController?.navigationController?.pushViewController(createVC, animated: true)
    }
    
    func didTapShare(_ task: TaskModel) {
        router?.presentShareSheet(for: task)
    }

    func didTapDelete(_ task: TaskModel, at index: Int) {
        view?.deleteRow(at: index)
        interactor?.deleteTask(task, at: index)
    }
    
    func didToggleCompletion(for task: TaskModel, at index: Int) {
        interactor?.toggleTaskCompletion(task)
        view?.updateRow(at: index)
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
