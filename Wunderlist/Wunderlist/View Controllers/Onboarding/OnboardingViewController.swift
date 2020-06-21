//
//  OnboardingViewController.swift
//  Wunderlist
//
//  Created by Cody Morley on 6/20/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: - Actions -
    @IBAction func useAsGuest(_ sender: Any) {
        
    }
    
    
    //MARK: - Methods -
    private func updateViews() {
        
    }
}
