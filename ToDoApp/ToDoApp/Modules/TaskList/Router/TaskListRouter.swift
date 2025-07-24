//
//  TaskListRouter.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//


import UIKit

protocol TaskListRouterProtocol: AnyObject {
    func showEditScreen(for task: TaskModel)
    func presentShareSheet(for task: TaskModel)
}


final class TaskListRouter: TaskListRouterProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = TaskListViewController()
        let presenter = TaskListPresenter()
        let interactor = TaskListInteractor()
        let router = TaskListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        router.viewController = view
        
        return view
    }
    
    func showEditScreen(for task: TaskModel) {
        print("Tap Edit Button")
        //let editVC = EditTaskViewController(task: task)
        //viewController?.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func presentShareSheet(for task: TaskModel) {
        print("Tap Share Button")
        let activityVC = UIActivityViewController(activityItems: [task.title], applicationActivities: nil)
        viewController?.present(activityVC, animated: true, completion: nil)
    }
}
