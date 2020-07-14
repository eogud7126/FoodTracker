//
//  RatingControl.swift
//  FoodTracker
//
//  Created by USER on 14/07/2020.
//  Copyright © 2020 USER. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet{
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setupButtons()
        }
    }
    
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton){
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not  in the ratingButtons array: \(ratingButtons)")
        }
        //선택된 버튼들 연산
        let selectedRating = index + 1
        
        if selectedRating == rating {
            //만약 선택된 버튼이 현재의 값과 일치한다면 0으로 리셋
            rating = 0
        } else {
            //그렇지 않으면 선택된 버튼만큼 셋
            rating = selectedRating
        }
    }
    
    
    
    //MARK: Private Method
    private func setupButtons() {
        //존재하는 버튼들 지우기
        for button in ratingButtons {
            //스택뷰에서 관리하는 버튼 제거 -> 여전히 스택뷰의 Subview
            removeArrangedSubview(button)
            //스택뷰에서 버튼을 완전히 제거하기..
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //별표 모양으로 만들기
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        // 버튼 만들기
        for index in 0..<starCount{
            
            
            let button = UIButton()
            //button.backgroundColor = .red
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            //constraint 추가
            //레이아웃 엔진에게 뷰 프레임과 오토리사이징마스크 속성에 따라 뷰의 크기와 위치를 정의하는 제약 조건을 만들도록 지시
            button.translatesAutoresizingMaskIntoConstraints = false
            //레이아웃 앵커에 액세스. 배치 앵커를 사용하여 constraint조건 작성 isActive는 구속 조건을 활성화하거나 비활성화
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //접근성 라벨 설정
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            //버튼 액션 추가
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            //스택에 버튼 추가: 사용자가 작성한 버튼을 스택에 추가
            addArrangedSubview(button)
            
            //새로운 버튼 배열을 추가
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    
    private func updateButtonSelectionStates() {
        for(index, button) in ratingButtons.enumerated() {
            //만약 버튼의 인덱스가  rating보다 작으면, 그 버튼은 선택된다.
            button.isSelected = index < rating
            
            //hint 문자열 설정
            let hintString: String?
            if rating == index + 1{
                hintString = "Tap to reset the rating to zero"
            }else{
                hintString = nil
            }
            
            //value 문자열 연산
            let valueString: String
            switch (rating){
            case 0:
                valueString = "No rating set"
            case 1:
                valueString = "1 star set"
            default:
                valueString = "\(rating) stars set"
            }
            
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
