//
//  FlickrFeedScreen.swift
//  Flckr
//
//  Created by Ryan Cumley on 11/13/14.
//  Copyright (c) 2014 iTriage. All rights reserved.
//

import Foundation
import UIKit


class FlickrFeedTableViewController: UITableViewController {
    var networkManager = appDelegate.serviceLocator.injectedNetworkManager
    var dataManager = appDelegate.serviceLocator.injectedDataManager
    
    var currentFetch: protocol<NetworkFetchOperation, FlickrFetchOperation>?
    
    var textInputByUser: String = "kittens"
    
    @IBOutlet var textInputField: UITextInput?
    
    
    @IBAction func userTappedTheSearchButton(sender: UIButton) {
        invalidateAnyInFlightRequests()
        resetUIToSearchingState()
        composeNewFetchFeedCall()
        currentFetch?.start()
    }
    
    func invalidateAnyInFlightRequests() {
        currentFetch?.cancel()
    }
    
    func composeNewFetchFeedCall() {
        currentFetch = StandardFlickrFetchFeedCall.fetchFeedCallFor(textInputByUser){self.handleFetchResponse($0, response: $1, error:$2)}
    }
    
    func handleFetchResponse (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void {
        updateUIToResultsFoundState()
    }
    
    
    
    
    func resetUIToSearchingState() {
        
    }
    
    func updateUIToResultsFoundState() {
        
    }
    
}