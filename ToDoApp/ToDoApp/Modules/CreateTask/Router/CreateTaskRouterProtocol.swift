//
//  CreateTaskRouterProtocol.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 25.07.25.
//
import UIKit

protocol CreateTaskRouterProtocol {
    func dismiss()
}

final class CreateTaskRouter: CreateTaskRouterProtocol {
    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    static func assembleModule(taskToEdit: TaskModel? = nil, delegate: TaskCreationDelegate?) -> UIViewController {
        let view = CreateTaskViewController()
        let presenter = CreateTaskPresenter()
        let interactor = CreateTaskInteractor(dataManager: TaskCoreDataManager.shared)
        let router = CreateTaskRouter()

        view.presenter = presenter
        presenter.taskToEdit = taskToEdit
        //view.taskToEdit = taskToEdit
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.delegate = delegate
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
