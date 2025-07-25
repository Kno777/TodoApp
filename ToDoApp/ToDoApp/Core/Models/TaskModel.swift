//
//  TaskModel.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//
import Foundation

struct TaskModel: Equatable {
    let id: Int
    let title: String
    let details: String
    let createdAt: Date
    var isCompleted: Bool
}

extension TaskModel {
    init(from entity: TaskEntity) {
        self.id = Int(entity.id)
        self.title = entity.title ?? ""
        self.details = entity.details ?? ""
        self.createdAt = entity.createdAt ?? Date()
        self.isCompleted = entity.isCompleted
    }
}
