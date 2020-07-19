
//
//  Meal.swift
//  FoodTracker
//
//  Created by USER on 14/07/2020.
//  Copyright © 2020 USER. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class Meal{
    //MARK: Properties
    var name: String?
    var photo: UIImage?
    var rating: Int?
    
    //원본 MealMO 객체를 참조하기 위한 속성
    var objectID: NSManagedObjectID?
   
}
