//
//  RestaurantListViewController.swift
//  yelp
//
//  Created by Scott Woody on 9/19/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

class RestaurantListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var restaurantTableView: UITableView!
    var client: YelpClient!
    
    let yelpConsumerKey = "3hOexDEZj6cbY4aJnHxhlA"
    let yelpConsumerSecret = "FJAVv46vvFQGXs_AlVR9wmX7eB8"
    let yelpTokenKey = "ve4TxTHx2pwSD_oXETc8wpXSeUb_Pqlt"
    let yelpTokenSecret = "AgblhIIQ7zQR_Uk1uwnNela9alg"

    override func viewDidLoad() {
        super.viewDidLoad()
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpTokenKey, accessSecret: yelpTokenSecret)
        
        client.searchWithTerm("Thai", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println(response)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = restaurantTableView.dequeueReusableCellWithIdentifier("com.codepath.yelp.restaurantCell") as RestaurantTableViewCell
        cell.restaurantImageView.image = UIImage(named: "turkey.jpg")
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
