//
//  APILoader.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//


import Foundation

// MARK: - API Error handler
enum APIError: Error {
    case invalidURL
    case noData
}

// MARK: - API Loader
final class APILoader {
    
    static let shared = APILoader()
    private init() {}
    
    private var hasLoadedFromAPI: Bool {
        get { UserDefaults.standard.bool(forKey: "hasLoadedFromAPI") }
        set { UserDefaults.standard.set(newValue, forKey: "hasLoadedFromAPI") }
    }

    func loadTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        if hasLoadedFromAPI {
            // Load from Core Data
            let tasks = TaskCoreDataManager.shared.fetchTasks()
            completion(.success(tasks))
        } else {
            // Load from API
            guard let url = URL(string: "https://dummyjson.com/todos") else {
                completion(.failure(APIError.invalidURL))
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(APIError.noData))
                    }
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(TaskAPIResponse.self, from: data)

                    // Save to Core Data
                    TaskCoreDataManager.shared.saveTasks(decoded.todos)
                    self.hasLoadedFromAPI = true

                    // Fetch again from Core Data and return models
                    let savedTasks = TaskCoreDataManager.shared.fetchTasks()
                    DispatchQueue.main.async {
                        completion(.success(savedTasks))
                    }

                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }

            task.resume()
        }
    }

}
