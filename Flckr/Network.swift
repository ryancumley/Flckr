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



class naiveFlickrFeedCall: NSObject {
    
}




class NetworkCall: NSObject, NSURLSessionDataDelegate {
    
}






//MARK: Abstract and Concrete FetchFeedCall

protocol NetworkFetchOperation {
    func start()
    func finish()
    func cancel()
}

class AbstractFetchFeedCall: NSOperation/*, NetworkFetchOperation*/ {
    
}