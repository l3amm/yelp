//
//  YelpClient.swift
//  yelp
//
//  Created by Scott Woody on 9/19/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret);
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    func searchWithTerm(category: String, deals_filter: Bool, radius: Int, sortParam: Int, term: String, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        var category_filter = "restaurants" + category
        var parameters = ["category_filter": category, "deals_filter": deals_filter, "radius_filter": radius, "sort": sortParam, "term": term, "location": "San Francisco"]
        println(parameters)
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
}