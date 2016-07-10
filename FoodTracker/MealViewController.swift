//
//  ViewController.swift
//  FoodTracker
//
//  Created by Sam on 5/29/16.
//  Copyright © 2016 Sam. All rights reserved.
//

import UIKit

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var name_text_field: UITextField!
    @IBOutlet weak var photo_image_view: UIImageView!
    @IBOutlet weak var ratings_control: RatingControl!
    @IBOutlet weak var save_button: UIBarButtonItem!
    @IBOutlet weak var cancel_button: UIBarButtonItem!
    
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        name_text_field.delegate = self
        
        if let meal = meal {
            navigationItem.title = meal.name
            name_text_field.text = meal.name
            photo_image_view.image = meal.photo
            ratings_control.rating = meal.rating
        }
        
        checkValidMealName()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.selectImageFromPhotoLibrary))
        photo_image_view.addGestureRecognizer(tap)
        photo_image_view.userInteractionEnabled = true
        
        //loadImageIfExists()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === save_button {
            let name = name_text_field.text ?? ""
            let photo = photo_image_view.image
            let ratings = ratings_control.rating
            
            meal = Meal(name: name, photo: photo, rating: ratings)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        save_button.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
        navigationItem.title = name_text_field.text
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Image picker was cancelled")
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selected_image = info[UIImagePickerControllerOriginalImage] as! UIImage
        photo_image_view.image = selected_image
        
        let file_name = "default_image.png"
        
        //save the image
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        if paths.count > 0 {
            let img_location = paths[0] + "/\(file_name)"
            print(img_location)
            
            if let data = UIImagePNGRepresentation(selected_image) {
                NSFileManager.defaultManager().createFileAtPath(img_location, contents: data, attributes: nil)
                //data.writeToFile(img_location, atomically: true)
                
                NSUserDefaults.standardUserDefaults().setObject(file_name, forKey: "img_location")
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        let is_presenting_in_add_meal_mode = presentingViewController is UINavigationController
        
        if is_presenting_in_add_meal_mode {
            dismissViewControllerAnimated(true, completion: nil)
        }else {
            navigationController!.popViewControllerAnimated(true)
        }
    }

    func checkValidMealName() {
        let text = name_text_field.text ?? ""
        save_button.enabled = !text.isEmpty
    }
    
    
    func loadImageIfExists() {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        if var img_location = NSUserDefaults.standardUserDefaults().valueForKey("img_location") as? String {
            img_location = paths[0] + "/\(img_location)"
            
            if NSFileManager.defaultManager().fileExistsAtPath(img_location) {
                photo_image_view.image = UIImage(named: img_location)
            }else {
                print("File does not exist")
            }
        }
    }
    
    func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        name_text_field.resignFirstResponder()
        
        let image_picker_controller = UIImagePickerController()
        image_picker_controller.sourceType = .PhotoLibrary
        image_picker_controller.delegate = self
        
        presentViewController(image_picker_controller, animated: true, completion: nil)
    }
}

