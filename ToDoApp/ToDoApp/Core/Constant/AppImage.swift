//
//  AppImage.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//

import UIKit.UIImage

enum AppImage {
    static let taskCompletedIcon = UIImage(named: "taskCompletedIcon")
    static let taskNotCompletedIcon = UIImage(named: "taskNotCompletedIcon")
    static let addTaskIcon = UIImage(named: "addTaskIcon")?.withRenderingMode(.alwaysOriginal)
}
