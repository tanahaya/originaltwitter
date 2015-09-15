//
//  TimelineViewController.swift
//  twitterClient
//
//  Created by 田中千洋 on 2015/09/05.
//  Copyright (c) 2015年 田中 颯. All rights reserved.
//

import UIKit
import TwitterKit

class TimelineViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate{
//    var tableView: UITableView!
    var tweets: [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var prototypeCell: TWTRTweetTableViewCell?
    var loadTweetButton:UIButton!
    var postTweetButton:UIButton!
    var addBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        addBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "postTweet")
        self.navigationItem.rightBarButtonItem = addBtn
        
        self.view.backgroundColor = UIColor.whiteColor()
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight:CGFloat = self.view.frame.height
        let statusBarHeight:CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: statusBarHeight + 50, width: displayWidth, height: displayHeight - statusBarHeight))
        //self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        loadTweetButton = UIButton()
        loadTweetButton.setTitle("更新する", forState: .Normal)
        loadTweetButton.frame = CGRectMake(0, 0, displayWidth / 2, 50)
        loadTweetButton.layer.position = CGPoint(x: self.view.frame.width/4, y: 45)
        loadTweetButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loadTweetButton.backgroundColor = UIColor.blueColor()
        loadTweetButton.layer.cornerRadius = 10
        loadTweetButton.addTarget(self, action: "loadTweets", forControlEvents:.TouchUpInside)
        //self.view.addSubview(loadTweetButton)
        
        postTweetButton = UIButton()
        postTweetButton.setTitle("ツイートする", forState: .Normal)
        postTweetButton.frame = CGRectMake(0, 0, displayWidth / 2, 50)
        postTweetButton.layer.position = CGPoint(x: self.view.frame.width/4 * 3, y: 45)
        postTweetButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        postTweetButton.backgroundColor = UIColor.blueColor()
        postTweetButton.layer.cornerRadius = 10
        postTweetButton.addTarget(self, action: "postTweet", forControlEvents:.TouchUpInside)
        //self.view.addSubview(postTweetButton)
        
        prototypeCell = TWTRTweetTableViewCell(style: .Default, reuseIdentifier: "cell")
        
        tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: "cell")
        
        loadTweets()
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("reloadTweets"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
    }
    func postTweet() {
        println("post")
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                var composer = TWTRComposer()
                composer.setText("投稿メッセージ")
                composer.showWithCompletion({ (result) -> Void in
                    println("投稿完了")
                })
            }
        }
    }
    func loadTweets() {
        TwitterAPI.getHomeTimeline({
            twttrs in
            for tweet in twttrs {
                self.tweets.append(tweet)
            }
            }, error: {
                error in
                println(error.localizedDescription)
        })
    }
    
    func reloadTweets() {
        self.tweets = []
        self.loadTweets()
        self.refreshControl?.endRefreshing()
    }
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of Tweets.
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TWTRTweetTableViewCell
        
        let tweet = tweets[indexPath.row] as TWTRTweet!
        cell.configureWithTweet(tweet)
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = tweets[indexPath.row]
        
        prototypeCell?.configureWithTweet(tweet)
        
        let height = TWTRTweetTableViewCell.heightForTweet(tweet, width: self.view.bounds.width)
        if  !height.isNaN {
            return height
            
        } else {
            return tableView.estimatedRowHeight
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("hoge")

    }
    func onClick() {
        let second = NotifyViewController()
        self.navigationController?.pushViewController(second, animated: true)
    }
}
