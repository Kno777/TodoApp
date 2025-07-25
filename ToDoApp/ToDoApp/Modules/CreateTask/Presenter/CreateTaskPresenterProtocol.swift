//
//  CreateTaskPresenterProtocol.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 25.07.25.
//
import UIKit

protocol CreateTaskPresenterProtocol {
    func saveTask(title: String, body: String)
}

protocol TaskCreationDelegate: AnyObject {
    func didCreateTask(_ task: TaskModel)
}


final class CreateTaskPresenter: CreateTaskPresenterProtocol, CreateTaskInteractorOutputProtocol {
    weak var view: CreateTaskViewProtocol?
    var interactor: CreateTaskInteractorInputProtocol?
    var router: CreateTaskRouterProtocol?
    var delegate: TaskCreationDelegate?

    func saveTask(title: String, body: String) {
        guard !title.isEmpty else {
            view?.showError("Title is required")
            return
        }
        interactor?.saveTask(title: title, body: body)
    }
    
    func taskSaved(_ task: TaskModel) {
        delegate?.didCreateTask(task)
        router?.dismiss()
    }
}

extension TaskListPresenter: TaskCreationDelegate {
    func didCreateTask(_ task: TaskModel) {
        
        tasks = interactor?.fetchTasksFromDB() ?? []
        view?.reloadTableView(with: tasks)
    }
}

