//
//  NewActivityViewController.swift
//  Life Logger
//
//  Created by Edward Huang on 8/12/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit
import os.log
import CoreData

class ActivityViewController: UIViewController, UITextFieldDelegate, ColorChooserDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by 'ActivityTableViewController' in 'prepare(for:sender:)'
     or constructed as part of adding a new meal.
     */
    var activity: Activity?
    var selectedColorIndex: Int16?

    @IBAction func cancel(_ sender: Any) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismessed in two different ways.
        let isPresentingAddActivityMode = presentingViewController != nil
        if isPresentingAddActivityMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The ActivityViewController is not inside a navigation controller.")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let activity = activity {
            navigationItem.title = activity.name
            nameTextField.text = activity.name
            
            let colorIndex = activity.color
            colorView.backgroundColor = ActivityColor.getColor(index: colorIndex)
        } else {
            colorView.backgroundColor = ActivityColor.getColor(index: 0)
        }
        
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        updateSaveButtonState()
        navigationItem.title = textField.text
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    
    // MARK: ColorChooserDelegate
    func userChoseColor(colorIndex: Int) {
        selectedColorIndex = Int16(colorIndex)
        colorView.backgroundColor = ActivityColor.getColor(index: colorIndex)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        if let button = sender as? UIBarButtonItem, button === saveButton {
            let name = nameTextField.text ?? ""
            
            // Set the activity to be passed to ActivityTableViewController after the unwind seque.
            
            if activity == nil {
                activity = (NSEntityDescription.insertNewObject(forEntityName: DatabaseController.activityClassName, into: DatabaseController.getContext()) as! Activity)
            }
            
            activity?.name = name
            if let selectedColorIndex = selectedColorIndex{
                activity?.color = selectedColorIndex
            }
        } else {
            guard sender is UITapGestureRecognizer else {
                fatalError("Unknown sender")
            }
            
            guard let navController = segue.destination as? UINavigationController else {
                fatalError("Expected navigation controller, but got a different view controller")
            }
            
            guard let colorController = navController.viewControllers.first as? ColorChooserTableViewController else {
                fatalError("Expected color chooser table controller, but got a different view controller")
            }
            
            colorController.delegate = self
        }
        
    }
 
    
    // MARK: Private Methods
    
    private func updateSaveButtonState() {
        //Disable the Save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}
