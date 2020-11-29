//
//  Item.swift
//  Recipe Book
//
//  Created by Oliver Reckord Groten on 11/2/20.
//  Copyright © 2020 oreckord. All rights reserved.
//

import Foundation
import UIKit

class Item: NSObject, NSCoding {
    var name: String
    var ingredients: String
    var timeRequired: String
    var creator: String?
    let itemKey: String
    
    init(name: String, ingredients: String, timeRequired: String, creator: String?) {
        self.name = name
        self.ingredients = ingredients
        self.timeRequired = timeRequired
        self.creator = creator
        self.itemKey = UUID().uuidString
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let names = ["Pumpkin Pie", "Chocolate Chip Cookies", "Baked Rice and Beans", "Miso Salmon"]
            let ingredients = ["Water, Salmon", "Chocolate, Salt", "Pumpkin, Coconut Oil", "Black Beans, Cayenne"]
            
            var idx = arc4random_uniform(UInt32(names.count))
            let randomName = names[Int(idx)]
            
            idx = arc4random_uniform(UInt32(ingredients.count))
            let randomIngredients = ingredients[Int(idx)]
            
            self.init(name: randomName, ingredients: randomIngredients, timeRequired: "100", creator: "bee")
        } else {
            self.init(name: "", ingredients: "", timeRequired: "", creator: nil)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(ingredients, forKey: "ingredients")
        aCoder.encode(timeRequired, forKey: "timeRequired")
        aCoder.encode(creator, forKey: "creator")
        aCoder.encode(itemKey, forKey: "itemKey")
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        ingredients = aDecoder.decodeObject(forKey: "ingredients") as! String
        timeRequired = aDecoder.decodeObject(forKey: "timeRequired") as! String
        creator = aDecoder.decodeObject(forKey: "creator") as! String?
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        
        super.init()
    }
}
