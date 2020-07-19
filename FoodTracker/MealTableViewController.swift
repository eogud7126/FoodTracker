//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by USER on 14/07/2020.
//  Copyright © 2020 USER. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    //MARK: Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.source as? MealViewController ,
            let meal = sourceViewController.meal{
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                //목록 업데이트
                self.appDelegate.meallist[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                let newIndexPath = IndexPath(row: self.appDelegate.meallist.count, section: 0)
                appDelegate.meallist.append(meal)
                print(appDelegate.meallist)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    
    
    
    //MARK: Private Methods

    private func loadSampleMeals(){
        
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)else{
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5)else{
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3)else{
            fatalError("Unable to instantiate meal3")
        }
        
        self.appDelegate.meallist += [meal1,meal2,meal3]
        
    }
    
    //MARK: override
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleMeals()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
      //  print(self.appDelegate.meallist)
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.appDelegate.meallist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meals = self.appDelegate.meallist[indexPath.row]

        //테이블 뷰 셀은 재사용되기 위해 셀 id를 사용해야한다.
        let cellIdentifier = "MealTableViewCell"
        
        //커스텀 셀을 작성했으므로 셀 유형을 커스텀 셀 서브 클래스로 다운캐스트 해야한다.!!!!!!
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else{
            fatalError("The dequeued cell is not an instance of MealTableViewCell")
        }
        
        //적절한 meal을 레이아웃에 배치한다. meals 배열에서 가져옴.
        cell.nameLabel?.text = meals.name
        cell.photoImageView?.image = meals.photo
        cell.ratingControl?.rating = meals.rating

        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //데이터 소스에서 행을 삭제
            self.appDelegate.meallist.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }else if editingStyle == .insert {
            //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //false를 리턴하면 edit을 못하도록 한다.
        return true
    }
    
    
    //MARK: Navigation
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        
//        switch(segue.identifier ?? ""){
//        case "AddItem":
//            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
//        case "ShowDetail":
//            guard let mealDetailViewController = segue.destination as? MealViewController else{
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//            guard let selectedMealCell = sender as? MealTableViewCell else{
//                fatalError("Unexpected sender: \(sender)")
//            }
//            guard let indexPath = tableView.indexPath(for: selectedMealCell) else{
//                fatalError("The selected cell is not being displayed by the table")
//            }
//            let selectedMeal = self.appDelegate.meallist[indexPath.row]
//            mealDetailViewController.meal = selectedMeal
//        default:
//            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
//        }
//        
//    }

}
