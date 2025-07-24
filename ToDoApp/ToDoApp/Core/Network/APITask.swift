//
//  APITask.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//

import Foundation

struct APITask: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct TaskAPIResponse: Decodable {
    let todos: [APITask]
}

extension APITask {
    func toTaskModel() -> TaskModel {
        return TaskModel(
            id: self.id,
            title: self.todo,
            details: "",
            createdAt: Date(),
            isCompleted: self.completed
        )
    }
}
