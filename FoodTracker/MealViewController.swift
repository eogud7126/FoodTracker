//
//  MealViewController.swift
//  FoodTracker
//
//  Created by USER on 14/07/2020.
//  Copyright © 2020 USER. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    //MARK: Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var meal: Meal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        updateSaveButtonState()
    }

    //MARK: Navigation
    
    //뷰 컨트롤러가 나타나기 전에 알아차릴 수 있도록
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //Configure the destination view controller only when the save button is pressed = 저장 버튼을 누른 경우에만 대상보기 컨트롤러를 구성하십시오
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, cancelling",log:OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    
    
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
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //키보드 숨기기
        nameTextField.resignFirstResponder()
        //이미지 선택 컨트롤러 만들기
        let imagePickerController = UIImagePickerController()
        //사진만 선택되도록(가져오는 위치 설정: 카메라롤)
        imagePickerController.sourceType = .photoLibrary
        //ViewController가 사용자가 이미지를 선택할 때 알아차릴 수 있도록 만든다.
        imagePickerController.delegate = self
        
        present(imagePickerController,animated: true,completion: nil)
        
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
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //사용자가 취소하면 picker가 사라짐
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        //선택한 이미지를 이미지 뷰에 배치
        photoImageView.image = selectedImage
        //이미지 선택기 닫기
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Private Method
    
    private func updateSaveButtonState(){
        //textField가 비어있으면 비활성화
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

