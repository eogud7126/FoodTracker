//
//  MealEditViewController.swift
//  FoodTracker
//
//  Created by USER on 20/07/2020.
//  Copyright © 2020 USER. All rights reserved.
//

import UIKit

class MealEditViewController: UIViewController {

    //MARK: - Properties
    var param: Meal?
    lazy var dao = MealDAO()
    
    @IBOutlet var name: UITextField!
    @IBOutlet var photo: UIImageView!
    @IBOutlet var rating: RatingControl!
    
    
    override func viewDidLoad() {
        
        self.name.text = param?.name ?? ""
        self.photo.image = param?.photo
        self.rating.rating = param?.rating ?? 0

        self.navigationItem.title = self.name.text
        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        //MemoData 객체를 생성하고 데이터를 담음
        let meal = Meal()
        
        meal.name = self.name.text ?? ""
        meal.photo = self.photo.image
        meal.rating = self.rating.rating
        
        self.dao.insert(meal)
        self.dao.delete(param!.objectID!)
        
        print(meal.name ?? "aaaaa")


        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func pickImage(_ sender: Any) {
//        //이미지 선택 컨트롤러 만들기
//        let imagePickerController = UIImagePickerController()
//        //사진만 선택되도록(가져오는 위치 설정: 카메라롤)
//        imagePickerController.sourceType = .photoLibrary
//        //ViewController가 사용자가 이미지를 선택할 때 알아차릴 수 있도록 만든다.
//        imagePickerController.delegate = self
//        
//        present(imagePickerController,animated: true,completion: nil)
//    }
    
//    //MARK: - imagePickerDelegate
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//           //사용자가 취소하면 picker가 사라짐
//           dismiss(animated: true, completion: nil)
//       }
//       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//           // The info dictionary may contain multiple representations of the image. You want to use the original.
//           guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{
//               fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//           }
//           //선택한 이미지를 이미지 뷰에 배치
//           photo.image = selectedImage
//           //이미지 선택기 닫기
//           dismiss(animated: true, completion: nil)
//       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
