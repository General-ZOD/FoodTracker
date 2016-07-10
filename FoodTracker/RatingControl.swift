//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Sam on 5/29/16.
//  Copyright © 2016 Sam. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    
    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    var rating_buttons = [UIButton]()
    let spacing = 5
    let star_count = 5

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let filled_star_image = UIImage(named: "filledStar")
        let empty_star_image = UIImage(named: "emptyStar")
        for _ in 0..<star_count {
        
            let button = UIButton()
            button.adjustsImageWhenHighlighted = false
            button.setImage(empty_star_image, forState: .Normal)
            button.setImage(filled_star_image, forState: .Selected)
            button.setImage(filled_star_image, forState: [.Highlighted, .Selected])
        
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), forControlEvents: .TouchDown)
            
            rating_buttons += [button]
        
            addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        print(frame.size.height)
        print(frame.size.width)
        let button_size = Int(frame.size.height)
        var button_frame = CGRect(x: 0, y: 0, width: button_size, height: button_size)
        
        for (index, button) in rating_buttons.enumerate() {
            button_frame.origin.x = CGFloat(index * (button_size + spacing))
            button.frame = button_frame
        }
        
        updateButtonSelectionStates()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let button_size = Int(frame.size.height)
        let width = (button_size * star_count) + (spacing * (star_count - 1))
        
        return CGSize(width: width, height: button_size)
    }
    
    func ratingButtonTapped(button: UIButton) {
        rating = rating_buttons.indexOf(button)! + 1
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in rating_buttons.enumerate() {
            button.selected = index < rating
        }
    }

}
