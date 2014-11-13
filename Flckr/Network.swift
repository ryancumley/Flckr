//
//  Network.swift
//  Flckr
//
//  Created by Ryan Cumley on 11/13/14.
//  Copyright (c) 2014 iTriage. All rights reserved.
//

import Foundation



class NetworkManager: NSObject {
    var session: NSURLSession = vanillaConfiguredNSURLSession()
    
    //func networkOperationUsingRequest(configuredURLRequest request: NSMutableURLRequest) ->
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




class NetworkCall: NSObject, NSURLSessionDataDelegate {
    
}






//MARK: Abstract and Concrete FetchFeedCall

protocol NetworkFetchOperation {
    func start()
    func finish()
    func cancel()
}

protocol FlickrFetchOperation {
    var path: String {get}
    var source: String {get}
    var tagMode: String {get}
    var format: String {get}
    
    func composedURLStringForQuery(queryString query: String) -> String
    
}

class AbstractFetchFeedCall: NSObject, NetworkFetchOperation, FlickrFetchOperation {
    var dataTask: NSURLSessionDataTask?
    
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
    
    func composedURLStringForQuery(queryString query: String) -> String {
        
        return "http://api.flickr.com/\(path)\(source)tagMode=\(tagMode)&format=\(format)&tags=\(query)"
        
                //"http://api.flickr.com/services/feeds/photos_public.gne?tagmode=any&format=json&tags=balloon"
    }
}

class StandardFlickrFetchFeedCall: AbstractFetchFeedCall, FlickrFetchOperation {
    
    override init() {
        super.init()
        
        path = "services/feeds/"
        source = "photos_public.gne?"
        tagMode = "any"
        format = "json"
    }
    
//    func resourcePathForQuery(inputQuery input: String) -> NSMutableURLRequest {
//        //let request = NSMutableURLRequest(URL: NSURL.url
//        
//    }
    
    func findKittens() { //Dev Testing the functionality
        let composedURL = composedURLStringForQuery(queryString: "kitten")
        
        println(composedURL)
    }
}











