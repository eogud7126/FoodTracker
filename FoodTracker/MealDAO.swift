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
    
    lazy var mainContext: NSManagedObjectContext = coreDataStack.mainManagedObjectContext
    
    
    func fetch(keyword text: String? = nil) -> [MealMO] {
        var fetchResults = [MealMO]()
        //        childContext.parent = context
        //요청 객체 생성
        let fetchRequest: NSFetchRequest<MealMO> = MealMO.fetchRequest()
        
        //평점 순으로 정렬
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "rating", ascending: false)]
        
        //검색 키워드가 있을 경우
        if let text = text, text.isEmpty == false{
            fetchRequest.predicate = NSPredicate(format: "name  CONTAINS[c] %@", text)
        }
        
        do{
            fetchResults = try self.mainContext.fetch(fetchRequest)
            
        }catch let error as NSError{
            NSLog("An error has occured: %s", error.localizedDescription)
        }
        
        return fetchResults
    }
    
    func insert(_ meal: Meal){
        
        //create worker thread
        let workerContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        workerContext.parent = self.mainContext
                
        
        let object = NSEntityDescription.insertNewObject(forEntityName: "Meal", into: workerContext) as! MealMO
        
        //Meal로부터 값을 복사
        object.name = meal.name
        object.rating = meal.rating ?? 0
        
        if let photo = meal.photo{
            object.photo = photo.pngData()
        }
                
        print(Thread.current.isMainThread)
        self.coreDataStack.saveWorkerContext(workerContext)
        self.coreDataStack.mergeWithMainContext()
    }
    
    func delete(_ objectID: NSManagedObjectID) {
        //삭제할 객체를 찾고 컨텍스트에서 삭제
        let object = self.mainContext.object(with: objectID)
        self.mainContext.delete(object)
        
        //영구저장소 적용
        self.coreDataStack.mergeWithMainContext()
        self.postupdateNotification()
    }
    
    func postupdateNotification(){
        NotificationCenter.default.post(name: Notification.Name("updateMealTableData"), object: nil)
    }
}
