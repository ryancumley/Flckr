//
//  Network.swift
//  Flckr
//
//  Created by Ryan Cumley on 11/13/14.
//  Copyright (c) 2014 iTriage. All rights reserved.
//

import Foundation
import UIKit



class NetworkManager: NSObject {
    let session: NSURLSession = vanillaConfiguredNSURLSession()
}

func vanillaConfiguredNSURLSession() -> NSURLSession {
    return NSURLSession(configuration: vanillaConfiguration())
}

func vanillaConfiguration() -> NSURLSessionConfiguration {
    let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    
    sessionConfiguration.allowsCellularAccess = true
    sessionConfiguration.timeoutIntervalForRequest = 10.0
    sessionConfiguration.timeoutIntervalForResource = 30.0
    sessionConfiguration.requestCachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
    
    return sessionConfiguration
}
//MARK:-



//MARK: Abstract FetchFeedCall Config
protocol NetworkFetchOperation {
    func start()
    func finish()
    func cancel()
    
}

protocol ConcreteNetworkFetchOperation {
    class func fetchFeedCallFor(query: String, completionHandler: (NSData!, NSURLResponse!, NSError!) -> Void) -> protocol<NetworkFetchOperation, FlickrFetchOperation>
}

protocol FlickrFetchOperation {
    var path: String {get}
    var source: String {get}
    var tagMode: String {get}
    var format: String {get}
}

class AbstractFetchFeedCall: NSObject, NetworkFetchOperation, FlickrFetchOperation {
    var dataTask: NSURLSessionDataTask?
    var networkManager = appDelegate.serviceLocator.injectedNetworkManager //'let' would work, but 'var' allows our unit test to swap out a different Network Manager after initialization
    
    var path = "abstract"
    var source = "abstract"
    var tagMode = "abstract"
    var format = "abstract"
    
    
    func start() {
        dataTask?.resume()
    }
    
    func finish() {
        dataTask?.finalize()
    }
    
    func cancel() {
        dataTask?.cancel()
    }
    
    private func composedURLStringForQuery(queryString query: String) -> String {
        return "\(path)\(source)tagMode=\(tagMode)&format=\(format)&tags=\(query)"
    }
    
    private func queryRequestForInput(inputQuery input: String) -> NSMutableURLRequest {
        if let theURL = NSURL(string: self.composedURLStringForQuery(queryString: input)) {
            let request = NSMutableURLRequest(URL: theURL)
            return request
        }
        
        return NSMutableURLRequest() //not the best handling of failed NSURL creation...
    }
    
    private func dataTaskConfiguredFor(#query: String, completionHandler: ((NSData!, NSURLResponse!, NSError!) -> Void)?) -> NSURLSessionDataTask {
        let request = queryRequestForInput(inputQuery: query)
        let session = networkManager.session
        return session.dataTaskWithRequest(request, completionHandler: completionHandler)
    }
    
}


//MARK: Concrete Calls
class StandardFlickrFetchFeedCall: AbstractFetchFeedCall, FlickrFetchOperation, ConcreteNetworkFetchOperation {
    
    override init() {
        super.init()
        
        path = "http://api.flickr.com/services/feeds/"
        source = "photos_public.gne?"
        tagMode = "any"
        format = "json"
    }
    
    class func fetchFeedCallFor(query: String, completionHandler: (NSData!, NSURLResponse!, NSError!) -> Void) -> protocol<NetworkFetchOperation, FlickrFetchOperation> {
        let fetchFeedCall = StandardFlickrFetchFeedCall()
        fetchFeedCall.dataTask = fetchFeedCall.dataTaskConfiguredFor(query: query, completionHandler: completionHandler)
        return fetchFeedCall
    }
    
}

class GermanFlickrFetchFeedCall: AbstractFetchFeedCall, FlickrFetchOperation, ConcreteNetworkFetchOperation {
    
    var language = "de-de"
    
    override init () {
        super.init()
        
        path = "http://api.flickr.com/services/feeds/"
        source = "photos_public.gne?"
        tagMode = "any"
        format = "json"
    }
    
    override func composedURLStringForQuery(queryString query: String) -> String {
        let basicComposedString = super.composedURLStringForQuery(queryString: query)
        return "\(basicComposedString)lang=\(language)"
    }
    
    class func fetchFeedCallFor(query: String, completionHandler: (NSData!, NSURLResponse!, NSError!) -> Void) -> protocol<NetworkFetchOperation, FlickrFetchOperation> {
        let fetchFeedCall = GermanFlickrFetchFeedCall()
        fetchFeedCall.dataTask = fetchFeedCall.dataTaskConfiguredFor(query: query, completionHandler: completionHandler)
        return fetchFeedCall
    }
}












