//
//  TwitterAPI.swift
//  twitterClient
//
//  Created by 田中千洋 on 2015/09/05.
//  Copyright (c) 2015年 田中 颯. All rights reserved.
//

import Foundation
import TwitterKit

class TwitterAPI {
    let baseURL = "https://api.twitter.com"
    let version = "/1.1"
    
    init() {
        
    }
    
    class func getHomeTimeline(tweets: [TWTRTweet]->(), error: (NSError) -> ()) {
        let api = TwitterAPI()
        var clientError: NSError?
        let path = "/statuses/home_timeline.json"
        let params = Dictionary<NSObject, AnyObject>()
        let endpoint = api.baseURL + api.version + path
         let request: NSURLRequest! = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: endpoint, parameters: params, error: &clientError)
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: {
                response, data, err in
                if err == nil {
                    var jsonError: NSError?
                     let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)
                    if let jsonArray = json as? NSArray {
                        tweets(TWTRTweet.tweetsWithJSONArray(jsonArray as! [AnyObject]) as! [TWTRTweet])
                    }
                } else {
                    error(err!)
                }
            })
        }
    }
}
