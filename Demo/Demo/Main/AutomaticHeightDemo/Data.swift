//
//  Data.swift
//  NormalExample
//
//  Created by Jie Zhang on 2020/4/14.
//  Copyright © 2020 Green Dot. All rights reserved.
//

import Foundation
func getFeedData() -> [Feed] {
    let data = Data(rawString.utf8)
    let rawArray = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
    var array = [Feed]()
    for obj in rawArray {
        let feed = Feed(fromDictionary: obj as! [String: Any])
        array.append(feed)
    }
    return array
}

class Feed: NSObject, NSCoding {
    var content: String!
    var imageName: String!
    var time: String!
    var title: String!
    var username: String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String: Any]) {
        content = dictionary["content"] as? String
        imageName = dictionary["imageName"] as? String
        time = dictionary["time"] as? String
        title = dictionary["title"] as? String
        username = dictionary["username"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if content != nil {
            dictionary["content"] = content
        }
        if imageName != nil {
            dictionary["imageName"] = imageName
        }
        if time != nil {
            dictionary["time"] = time
        }
        if title != nil {
            dictionary["title"] = title
        }
        if username != nil {
            dictionary["username"] = username
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        content = aDecoder.decodeObject(forKey: "content") as? String
        imageName = aDecoder.decodeObject(forKey: "imageName") as? String
        time = aDecoder.decodeObject(forKey: "time") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if content != nil {
            aCoder.encode(content, forKey: "content")
        }
        if imageName != nil {
            aCoder.encode(imageName, forKey: "imageName")
        }
        if time != nil {
            aCoder.encode(time, forKey: "time")
        }
        if title != nil {
            aCoder.encode(title, forKey: "title")
        }
        if username != nil {
            aCoder.encode(username, forKey: "username")
        }
    }
}

let rawString = """
[
    {
        "title": "William Shakespeare",
        "content": "To be, or not to be —that is the question, Whether'tis nobler in the mind to suffer. The slings and arrows of outrageous fortune Or to take arms against a sea of troubles, And by opposing end them. To die —to sleep",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "1"
    },
    {
        "title": "Franklin Roosevelt",
        "content": "The world can be changed by man's endeavor, and that this endeavor can lead to something new and better .No man can sever the bonds that unite him to his society simply by averting his eyes . He must ever be receptive and sensitive to the new ; and have sufficient courage and skill to novel facts and to deal with them .",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "2"
    },
    {
        "title": "William Shakespeare",
        "content": "",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "1"
    },
    {
        "title": "Franklin Roosevelt",
        "content": "The world can be changed by man's endeavor, and that this endeavor can lead to something new and better .No man can sever the bonds that unite him to his society simply by averting his eyes . He must ever be receptive and sensitive to the new ; and have sufficient courage and skill to novel facts and to deal with them .",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": ""
    },
    {
        "title": "J. Burroughs",
        "content": "A man can fail many times, but he isn't a failure until he begins to blame somebody else",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "3"
    },
    {
        "title": "Robert Louis Stevenson",
        "content": "An aim in life is the only fortune worth finding.",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "4"
    },
    {
        "title": "William Shakespeare",
        "content": "To be, or not to be —that is the question, Whether'tis nobler in the mind to suffer. The slings and arrows of outrageous fortune Or to take arms against a sea of troubles, And by opposing end them. To die —to sleep",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "1"
    },
    {
        "title": "J. Burroughs",
        "content": "A man can fail many times, but he isn't a failure until he begins to blame somebody else",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "3"
    },
    {
        "title": "",
        "content": "Energy and persistence conquer all things. ",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "2"
    },
    {
        "title": "William Shakespeare",
        "content": "To be, or not to be —that is the question, Whether'tis nobler in the mind to suffer. The slings and arrows of outrageous fortune Or to take arms against a sea of troubles, And by opposing end them. To die —to sleep",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "1"
    },
    {
        "title": "Franklin Roosevelt",
        "content": "The world can be changed by man's endeavor, and that this endeavor can lead to something new and better .No man can sever the bonds that unite him to his society simply by averting his eyes . He must ever be receptive and sensitive to the new ; and have sufficient courage and skill to novel facts and to deal with them .",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "2"
    },
    {
        "title": "William Shakespeare",
        "content": "",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "1"
    },
    {
        "title": "Franklin Roosevelt",
        "content": "The world can be changed by man's endeavor, and that this endeavor can lead to something new and better .No man can sever the bonds that unite him to his society simply by averting his eyes . He must ever be receptive and sensitive to the new ; and have sufficient courage and skill to novel facts and to deal with them .",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": ""
    },
    {
        "title": "J. Burroughs",
        "content": "A man can fail many times, but he isn't a failure until he begins to blame somebody else",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "3"
    },
    {
        "title": "Robert Louis Stevenson",
        "content": "An aim in life is the only fortune worth finding.",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "4"
    },
    {
        "title": "William Shakespeare",
        "content": "To be, or not to be —that is the question, Whether'tis nobler in the mind to suffer. The slings and arrows of outrageous fortune Or to take arms against a sea of troubles, And by opposing end them. To die —to sleep",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "1"
    },
    {
        "title": "J. Burroughs",
        "content": "A man can fail many times, but he isn't a failure until he begins to blame somebody else",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "3"
    },
    {
        "title": "",
        "content": "Energy and persistence conquer all things. ",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "2"
    },
    {
        "title": "William Shakespeare",
        "content": "To be, or not to be —that is the question, Whether'tis nobler in the mind to suffer. The slings and arrows of outrageous fortune Or to take arms against a sea of troubles, And by opposing end them. To die —to sleep",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "1"
    },
    {
        "title": "Franklin Roosevelt",
        "content": "The world can be changed by man's endeavor, and that this endeavor can lead to something new and better .No man can sever the bonds that unite him to his society simply by averting his eyes . He must ever be receptive and sensitive to the new ; and have sufficient courage and skill to novel facts and to deal with them .",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "2"
    },
    {
        "title": "William Shakespeare",
        "content": "",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "1"
    },
    {
        "title": "Franklin Roosevelt",
        "content": "The world can be changed by man's endeavor, and that this endeavor can lead to something new and better .No man can sever the bonds that unite him to his society simply by averting his eyes . He must ever be receptive and sensitive to the new ; and have sufficient courage and skill to novel facts and to deal with them .",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": ""
    },
    {
        "title": "J. Burroughs",
        "content": "A man can fail many times, but he isn't a failure until he begins to blame somebody else",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "3"
    },
    {
        "title": "Robert Louis Stevenson",
        "content": "An aim in life is the only fortune worth finding.",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "4"
    },
    {
        "title": "William Shakespeare",
        "content": "To be, or not to be —that is the question, Whether'tis nobler in the mind to suffer. The slings and arrows of outrageous fortune Or to take arms against a sea of troubles, And by opposing end them. To die —to sleep",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "1"
    },
    {
        "title": "J. Burroughs",
        "content": "A man can fail many times, but he isn't a failure until he begins to blame somebody else",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "3"
    },
    {
        "title": "",
        "content": "Energy and persistence conquer all things. ",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "2"
    },
    {
        "title": "William Shakespeare",
        "content": "To be, or not to be —that is the question, Whether'tis nobler in the mind to suffer. The slings and arrows of outrageous fortune Or to take arms against a sea of troubles, And by opposing end them. To die —to sleep",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "1"
    },
    {
        "title": "Franklin Roosevelt",
        "content": "The world can be changed by man's endeavor, and that this endeavor can lead to something new and better .No man can sever the bonds that unite him to his society simply by averting his eyes . He must ever be receptive and sensitive to the new ; and have sufficient courage and skill to novel facts and to deal with them .",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "2"
    },
    {
        "title": "William Shakespeare",
        "content": "",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "1"
    },
    {
        "title": "Franklin Roosevelt",
        "content": "The world can be changed by man's endeavor, and that this endeavor can lead to something new and better .No man can sever the bonds that unite him to his society simply by averting his eyes . He must ever be receptive and sensitive to the new ; and have sufficient courage and skill to novel facts and to deal with them .",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": ""
    },
    {
        "title": "J. Burroughs",
        "content": "A man can fail many times, but he isn't a failure until he begins to blame somebody else",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "3"
    },
    {
        "title": "Robert Louis Stevenson",
        "content": "An aim in life is the only fortune worth finding.",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "4"
    },
    {
        "title": "William Shakespeare",
        "content": "To be, or not to be —that is the question, Whether'tis nobler in the mind to suffer. The slings and arrows of outrageous fortune Or to take arms against a sea of troubles, And by opposing end them. To die —to sleep",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "1"
    },
    {
        "title": "J. Burroughs",
        "content": "A man can fail many times, but he isn't a failure until he begins to blame somebody else",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "3"
    },
    {
        "title": "",
        "content": "Energy and persistence conquer all things. ",
        "username": "jzhang0480",
        "time": "2020.04.10",
        "imageName": "2"
    },
]
"""
