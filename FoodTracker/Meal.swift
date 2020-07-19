
//
//  Meal.swift
//  FoodTracker
//
//  Created by USER on 14/07/2020.
//  Copyright © 2020 USER. All rights reserved.
//
import Foundation
import UIKit

class Meal{
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int){
        
        //실패한 초기화일 경우
        
        //빈 이름이면 안된다.
        guard !name.isEmpty else{
            return nil
        }
        
        //rating은 반드시 0~5
        guard (rating >= 0) && (rating <= 5) else{
            return nil
        }
        
//        if name.isEmpty || rating < 0{
//            return nil
//        }
//
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
