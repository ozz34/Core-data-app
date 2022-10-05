//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Иван Худяков on 01.10.2022.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private lazy var context = StorageManager.shared.persistentContainer.viewContext
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private init() {}
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchData(completion: @escaping(Result<[Task],Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        do {
            let taskData = try context.fetch(fetchRequest)
            completion(.success(taskData))
        } catch let error {
            completion(.failure(error))
        }
    }

    func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: context)
        task.name = taskName
        completion(task)
        saveContext()
    }
    
    func delete(_ task: Task) {
        context.delete(task)
        saveContext()
    }
    
    func edit(_ task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
}

