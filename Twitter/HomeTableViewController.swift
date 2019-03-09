//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Yaniv Bronshtein on 3/8/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        
        
    }
    
    func loadTweet() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        let myParams = ["count": 10]
        
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray.removeAll() //empty the entire array
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Could not retreive any tweets")
        })
    }
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil) //screen. For completion write nil.Don't want to do anything after dismisses itself
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn") //Checks to see if user already logged in
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        _ = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = tweetArray[indexPath.row]["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        return cell
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tweetArray.count
        return 5
    }
    
    
}
