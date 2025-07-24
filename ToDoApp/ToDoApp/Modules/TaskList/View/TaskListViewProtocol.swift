//
//  TaskListViewProtocol.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//


protocol TaskListViewProtocol: AnyObject {
    func showTasks(_ tasks: [TaskModel])
    func showError(_ message: String)
    func deleteRow(at index: Int)
    func updateRow(at index: Int)
}
