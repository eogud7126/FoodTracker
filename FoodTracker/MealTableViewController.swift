//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by USER on 14/07/2020.
//  Copyright © 2020 USER. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {
    //MARK: Properties
    
    var meals = [Meal]()
    
    //MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? MealViewController ,
            let meal = sourceViewController.meal{
            
            let newIndexPath = IndexPath(row: meals.count, section: 0)
            meals.append(meal)
            
            tableView.insertRows(at: [newIndexPath], with: .automatic)
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
        
        meals += [meal1,meal2,meal3]
    }
    
    //MARK: override

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load the Sample data
        loadSampleMeals()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //테이블 뷰 셀은 재사용되기 위해 셀 id를 사용해야한다.
        let cellIdentifier = "MealTableViewCell"
        
        //커스텀 셀을 작성했으므로 셀 유형을 커스텀 셀 서브 클래스로 다운캐스트 해야한다.!!!!!!
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else{
            fatalError("The dequeued cell is not an instance of MealTableViewCell")
        }
    
        //적절한 meal을 레이아웃에 배치한다. meals 배열에서 가져옴.
        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    
}
