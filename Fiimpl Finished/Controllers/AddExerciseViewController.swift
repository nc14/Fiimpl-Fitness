//
//  AddExerciseViewController.swift
//  Fiimpl Finished
//
//  Created by Cockerill, Nicholas on 13/06/2018.
//  Copyright © 2018 Fiimpl Fitness. All rights reserved.
//

import UIKit
import RealmSwift

class AddExerciseViewController: UIViewController, UITextFieldDelegate {

    //MARK: Outlets
    
    @IBOutlet weak var exerciseName: UITextField!
    
    @IBOutlet weak var minimumReps: UITextField!
    
    @IBOutlet weak var maximumReps: UITextField!
    
    @IBOutlet weak var exerciseType: UISegmentedControl!
    
    @IBOutlet weak var addExerciseButtonOutlet: UIButton!
    
    @IBOutlet weak var addExerciseInfoLabel: UILabel!
    
    

    //MARK: Delegates
    
    // Add delegates to allow input validation methods to work
    override func viewDidLoad() {
        exerciseName.delegate = self
        minimumReps.delegate = self
        maximumReps.delegate = self
        addExerciseButtonOutlet.isEnabled = false
        addExerciseInfoLabel.isHidden = true
        
        
    super.viewDidLoad()

    }
    
    //MARK: Button actions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        saveExercise()
        exerciseName.text = ""
        minimumReps.text = ""
        maximumReps.text = ""
    }
    
    //MARK: Functions
    
    // Save function
    
    func saveExercise() {
        let newExercise = ExerciseGeneratorObject()
        newExercise.name = exerciseName.text!
        newExercise.minReps = Int(minimumReps.text!)!
        newExercise.maxReps = Int(maximumReps.text!)!
        newExercise.type = exerciseType.titleForSegment(at: exerciseType.selectedSegmentIndex)!
        
        do {
            addExerciseInfoLabel.isHidden = false
            addExerciseInfoLabel.text = ("Exercise saved!")
           
            try realm.write {
                realm.add(newExercise)
            }
        } catch {
            //add UI Alert Controller here to present error
            print ("error adding exercise to bank")
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    //MARK: Form validation
    
    //only allow numbers in reps fields
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == minimumReps || textField == maximumReps {
            
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
            

        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
        }
        return true
    }
    
    //clear 'notification label' when text field starts editing for adding multiple
    func textFieldDidBeginEditing(_ textField: UITextField) {

        addExerciseInfoLabel.text = ("")
        
    }
    
    //disable button if not all fields completed when finished editing
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if minimumReps.text?.isEmpty == false && maximumReps.text?.isEmpty == false && exerciseName.text?.isEmpty == false {
            addExerciseButtonOutlet.isEnabled = true
        } else {
            addExerciseButtonOutlet.isEnabled = false
        }
    }
    
    //move between text fields when hitting return and check for field completion when hitting enter
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == exerciseName {
            self.minimumReps.becomeFirstResponder()
        }
        else if textField == minimumReps {
            self.maximumReps.becomeFirstResponder()
        }
        else if textField == maximumReps {
            self.view.endEditing(true)
        }
        
        if minimumReps.text?.isEmpty == false && maximumReps.text?.isEmpty == false && exerciseName.text?.isEmpty == false {
            addExerciseButtonOutlet.isEnabled = true
        } else {
            addExerciseButtonOutlet.isEnabled = false
        }
        return true
    }

}
