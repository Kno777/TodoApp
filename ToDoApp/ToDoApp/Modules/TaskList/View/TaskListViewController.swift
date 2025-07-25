//
//  TaskListViewController.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//


import UIKit

final class TaskListViewController: UITableViewController, UIContextMenuInteractionDelegate {
    var presenter: TaskListPresenter?
    private var tasks: [TaskModel] = []
    private var filteredTasks: [TaskModel] = []
    private var selectedTask: TaskModel?
    private var selectedIndexPath: IndexPath?
    private let searchController = UISearchController(searchResultsController: nil)

    private let bottomView = UIView()
    private let taskCountLabel = UILabel()
    private let createTaskButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        presenter?.viewDidLoad()
        setupBottomView()
    }

    // MARK: - UI Setup

    private func setupUI() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: AppColors.primaryTextColor]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: AppColors.primaryTextColor ]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.backgroundColor = AppColors.primaryBackgroundColor

        view.backgroundColor = AppColors.primaryBackgroundColor
        tableView.backgroundColor = AppColors.primaryBackgroundColor
        tableView.separatorColor = AppColors.secondaryTextColor
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "TaskCell")

        // Give space for bottom view
        tableView.contentInset.bottom = 80
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.barStyle = .black
        searchController.searchBar.searchTextField.textColor = AppColors.primaryTextColor
        searchController.searchBar.tintColor = AppColors.primaryTextColor
        searchController.searchBar.searchTextField.leftView?.tintColor = AppColors.primaryTextColor

        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupBottomView() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = AppColors.secondaryBackgroundColor
        view.addSubview(bottomView)

        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 36),
            bottomView.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Task Count Label (center)
        taskCountLabel.text = "\(tasks.count) tasks"
        taskCountLabel.textColor = AppColors.primaryTextColor
        taskCountLabel.font = .systemFont(ofSize: 16, weight: .medium)
        taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(taskCountLabel)

        NSLayoutConstraint.activate([
            taskCountLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20),
            taskCountLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor)
        ])
        
        
        // Create Task Button (left)
        createTaskButton.setImage(AppImage.addTaskIcon, for: .normal)
        createTaskButton.translatesAutoresizingMaskIntoConstraints = false
        createTaskButton.addTarget(self, action: #selector(didTapCreateTask), for: .touchUpInside)
        bottomView.addSubview(createTaskButton)
        
        NSLayoutConstraint.activate([
            createTaskButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
            createTaskButton.centerYAnchor.constraint(equalTo: taskCountLabel.centerYAnchor),
            
            createTaskButton.heightAnchor.constraint(equalToConstant: 28),
            createTaskButton.widthAnchor.constraint(equalToConstant: 28)
        ])
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredTasks.count : tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let task = isFiltering ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        cell.configure(with: task)
        
        cell.delegate = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        cell.addGestureRecognizer(longPress)
        
        return cell
    }

    // MARK: - Helpers

    private var isFiltering: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    func updateTasks(_ tasks: [TaskModel]) {
        DispatchQueue.main.async {
            self.taskCountLabel.text = "\(tasks.count) Задач"
        }
    }
    
    // MARK: - Selectors
    
    @objc private func didTapCreateTask() {
        let createTaskVC = CreateTaskRouter.assembleModule(delegate: presenter)
        navigationItem.leftBarButtonItem?.tintColor = AppColors.yellow
        navigationItem.backBarButtonItem?.tintColor = AppColors.yellow
        navigationItem.backButtonTitle = "Назад"
        navigationController?.pushViewController(createTaskVC, animated: true)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began,
              let cell = gesture.view as? TaskTableViewCell,
              let indexPath = tableView.indexPath(for: cell) else { return }
        
        let task = isFiltering ? filteredTasks[indexPath.row] : tasks[indexPath.row]
        selectedIndexPath = indexPath
        selectedTask = task
        
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
    }

    // MARK: - UIContextMenuInteractionDelegate
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            guard let task = self.selectedTask else { return nil }
            guard let indexPath = self.selectedIndexPath else { return nil }
            
            return UIMenu(title: "", children: [
                UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                    self.presenter?.viewController = self
                    self.presenter?.didTapEdit(task)
                },
                UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                    self.presenter?.didTapShare(task)
                },
                UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    self.presenter?.didTapDelete(task, at: indexPath.row)
                }
            ])
        }
    }
}


// MARK: - UISearchResultsUpdating

extension TaskListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased() else { return }
        filteredTasks = tasks.filter { $0.title.lowercased().contains(query) || $0.details.lowercased().contains(query) }
        tableView.reloadData()
    }
}


extension TaskListViewController: TaskListViewProtocol {
    func showTasks(_ tasks: [TaskModel]) {
        self.tasks = tasks
        tableView.reloadData()
        updateTasks(tasks)
    }

    func showError(_ message: String) {
        print("Error: \(message)")
    }
    
    func deleteRow(at index: Int) {
        let item = isFiltering ? filteredTasks[index] : tasks[index]

        if isFiltering {
            // Remove from filteredTasks
            filteredTasks.remove(at: index)

            // Remove from main tasks as well
            if let fullIndex = tasks.firstIndex(where: { $0.id == item.id }) {
                tasks.remove(at: fullIndex)
            }
        } else {
            tasks.remove(at: index)
        }

        // Reload instead of delete if only 1 item (for smooth animation)
        let remainingCount = isFiltering ? filteredTasks.count : tasks.count
        if remainingCount == 0 {
            tableView.reloadData()
        } else {
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            tableView.endUpdates()
        }

        updateTasks(tasks)
    }
    
    func updateRow(at index: Int) {
        if isFiltering {
            filteredTasks[index].isCompleted.toggle()
        } else {
            tasks[index].isCompleted.toggle()
        }
        
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }

    func insertRow(at index: Int) {
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func reloadTableView(with tasks: [TaskModel]) {
        self.tasks = tasks
        tableView.reloadData()
    }
}


extension TaskListViewController: TaskTableViewCellDelegate {
    func didToggleCompletion(for task: TaskModel) {
        
        let tasksItems = isFiltering ? filteredTasks : tasks

        guard let index = tasksItems.firstIndex(where: { $0.id == task.id }) else { return }

        presenter?.didToggleCompletion(for: task, at: index)
    }
}
