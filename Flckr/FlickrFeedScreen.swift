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
    
    var textInputByUser: String?
    
    @IBOutlet var textInputField: UITextInput?
    
    
    @IBAction func userTappedTheSearchButton(sender: UIButton) {
       let theCall = StandardFlickrFetchFeedCall()
        
        
    }
    
}