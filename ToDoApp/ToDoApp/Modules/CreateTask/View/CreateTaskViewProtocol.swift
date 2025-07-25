//
//  CreateTaskViewProtocol.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 25.07.25.
//
import UIKit

protocol CreateTaskViewProtocol: AnyObject {
    func showError(_ message: String)
}

final class CreateTaskViewController: UIViewController {
    
    var presenter: CreateTaskPresenter?
    
    private let titleField = UITextField()
    private let bodyField = UITextView()
    private let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let task = presenter?.taskToEdit {
            title = "Редактировать задачу"
            titleField.text = task.title
            bodyField.text = task.details
            saveButton.setTitle("Обновлять", for: .normal)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.primaryBackgroundColor
        title = "Создать задачу"
        navigationItem.leftBarButtonItem?.tintColor = AppColors.yellow
        navigationItem.backBarButtonItem?.tintColor = AppColors.yellow
        navigationItem.backButtonTitle = "Назад"

        titleField.placeholder = "Введите заголовок"
        titleField.borderStyle = .roundedRect
        
        bodyField.layer.borderColor = UIColor.lightGray.cgColor
        bodyField.layer.borderWidth = 1
        bodyField.layer.cornerRadius = 8
        
        saveButton.setTitle("Сохранять", for: .normal)
        saveButton.setTitleColor(AppColors.primaryTextColor, for: .normal)
        saveButton.backgroundColor = AppColors.yellow
        saveButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        saveButton.layer.cornerRadius = 12
        saveButton.clipsToBounds = true
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleField, bodyField, saveButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bodyField.heightAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func didTapSave() {
        presenter?.saveTask(title: titleField.text ?? "", body: bodyField.text ?? "")
    }
}

extension CreateTaskViewController: CreateTaskViewProtocol {
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
