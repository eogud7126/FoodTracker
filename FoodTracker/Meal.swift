//
//  Meal.swift
//  FoodTracker
//
//  Created by USER on 14/07/2020.
//  Copyright © 2020 USER. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Meal: NSObject, NSCoding{
    //MARK: NSCoding required
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // name은 필수. 만약 name을 디코딩하지 못한다면 이니셜라이즈는 실패할 것이다.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else{
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type:.debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        //반드시 필요한 designated init
        self.init(name: name, photo: photo, rating: rating)
    }
    
    //MARK: Properties
    
    struct PropertyKey{
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
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


    //MARK: Archiving Paths
     
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
}

