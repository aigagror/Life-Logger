//
//  DatabaseController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/12/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation
import CoreData
class DatabaseController {
    
    // MARK: Properties
    static let activityClassName = String(describing: Activity.self)
    static let logClassName = String(describing: Log.self)
    
    private init() {
        
    }
    
    class func getContext() -> NSManagedObjectContext {
        return DatabaseController.persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Activities")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    class func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: Activity and log functions
    class func loadActivities() -> [Activity]? {
        let fetchRequest: NSFetchRequest<Activity> = Activity.fetchRequest()
        
        do {
            var searchResults = try getContext().fetch(fetchRequest)
            searchResults.sort(by: { (a1, a2) -> Bool in
                return a1.logs!.count > a2.logs!.count
            })
            return searchResults
        }
        catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    class func loadLogs() -> [Log]? {
        let fetchRequest: NSFetchRequest<Log> = Log.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateStarted", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            return searchResults
        }
        catch {
            print("Error: \(error)")
        }
        return nil
    }
}
