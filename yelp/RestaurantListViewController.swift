//
//  RestaurantListViewController.swift
//  yelp
//
//  Created by Scott Woody on 9/19/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import CoreLocation
import UIKit

class RestaurantListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var restaurantTableView: UITableView!

    var client: YelpClient!
    var restaurantsArray: NSArray!
    var locationManager: CLLocationManager!
    var searchTimer: NSTimer!
    
    // Search parameters
    var category: String = ""
    var dealsValue: Bool = false
    var distanceIdx: Int = 1
    var searchString: String = "thai"
    var sort: Int! = 2
    
    let distanceDict: [Int: Int] = [0: 1600, 1: 8000, 2: 32000]
    
    // Hardcode Lat/Lon since simulator makes it hard to get location
    var latitude = 37.78735890
    var longitude = -122.40822700
    
    let yelpConsumerKey = "3hOexDEZj6cbY4aJnHxhlA"
    let yelpConsumerSecret = "FJAVv46vvFQGXs_AlVR9wmX7eB8"
    let yelpTokenKey = "HJ9umyutZ8_rywIz0wTG_RdlnJ3Fkzsw"
    let yelpTokenSecret = "A6HFdk1hdQsVU6dCWbKPjx6afbc"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable auto resizing of row
        restaurantTableView.estimatedRowHeight = 100
        restaurantTableView.rowHeight = UITableViewAutomaticDimension
        
        // Turn on location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpTokenKey, accessSecret: yelpTokenSecret)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(){
        let radius = distanceDict[distanceIdx]! as Int
        client.searchWithTerm(category, deals_filter: dealsValue, radius: radius, sortParam: sort, term: searchString, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let responseDictionary = response as NSDictionary?
            self.restaurantsArray = (responseDictionary!["businesses"] ?? []) as NSArray
            
            self.restaurantTableView.reloadData()
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if restaurantsArray != nil {
            return restaurantsArray.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = restaurantTableView.dequeueReusableCellWithIdentifier("com.codepath.yelp.restaurantCell") as RestaurantTableViewCell
        let restaurantDictionary = restaurantsArray![indexPath.row] as NSDictionary

        cell.titleUILabel.text = restaurantDictionary["name"] as String
        
        let snippet = restaurantDictionary["snippet_text"] as String
        
        cell.reviewUILabel.text = snippet.stringByReplacingOccurrencesOfString("\n", withString: " ", options: nil, range: nil)

//        Load in the large image
        let snippet_image_url_string = restaurantDictionary["image_url"] as String?
        let large_image_url_string = snippet_image_url_string?.stringByReplacingOccurrencesOfString("/ms.", withString: "/l.")
        if large_image_url_string != nil {
            let snippet_image_url = NSURL.URLWithString(large_image_url_string!)
            cell.restaurantImageView.setImageWithURL(snippet_image_url)
        } else {
            cell.restaurantImageView.image = UIImage(named: "turkey.jpg")
        }
        
        let rating_image_string = restaurantDictionary["rating_img_url_small"] as String?
        
        if rating_image_string != nil {
            let rating_url = NSURL.URLWithString(rating_image_string!)
            cell.ratingImageView.setImageWithURL(rating_url)
        }
        
        var distance = " "
        if let location = restaurantDictionary["location"] as NSDictionary?{
            if let coordinate = location["coordinate"] as NSDictionary?{
                let loc1 = CLLocation(latitude: latitude, longitude: longitude)
                let loc2 = CLLocation(latitude: coordinate["latitude"] as Double, longitude: coordinate["longitude"] as Double)
                let miles = loc1.distanceFromLocation(loc2) * 0.000621371
                let distanceString = NSString(format: "%.1f", miles)
                distance = "\(distanceString) miles"
            }
        }
        cell.distanceUILabel.text = distance

        return cell
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println(locations)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchTimer != nil{
            searchTimer.invalidate()
        }
        // Only search if the string length is > 3 characters
        if countElements(searchText) > 3{
            searchString = searchText
            search()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as FiltersViewController
        vc.delegate = self
        vc.categoryString = self.category
        vc.dealsValue = self.dealsValue
        vc.distanceIdx = self.distanceIdx
        vc.sortValue = self.sort
    }
    
    override func viewWillAppear(animated: Bool) {
        self.search()
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

extension RestaurantListViewController: categoriesDelegate{
    func updateData(category: String, dealsValue: Bool, distanceIdx: Int, sort: Int){
        self.category = category
        self.dealsValue = dealsValue
        self.distanceIdx = distanceIdx
        self.sort = sort
    }
}
