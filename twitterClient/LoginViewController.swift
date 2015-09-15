//
//  ViewController.swift
//  twitterClient
//
//  Created by 田中千洋 on 2015/09/05.
//  Copyright (c) 2015年 田中 颯. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = TWTRLogInButton(logInCompletion: {
            session, error in
            if session != nil {
                println(session.userName)
                // ログイン成功したらクソ遷移する
                let timelineVC = TimelineViewController()
                UIApplication.sharedApplication().keyWindow?.rootViewController = timelineVC
            } else {
                println(error.localizedDescription)
            }
        })
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
    }
}

