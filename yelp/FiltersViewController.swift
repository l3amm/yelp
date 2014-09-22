//
//  FiltersViewController.swift
//  yelp
//
//  Created by Scott Woody on 9/21/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

protocol categoriesDelegate {
    func updateData(category: String)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate: categoriesDelegate?
    
    var categoryString: String!
    
    var categories: Array<String>!
    let initialCategories: Array<String> = ["Chinese", "Japanese", "Thai"]
    let extraCategories: Array<String> = ["American", "French", "German", "Italian", "Mexican"]
    
    var categoryVals = Dictionary<String, Bool>()

    @IBOutlet weak var moreCategoriesButton: UIButton!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesTableView.contentInset = UIEdgeInsetsMake(-80.0, 0.0, 0.0, 0.0)
        println(categoriesTableView.contentSize.height)
        populateCategoryVals()
        // reset the category list
        resetCategories()
        self.view.backgroundColor = UIColor.whiteColor()
        categoriesTableView.estimatedRowHeight = 30
        categoriesTableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }
    
    func populateCategoryVals(){
        // converts the string of categories in 
        // categoryString into a dictionary
        if countElements(categoryString) > 0{
            let categories = categoryString.componentsSeparatedByString(",")
            for category in categories{
                categoryVals[category.capitalizedString] = true
            }
        }
    }
    
    func resetCategories(){
        moreCategoriesButton.hidden = false
        categories = initialCategories
    }

    @IBAction func toggleCategory(sender: AnyObject) {
        let toggle = sender as UISwitch
        let cell = toggle.superview!.superview! as categoryTableViewCell
        let idx = categoriesTableView!.indexPathForCell(cell)!.row
        // Update the dicationary with the new value
        categoryVals[categories[idx]] = toggle.on
        var activeCats: [String] = []
        for (cat, val) in categoryVals{
            if val == true{
                activeCats.append(cat.lowercaseString)
            }
        }
        categoryString = ",".join(activeCats)
        sendDataToListView()
    }
    
    func sendDataToListView(){
        delegate?.updateData(categoryString)
    }
    
    
    @IBAction func revealCategories(sender: AnyObject) {
        categories! += extraCategories
        moreCategoriesButton.hidden = true
        categoriesTableView.reloadData()
        var frame = categoriesTableView.frame
        frame.size.height = categoriesTableView.contentSize.height
        categoriesTableView.frame = frame
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = categoriesTableView.dequeueReusableCellWithIdentifier("com.codepath.yelp.categoryTableViewCell") as categoryTableViewCell
        let categoryName = categories[indexPath.row]
        cell.titleLabel.text = categoryName
        
        if let val = categoryVals[categoryName]{
            cell.valueSwitch.on = val
        } else {
            cell.valueSwitch.on = false
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
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
