//
//  UIViewController+Extension.swift
//  HabitApp
//
//  Created by Jacob Guerena on 8/25/18.
//  Copyright © 2018 Jacob Guerena. All rights reserved.
//

import UIKit

extension UIViewController  {
    @objc func dismissKeyboard(_ sender: Any) {
        for view in self.view.subviews {
            if view.isFirstResponder {
                view.resignFirstResponder()
            }
        }
    }
}
