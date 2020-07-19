//
//  TabBarController.swift
//  excusemaker
//
//  Created by ptgms on 10.05.20.
//  Copyright © 2020 ptgms. All rights reserved.
//

import UIKit
import SwipeableTabBarController

// swipability to the courtesy of https://github.com/marcosgriselli/SwipeableTabBarController

class TabBarController: SwipeableTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.sideBySide
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
