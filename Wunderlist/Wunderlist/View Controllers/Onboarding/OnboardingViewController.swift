//
//  OnboardingViewController.swift
//  Wunderlist
//
//  Created by Cody Morley on 6/20/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    //MARK: - Properties -
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageFrame = CGRect(x: 0, y: 0,
                            width: 0, height: 0)
    var welcomeSlideShow: [String] = [] //TODO: ADD PHOTOS TO ASSET FOLDER AND ADD IDs HERE
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .signupSegue {
            if let signupVC = segue.destination as? LoginSignUpViewController {
                signupVC.loggingIn = false
            }
        } else if segue.identifier == .loginSegue {
            if let loginVC = segue.destination as? LoginSignUpViewController {
                loginVC.loggingIn = true
            }
        }
    }
    
    
    //MARK: - Actions -
    @IBAction func useAsGuest(_ sender: Any) {
        
    }
    
    
    //MARK: - Methods -
    private func updateViews() {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}
