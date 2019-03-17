//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Yaniv Bronshtein on 3/8/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var tweetArray = [NSDictionary]() //array of dictionaries to store tweets
    var numberOfTweets: Int!
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.loadTweetTable()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweetTable), for: .valueChanged)
        
        tableView.refreshControl = myRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweetTable()
    }
    
    //This method extracts tweets from API call, stores them in an array of dictionaries
    @objc func loadTweetTable() {
        numberOfTweets = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParameters = ["count": numberOfTweets] //load 20 tweets
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParameters, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll() //empty the entire array
            for tweet in tweets {
                self.tweetArray.append(tweet) //add tweet to the tweet array of dictionaries
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not retreive any tweets")
        })
        print(tweetArray)
    }
    
    func loadMoreTweets() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets += 20
        let myParameters = ["count" : numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParameters, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll() //empty the entire array
            for tweet in tweets {
                self.tweetArray.append(tweet) //add tweet to the tweet array of dictionaries
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not retreive any tweets")
        })
        print(tweetArray)
        
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil) //screen. For completion write nil.Don't want to do anything after dismisses itself
        
        UserDefaults.standard.set(false, forKey: "userLoggedIn") //Checks to see if user already logged in
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try?Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
            
        }
        return cell
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // Display the number of rows in tweet array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    
}
