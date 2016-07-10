//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Sam on 5/30/16.
//  Copyright © 2016 Sam. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {

    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        if let saved_meals = loadMeals() {
            meals += saved_meals
        }else {
            loadSampleMeals()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MealTableViewCell", forIndexPath: indexPath) as! MealTableViewCell
        
        let meal = meals[indexPath.row]
        cell.name_label.text = meal.name
        cell.photo_image_view.image = meal.photo!
        cell.rating_control.rating = meal.rating
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            meals.removeAtIndex(indexPath.row)
            saveMeals()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }else if editingStyle == .Insert {
            //
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            print("Adding new meal")
        }else if segue.identifier == "ShowDetail" {
            let meal_detail_controller = segue.destinationViewController as! MealViewController
            
            if let selected_cell = sender as? MealTableViewCell {
                let index_path = tableView.indexPathForCell(selected_cell)!
                meal_detail_controller.meal = meals[index_path.row]
            }
        }
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
    
        if let source_view_controller = sender.sourceViewController as? MealViewController, meal = source_view_controller.meal {
            if let selected_path_index = tableView.indexPathForSelectedRow {
                meals[selected_path_index.row] = meal
                tableView.reloadRowsAtIndexPaths([selected_path_index], withRowAnimation: .None)
            }else {
                let new_index_path = NSIndexPath(forRow: meals.count, inSection: 0)
                meals.append(meal)
                
                tableView.insertRowsAtIndexPaths([new_index_path], withRowAnimation: .Bottom)
            }
            
            saveMeals()
            
        }else {
            print("Something bad happened")
        }
    }
    
    func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "meal2")
        let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
        
        let photo3 = UIImage(named: "meal3")
        let meal3 = Meal(name: "Pasta With Meatballs", photo: photo3, rating: 3)!
        
        meals += [meal1, meal2, meal3]
    }
    
    func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.Archive_URL.path!) as? [Meal]
    }
    
    func saveMeals() {
        let is_successful_save = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.Archive_URL.path!)
        
        if !is_successful_save {
            print("Failed to save meals...")
        }
    }
    
}
