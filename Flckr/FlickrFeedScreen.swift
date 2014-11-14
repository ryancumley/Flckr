//
//  FlickrFeedScreen.swift
//  Flckr
//
//  Created by Ryan Cumley on 11/13/14.
//  Copyright (c) 2014 iTriage. All rights reserved.
//

import Foundation
import UIKit


class FlickrFeedTableViewController: UITableViewController, UITextFieldDelegate {

    //MARK: Search Input and Execution Handling
    func displayQueryStatusInSectionHeader(#status: String) {
        (tableView.dataSource as FlickrFeedTableViewDataSource).useThisQueryStatus(status: status)
        reloadTableDataOnMainThread()
    }
    
    func resetUIToSearchingState(searchQuery query: String) {
        let searchingIndicator = "Hang tight, we're searching Flickr for \(query)"
        displayQueryStatusInSectionHeader(status: searchingIndicator)
    }
    
    func updateUIToResultsFoundState() {
        (tableView.dataSource as FlickrFeedTableViewDataSource).useThisQueryStatus(status: "")
        reloadTableDataOnMainThread()
    }
    
    func reloadTableDataOnMainThread() {
        dispatch_async(dispatch_get_main_queue(), {self.tableView.reloadData()})
    }
    
    
    
    
    //MARK: TextField Handling
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let newQuery = textField.text? {
            resetUIToSearchingState(searchQuery: newQuery)
            (tableView.dataSource as FlickrFeedTableViewDataSource).makeNewOutboundRequest(queryString: newQuery)
        }
    }
}
//MARK:-



class FlickrFeedTableViewDataSource: NSObject, UITableViewDataSource {
    var networkManager = appDelegate.serviceLocator.injectedNetworkManager
    var dataManager = appDelegate.serviceLocator.injectedDataManager
    var feedItemsForDisplay = [FlickrFeedItem]()
    var queryStatusString = ""
    
    @IBOutlet var owningTableViewController: FlickrFeedTableViewController?
    
    var currentFetch: protocol<NetworkFetchOperation, FlickrFetchOperation>?
    
    


    //MARK: Protocol methods
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return queryStatusString
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItemsForDisplay.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FlickrFeedItemCell") as UITableViewCell
        cell.textLabel.text = feedItemsForDisplay[indexPath.row].title
        cell.detailTextLabel?.text = feedItemsForDisplay[indexPath.row].link
        
        return cell
    }
    
    
    
    //MARK: Making and Handling requests
    func makeNewOutboundRequest(queryString query: String) {
        invalidateAnyInFlightRequests()
        composeNewFetchFeedCall(queryString: query)
        currentFetch?.start()
    }
    
    func invalidateAnyInFlightRequests() {
        currentFetch?.cancel()
    }
    
    func composeNewFetchFeedCall(queryString query: String) {
        currentFetch = StandardFlickrFetchFeedCall.fetchFeedCallFor(query){self.handleFetchResponse($0, response: $1, error:$2)}
    }
    
    func handleFetchResponse (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void {
        dataManager.processPotentialFeedItemCandidates(rawDataResponse: data, completionHandler: {self.refreshDataSource()})
    }
    
    func refreshDataSource() {
        feedItemsForDisplay = dataManager.currentlyImportedFeedItems
        owningTableViewController?.updateUIToResultsFoundState()
    }
    
    func useThisQueryStatus(#status: String) {
        queryStatusString = status
    }
}








