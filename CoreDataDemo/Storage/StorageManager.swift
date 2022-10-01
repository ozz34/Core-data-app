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
    
    var taskList: [Task] = []
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private let context: NSManagedObjectContext?
    
    private init() {
        context = persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext(_ taskName: String) {
        let task = Task(context: context)
        task.name = taskName
        taskList.append(task)
        
        if context.hasChanges {
            do {
                try context?.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() {
        let fetchRequest = Task.fetchRequest()
        do {
            taskList = try context?.fetch(fetchRequest)
        } catch {
            print("failed")
        }
    }
}

