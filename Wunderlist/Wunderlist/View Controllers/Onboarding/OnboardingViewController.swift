//
//  OnboardingViewController.swift
//  Wunderlist
//
//  Created by Cody Morley on 6/20/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

/*
 TODO LIST
 //unfinished
 Get photos for welcome slideshow and add them to asset folder
 Give the photos a naming convention that makes them easy to add to the page control view
 
 
 //finished
 properties list
 set scroll view delegate
 set up so photos in slideshow will snap into place with frames
 set button to use app without logging in (limit functionality? I don't know. Question for later.)
 set user defaults to easily capture login flow for future logins
 set segues to fork onboarding for login/signup
 Set up update views logic to use imageFrame to operate slideshow inside of scrollView view
 */



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
        scrollView.delegate = self
    }
    
    //MARK: - Scroll View Delegate -
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
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
        UserDefaults.standard.set(false, forKey: .loggedInKey)
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Methods -
    private func updateViews() {
        navigationController?.isNavigationBarHidden = true
        pageControl.numberOfPages = welcomeSlideShow.count
        
        for slide in 0..<welcomeSlideShow.count {
            imageFrame.size = scrollView.frame.size
            imageFrame.origin.x = scrollView.frame.size.width * CGFloat(slide)
            
            let slideImage = UIImageView(frame: imageFrame)
            ///TODO: need to set image on the next line
            //slideImage.image = UIImage(named: "")
            slideImage.layer.masksToBounds = true
            slideImage.contentMode = .scaleAspectFill
            self.scrollView.addSubview(slideImage)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(welcomeSlideShow.count),
                                        height: scrollView.frame.size.height)
    }
}
