//
//  FiltersViewController.swift
//  yelp
//
//  Created by Scott Woody on 9/21/14.
//  Copyright (c) 2014 Scott Woody. All rights reserved.
//

import UIKit

protocol categoriesDelegate {
    func updateData(category: String, dealsValue: Bool, distanceIdx: Int, sort: Int)
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categoriesButton: UIButton?
    
    var dealsValue: Bool = false
    var delegate: categoriesDelegate?
    var distanceIdx: Int! = 0
    
    let distanceDict: [Int: String] = [0: "Walking", 1: "Biking", 2: "Horseback"]
    
    // Used to determine if the distance dropdown should be open, dictates behavior of menu
    var distanceOpen = false
    
    var categoryString: String!
    var sortValue: Int! = 1
    
    var categories: Array<String>!
    var categoriesExpanded: Bool = false
    let initialCategories: Array<String> = ["Chinese", "Japanese", "Thai"]
    let extraCategories: Array<String> = ["American", "French", "German", "Italian", "Mexican"]
    
    var categoryVals = Dictionary<String, Bool>()

    @IBOutlet weak var categoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesTableView.contentInset = UIEdgeInsetsMake(-80.0, 0.0, 0.0, 0.0)
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

    @IBAction func toggleDeals(sender: AnyObject) {
        dealsValue = !dealsValue
        sendDataToListView()
    }
    
    func sendDataToListView(){
        delegate?.updateData(categoryString, dealsValue: dealsValue, distanceIdx: distanceIdx, sort: sortValue)
    }
    
    
    @IBAction func revealCategories(sender: AnyObject) {
        categories! += extraCategories
        categoriesExpanded = true
        categoriesTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changeSortParam(sender: AnyObject) {
        let segmentedControl = sender as UISegmentedControl
        sortValue = segmentedControl.selectedSegmentIndex
        sendDataToListView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Only do something if it's in section 2 (the distance section)
        if indexPath.section == 2 {
            if distanceOpen == true{
                // We should update the selected distance and send the data to the other view
                distanceIdx = indexPath.row
                sendDataToListView()
            }
            distanceOpen = !distanceOpen
            categoriesTableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = categoriesTableView.dequeueReusableCellWithIdentifier("com.codepath.yelp.categoryTableViewCell") as categoryTableViewCell
            let categoryName = categories[indexPath.row]
            cell.titleLabel.text = categoryName
            
            if let val = categoryVals[categoryName]{
                cell.valueSwitch.on = val
            } else {
                cell.valueSwitch.on = false
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else if indexPath.section == 1 {
            let cell = categoriesTableView.dequeueReusableCellWithIdentifier("com.codepath.yelp.sortTableViewCell") as sortTableViewCell
            cell.sortSegmentedControl.selectedSegmentIndex = sortValue
            return cell
        } else if indexPath.section == 2 {
            // Distance cells
            let cell = categoriesTableView.dequeueReusableCellWithIdentifier("com.codepath.yelp.distanceTableViewCell") as distanceTableViewCell
            // If we're open then we're going to replace the image with an open circle and update labels
            if distanceOpen == true {
                cell.distanceLabel.text = distanceDict[indexPath.row]
                cell.selectStateImageView.image = UIImage(named: "iconmonstr-circle-outline-icon-16.png")
            } else {
                cell.distanceLabel.text = distanceDict[distanceIdx]
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.selectStateImageView.image = UIImage(named: "iconmonstr-sort-10-icon-16.png")
            }
            return cell
        } else if indexPath.section == 3 {
            let cell = categoriesTableView.dequeueReusableCellWithIdentifier("com.codepath.yelp.dealsTableViewCell") as dealsTableViewCell
            cell.dealsSwitch.on = dealsValue
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return categories.count
        } else if section == 2 {
            if distanceOpen == true {
                return distanceDict.count
            }
            return 1
        }
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Restaurant Types"
        } else if section == 1 {
            return "Sort Criteria"
        } else if section == 2 {
            return "Distance"
        } else {
            return "Deal or No Deal?"
        }
    }
        
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 50
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if categoriesExpanded == false {
            if section == 0 {
                let view = UIView(frame: CGRect(x: 0,y: 0,width: categoriesTableView.bounds.width, height: 50))
                view.backgroundColor = UIColor.whiteColor()
                var button = UIButton()
                button.addTarget(self, action: "revealCategories:", forControlEvents: UIControlEvents.TouchUpInside)
                button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
                button.setTitle("More Categories", forState: UIControlState.Normal)
                button.frame = CGRect(x:0,y:0,width:320,height:50)
                view.addSubview(button)
                return view
            }
        }
        return nil
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
