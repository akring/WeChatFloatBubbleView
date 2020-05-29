//
//  ViewController.swift
//  WeChatFloatBubbleViewDemo
//
//  Created by 吕俊 on 2020/5/29.
//  Copyright © 2020 吕俊. All rights reserved.
//

import UIKit
import WeChatFloatBubbleView


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bubbleView = WeChatFloatBubbleView(frame: CGRect(x: 0, y: 200, width: 50, height: 50), rootView: self.view)
        
        bubbleView.show()
        
    }
}

