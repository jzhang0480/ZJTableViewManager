//
//	HeroModel.swift
//
//	Create by Javen on 19/6/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class HeroModel: NSObject, NSCoding {
    var name: String!
    var skill: [HeroSkill]!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String: Any]) {
        name = dictionary["name"] as? String
        skill = [HeroSkill]()
        if let skillArray = dictionary["skill"] as? [[String: Any]] {
            for dic in skillArray {
                let value = HeroSkill(fromDictionary: dic)
                skill.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if name != nil {
            dictionary["name"] = name
        }
        if skill != nil {
            var dictionaryElements = [[String: Any]]()
            for skillElement in skill {
                dictionaryElements.append(skillElement.toDictionary())
            }
            dictionary["skill"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        skill = aDecoder.decodeObject(forKey: "skill") as? [HeroSkill]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if skill != nil {
            aCoder.encode(skill, forKey: "skill")
        }
    }
}
