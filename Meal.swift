//
//  Meal.swift
//  FoodTracker
//
//  Created by Sam on 5/30/16.
//  Copyright © 2016 Sam. All rights reserved.
//

import UIKit

struct PropertyKey {
    static let name_key = "name"
    static let photo_key = "photo"
    static let rating_key = "rating"
}

class Meal: NSObject, NSCoding {
    var name: String
    var photo: UIImage?
    var rating: Int
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let Archive_URL = DocumentsDirectory.URLByAppendingPathComponent("meals")
    
    init?(name: String, photo: UIImage?, rating: Int) {
        self.name = name
        self.photo = photo
        self.rating = rating
        
        super.init()
        
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.name_key) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photo_key) as? UIImage
        let rating = aDecoder.decodeObjectForKey(PropertyKey.rating_key) as! Int
        
        self.init(name: name, photo: photo, rating: rating)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.name_key)
        aCoder.encodeObject(photo, forKey: PropertyKey.photo_key)
        aCoder.encodeObject(rating, forKey: PropertyKey.rating_key)
    }

}
