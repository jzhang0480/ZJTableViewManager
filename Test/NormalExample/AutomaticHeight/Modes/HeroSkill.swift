//
//	HeroSkill.swift
//
//	Create by Javen on 19/6/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class HeroSkill: NSObject, NSCoding {
    var desc: String!
    var name: String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String: Any]) {
        desc = dictionary["desc"] as? String
        name = dictionary["name"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if desc != nil {
            dictionary["desc"] = desc
        }
        if name != nil {
            dictionary["name"] = name
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        desc = aDecoder.decodeObject(forKey: "desc") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if desc != nil {
            aCoder.encode(desc, forKey: "desc")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
    }
}
