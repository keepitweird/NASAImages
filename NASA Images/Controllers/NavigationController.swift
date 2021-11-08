//
//  NavigationController.swift
//  NASA Images
//
//  Created by Tina Ho on 11/6/21.
//

import UIKit

class NavigationController : UINavigationController {

    override var preferredStatusBarStyle : UIStatusBarStyle {
        if let topVC = viewControllers.last {
            //Return the status property of each VC
            return topVC.preferredStatusBarStyle
        } else {
            return .default
        }
    }

}
