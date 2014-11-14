//
//  DataManagement.swift
//  Flckr
//
//  Created by Ryan Cumley on 11/13/14.
//  Copyright (c) 2014 iTriage. All rights reserved.
//

import Foundation


class DataManager: NSObject {
    var currentlyImportedFeedItems = [FlickrFeedItem]()
    
    func processPotentialFeedItemCandidates(rawDataResponse data: NSData, completionHandler: () -> ()) {
        clearAllCurrentlyStoredFeedItems()
        var serializationError: NSError?
        let parsableData = parsableDataFromRawFlickrData(rawData: data)
        if let foundationRepresentation = NSJSONSerialization.JSONObjectWithData(parsableData, options: NSJSONReadingOptions.AllowFragments, error: &serializationError) as? [String: AnyObject] {
            if let justTheItems = foundationRepresentation["items"]? as? [[String: AnyObject]] {
                for item in justTheItems {
                    let mappedItem = FlickrFeedItem.feedItemByMappingInput(inputDictionary: item)
                    currentlyImportedFeedItems.append(mappedItem)
                    println(mappedItem.title)
                }
            }
        }
        
        if currentlyImportedFeedItems.count == 0 { handleZeroResultQueryResponse() }
        completionHandler()
    }
    
    private func clearAllCurrentlyStoredFeedItems() {
        currentlyImportedFeedItems = [FlickrFeedItem]()
    }
    
    private func handleZeroResultQueryResponse() {
        let item = FlickrFeedItem()
        item.title = "No Results Matched that Tag"
        currentlyImportedFeedItems.append(item)
    }
    
    private func parsableDataFromRawFlickrData(#rawData: NSData) -> NSData {
       //hat tip to http://stackoverflow.com/questions/8684667/nsjsonserialization for the basis of this Swift implementation
        if let rawDataString = NSString(data: rawData, encoding: NSUTF8StringEncoding) {
            if rawDataString.length > 0 {
                let trimmedRawDataString = rawDataString.substringWithRange(NSMakeRange(15, rawDataString.length-15-1))
                let properJSONString = trimmedRawDataString.stringByReplacingOccurrencesOfString("//", withString: "'")
                if let parsableData = properJSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    return parsableData
                }
            }
        }
        return NSData()
    }
}
//MARK:-




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