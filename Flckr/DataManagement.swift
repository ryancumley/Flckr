//
//  DataManagement.swift
//  Flckr
//
//  Created by Ryan Cumley on 11/13/14.
//  Copyright (c) 2014 iTriage. All rights reserved.
//

import Foundation


class DataManager: NSObject {
    var currentlyImportedFeedItems: [FlickrFeedItem]?
    
    
}











//MARK: FlickrFeedItem and support
class FlickrFeedItem: NSObject {
    var title: String?
    var link: String?
    var media: [String : String]?
    var dateTaken: NSDate?
    var photoDescription: String?
    var published: NSDate?
    var author: String?
    var authorID: String?
    var tags: [String]?
    var extractedHeightValue: Int?
    var extractedWidthValue: Int?
    
    class func feedItemByMappingInput(inputDictionary input: [String : AnyObject]) -> FlickrFeedItem {
        var retVal = FlickrFeedItem()
        
        retVal.title = input["title"]? as? String
        retVal.link = input["link"]? as? String
        retVal.media = input["media"]? as? [String : String]
        if let candidate = input["date_taken"]? as? String { retVal.dateTaken = foundationDateFromFlickrFormatDateString(dateString: candidate) }
        retVal.photoDescription = input["description"]? as? String
        if let candidate = input["published"]? as? String { retVal.published = foundationDateFromFlickrFormatDateString(dateString: candidate) }
        retVal.author = input["author"]? as? String
        retVal.authorID = input["author_id"]? as? String
        if let candidate = input["tags"]? as? String { retVal.tags = structuredTagsFrom(tagString: candidate) }
        
        if let sourceDescription = retVal.photoDescription {
            if let heightWidthTuple = extractHeightAndWidthFromFlickrDescription(descriptionString: sourceDescription) {
                retVal.extractedHeightValue = heightWidthTuple.height
                retVal.extractedWidthValue = heightWidthTuple.width
            }
        }
        
        return retVal
    }
}

func mediaMDictionaryFromNestedInput(inputDictionary input: [String : String]) -> [String : String] {
    
    return ["Fake" : "Not Real"]
}

func foundationDateFromFlickrFormatDateString(dateString date: String) -> NSDate {
    
    return NSDate.distantFuture() as NSDate
}

func structuredTagsFrom(tagString tags: String) -> [String] {
    
    return ["fake"]
}

func extractHeightAndWidthFromFlickrDescription(descriptionString input: String) -> (height: Int, width: Int)? {
    
    return (10, 20)
}
//MARK:-