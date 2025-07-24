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

    func loadTasks(completion: @escaping (Result<[APITask], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Ensure UI stays responsive
            DispatchQueue.global(qos: .background).async {
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
                    DispatchQueue.main.async {
                        completion(.success(decoded.todos))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }

        task.resume()
    }
}
