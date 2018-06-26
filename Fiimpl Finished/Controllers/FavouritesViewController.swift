//
//  FavouritesViewController.swift
//  Fiimpl Finished
//
//  Created by Cockerill, Nicholas on 15/06/2018.
//  Copyright © 2018 Fiimpl Fitness. All rights reserved.
//

import UIKit
import RealmSwift

class FavouriteWorkoutNameCell: UITableViewCell {
    
    var delegate: FavouriteWorkoutNameCellDelegate?
   
    @IBOutlet weak var favouriteNameLabel: UILabel!

    @IBAction func goButtonTapped(_ sender: Any) {
        delegate?.goButtonTapped(cell: self)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.deleteButtonTapped(cell: self)
    }
    
}

protocol FavouriteWorkoutNameCellDelegate {
        func deleteButtonTapped(cell: FavouriteWorkoutNameCell)
        func goButtonTapped(cell: FavouriteWorkoutNameCell)
    }


class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavouriteWorkoutNameCellDelegate {
    
    
    var favouriteWorkouts = realm.objects(FavouriteObject.self)
    var workoutToPass = WorkoutSessionObject()
    var favouriteObjectToPass = FavouriteObject()
    @IBOutlet weak var favouritesTableOutlet: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteNameCell", for: indexPath) as! FavouriteWorkoutNameCell
        
        cell.delegate = self
        
        cell.favouriteNameLabel.text = favouriteWorkouts[indexPath.row].favouriteWorkoutName
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            // What to do when a cell is pressed
            let myIndexPath = tableView.indexPathForSelectedRow

            let favouriteObjectToGo = realm.objects(FavouriteObject.self)[(myIndexPath?.row)!]
            let favouriteWorkoutID = favouriteObjectToGo.workoutReference?.workoutID
            let favouriteWorkoutToPass = realm.object(ofType: WorkoutSessionObject.self, forPrimaryKey: favouriteWorkoutID)

            workoutToPass = favouriteWorkoutToPass!
            favouriteObjectToPass = favouriteObjectToGo

        performSegue(withIdentifier: "goToFavouriteExerciseDetail", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? FavouriteDetailViewController  {
            
            destVC.favouriteWorkoutPassed = workoutToPass
            destVC.favouriteObjectPassed = favouriteObjectToPass
        } else {
            if let destVC = segue.destination as? FavouriteExerciseDetailViewController {
                destVC.favouriteWorkoutPassed = workoutToPass
                destVC.favouriteObjectPassed = favouriteObjectToPass
            }
    }
    }
    
    func deleteButtonTapped(cell: FavouriteWorkoutNameCell) {
        if let myIndexPath = favouritesTableOutlet.indexPath(for: cell)
        {
            let favouriteToRemove = realm.objects(FavouriteObject.self)[myIndexPath.row]
            let workoutObjectToUpdate = realm.object(ofType: WorkoutSessionObject.self, forPrimaryKey: favouriteToRemove.workoutID)
            do { try realm.write {
                realm.delete(favouriteToRemove)
                workoutObjectToUpdate?.favourite = false
                self.favouritesTableOutlet.reloadData()
                }
            } catch {
                print ("Error removing from favourites")
            }
        }
    }
    
    func goButtonTapped(cell: FavouriteWorkoutNameCell) {
        
        if let myIndexPath = favouritesTableOutlet.indexPath(for: cell) {
            
            let favouriteObjectToGo = realm.objects(FavouriteObject.self)[(myIndexPath.row)]
            let favouriteWorkoutID = favouriteObjectToGo.workoutReference?.workoutID
            let favouriteWorkoutToPass = realm.object(ofType: WorkoutSessionObject.self, forPrimaryKey: favouriteWorkoutID)
            
            workoutToPass = favouriteWorkoutToPass!
            favouriteObjectToPass = favouriteObjectToGo
            
        }
        
        performSegue(withIdentifier: "goToSetupFavourite", sender: self)
    }

}
