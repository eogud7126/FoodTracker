//
//  MealDAO.swift
//  FoodTracker
//
//  Created by USER on 19/07/2020.
//  Copyright © 2020 USER. All rights reserved.
//

import UIKit
import CoreData

class MealDAO{
        
    let coreDataStack = CoreDataStack()
    static let shared:MealDAO = MealDAO()
    lazy var mainContext: NSManagedObjectContext = coreDataStack.mainManagedObjectContext
    
    
//    func fetch(keyword text: String? = nil) -> [MealMO] {
//        var fetchResults = [MealMO]()
//        //        childContext.parent = context
//        //요청 객체 생성
//        let fetchRequest: NSFetchRequest<MealMO> = MealMO.fetchRequest()
//
//        //평점 순으로 정렬
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
//
//        //검색 키워드가 있을 경우
//        if let text = text, text.isEmpty == false{
//            fetchRequest.predicate = NSPredicate(format: "name  CONTAINS[c] %@", text)
//        }
//
//        do{
//            fetchResults = try self.mainContext.fetch(fetchRequest)
//
//        }catch let error as NSError{
//            NSLog("An error has occured: %s", error.localizedDescription)
//        }
//
//        return fetchResults
//    }
//
    var _fetchedResultsController: NSFetchedResultsController<MealMO>?
    var fetchedResultsController: NSFetchedResultsController<MealMO> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
//        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: nil)
        
        let fetchRequest: NSFetchRequest<MealMO> = MealMO.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "rating", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        _fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try _fetchedResultsController?.performFetch()
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return _fetchedResultsController!
    }
    func insert(){
        
        //create worker thread
//        let workerContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
//        workerContext.parent = self.mainContext
        guard let fetResults = _fetchedResultsController else { return }
        let context = fetResults.managedObjectContext
        
        do{
            try context.save()
            print("insert")
        } catch let error as NSError {
            print(error)
        }
//            self.coreDataStack.saveWorkerContext(workerContext)
//        self.coreDataStack.mergeWithMainContext()
//            self.postupdateNotification()
        
    }
    
    func delete(at indexPath: IndexPath) {
        guard let fetResults = _fetchedResultsController else { return }
        let context = fetResults.managedObjectContext
        context.delete(fetResults.object(at: indexPath))
        do {
            try context.save()
        } catch let error as NSError{
            print(error)
        }
    }
    
    func postupdateNotification(){
        NotificationCenter.default.post(name: Notification.Name("updateMealTableData"), object: nil)
    }
}
