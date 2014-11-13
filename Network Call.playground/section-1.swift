// Playground - noun: a place where people can play

import Foundation
import UIKit


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
        //return "http://api.flickr.com/services/feeds/photos_public.gne?tagmode=any&format=json&tags=balloon"
        
        return "http://api.flickr.com\(path)\(source)\(tagMode)\(query)"
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
    
    
    func findKittens() -> String {
        let composedURL = composedURLStringForQuery(queryString: "kitten")
        println(composedURL)
        return composedURL
    }
}


let flickrCall = StandardFlickrFetchFeedCall()
let composed = flickrCall.findKittens()
println(composed)

