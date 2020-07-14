//
//  ViewController.swift
//  FoodTracker
//
//  Created by USER on 14/07/2020.
//  Copyright © 2020 USER. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    //MARK: Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
    }

//MARK: Action
    @IBAction func setDefaultLabelText(_ sender: Any) {
        mealNameLabel.text = "Default Text"
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
    
    func textFieldDidEndEditing(_ textField: UITextField){
        mealNameLabel.text = textField.text
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
}

