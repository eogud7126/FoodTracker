//
//  MealViewController.swift
//  FoodTracker
//
//  Created by USER on 14/07/2020.
//  Copyright © 2020 USER. All rights reserved.
//

import UIKit
import CoreData
import os.log

class MealViewController: UIViewController, UITextFieldDelegate , UINavigationControllerDelegate{
    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    lazy var dao = MealDAO()
    var object: MealMO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MealViewController")
        nameTextField.delegate = self
        updateSaveButtonState()
    }


    @IBAction func save(_ sender: Any) {
        //MemoData 객체를 생성하고 데이터를 담음

        if object == nil {
            let entity = NSEntityDescription.entity(forEntityName: "Meal", in: MealDAO.shared._fetchedResultsController!.managedObjectContext)
            object = MealMO(entity: entity!, insertInto: MealDAO.shared._fetchedResultsController?.managedObjectContext)
//            object = MealMO(context: self.dao.fetchedResultsController.managedObjectContext)
        }
        object?.name = self.nameTextField.text
        object?.rating = self.ratingControl.rating
        MealDAO.shared.insert()

        
//        print(meal.name ?? "aaaaa")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Navigation
    
    //MARK: Action

    @IBAction func cancel(_ sender: Any) {
        //Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingAddMealMore = presentingViewController is UINavigationController
        
        if isPresentingAddMealMore{
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }else{
            fatalError("The MealViewController is not inside a navigation controller")
        }
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //키보드 숨기기
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        //사용자가 취소하면 picker가 사라짐
//        dismiss(animated: true, completion: nil)
//    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        // The info dictionary may contain multiple representations of the image. You want to use the original.
//        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
//        //선택한 이미지를 이미지 뷰에 배치
//        photoImageView.image = resizeImage(image: selectedImage, newWidth: 200)
//        //이미지 선택기 닫기
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
//        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
//        let newHeight = image.size.height * scale
//        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
//        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage!
//    }
    
    //MARK: Private Method
    
    private func updateSaveButtonState(){
        //textField가 비어있으면 비활성화
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

