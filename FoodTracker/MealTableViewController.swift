//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by USER on 14/07/2020.
//  Copyright © 2020 USER. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController, UISearchBarDelegate {
    //MARK: Properties
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var dao = MealDAO()
    @IBOutlet var searchBar: UISearchBar!
    
    
    var meallist = [Meal]()
    
    //MARK: Private Methods
    
    
    //MARK: override
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        searchBar.enablesReturnKeyAutomatically = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.meallist = self.dao.fetch()

        self.tableView.reloadData()
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meallist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meals = meallist[indexPath.row]
        
        //테이블 뷰 셀은 재사용되기 위해 셀 id를 사용해야한다.
        let cellIdentifier = "MealTableViewCell"
        
        //커스텀 셀을 작성했으므로 셀 유형을 커스텀 셀 서브 클래스로 다운캐스트 해야한다.!!!!!!
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else{
            fatalError("The dequeued cell is not an instance of MealTableViewCell")
        }
        
        //적절한 meal을 레이아웃에 배치한다. meals 배열에서 가져옴.
        cell.nameLabel?.text = meals.name
        cell.photoImageView?.image = meals.photo
        cell.ratingControl?.rating = meals.rating ?? 0
        
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let meal = meallist[indexPath.row]
        
        if editingStyle == .delete{
            //데이터 소스에서 행을 삭제
            if dao.delete(meal.objectID!){
                meallist.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }else if editingStyle == .insert {
            //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //false를 리턴하면 edit을 못하도록 한다.
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //meallist에서 선택된 행에 맞는 데이터를 꺼낸다.
        let meal = meallist[indexPath.row]
        
        //상세화면 인스턴스 생성
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditMeal") as? MealEditViewController else{
            return
        }
        vc.param = meal
        
        //값을 전달한 다음 상세 화면으로 이동
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MAKR: - UISearchBar DataSource
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = searchBar.text
        
        meallist = self.dao.fetch(keyword: keyword)
        self.tableView.reloadData()
    }
    
    
}
