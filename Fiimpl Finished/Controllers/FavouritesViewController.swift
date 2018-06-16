//
//  FavouritesViewController.swift
//  Fiimpl Finished
//
//  Created by Cockerill, Nicholas on 15/06/2018.
//  Copyright © 2018 Fiimpl Fitness. All rights reserved.
//

import UIKit

class FavouriteWorkoutNameCell: UITableViewCell {
    
    @IBOutlet weak var favouriteNameLabel: UILabel!

}

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var favouriteWorkouts = realm.objects(FavouriteObject.self)
    var workoutToPass = WorkoutSessionObject()
    var favouriteObjectToPass = FavouriteObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteNameCell", for: indexPath) as! FavouriteWorkoutNameCell
        
        cell.favouriteNameLabel.text = favouriteWorkouts[indexPath.row].favouriteWorkoutName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            // What to do when a cell is pressed
            let indexPath = tableView.indexPathForSelectedRow
            let currentCell = tableView.cellForRow(at: indexPath!) as! FavouriteWorkoutNameCell
            let workoutName = currentCell.favouriteNameLabel.text

        let favouriteWorkoutObject = realm.objects(FavouriteObject.self).filter("favouriteWorkoutName == %@", workoutName ?? "no name here").first
        
            let favouriteWorkoutID = favouriteWorkoutObject?.workoutID
        
            workoutToPass = realm.object(ofType: WorkoutSessionObject.self, forPrimaryKey: favouriteWorkoutID)!
            favouriteObjectToPass = favouriteWorkoutObject!
                
            performSegue(withIdentifier: "goToSetupFavourite", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? FavouriteDetailViewController {
            
            destVC.favouriteWorkoutPassed = workoutToPass
            destVC.favouriteObjectPassed = favouriteObjectToPass
        }
    }

}
