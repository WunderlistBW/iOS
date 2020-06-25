//
//  OnboardingViewController.swift
//  Wunderlist
//
//  Created by Cody Morley on 6/20/20.
//  Copyright © 2020 Wunderlist. All rights reserved.
//

import UIKit

// TODO: After signing up, sign the user in with the credentials. That should resolve the login bug that kicks user back to signup/signin flow.

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    // MARK: - Properties -
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var imageFrame = CGRect.zero
    var welcomeSlideShow: [String] = ["0", "1", "2", "3"]
    // MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        updateViews()
    }
    // MARK: - Scroll View Delegate -
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .signupSegue {
            if let signupVC = segue.destination as? LoginSignUpViewController {
                signupVC.isLoggingIn = false
            }
        } else if segue.identifier == .loginSegue {
            if let loginVC = segue.destination as? LoginSignUpViewController {
                loginVC.isLoggingIn = true
            }
        }
    }
    // MARK: - Actions -
    @IBAction func useAsGuest(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: .loggedInKey)
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Methods -
    private func updateViews() {
        navigationController?.isNavigationBarHidden = true
        pageControl.numberOfPages = welcomeSlideShow.count
        for slide in 0..<welcomeSlideShow.count {
            imageFrame.size = scrollView.bounds.size
            imageFrame.origin.x = scrollView.frame.size.width * CGFloat(slide)
            let slideImage = UIImageView(frame: imageFrame)
            slideImage.image = UIImage(named: welcomeSlideShow[slide])
            slideImage.layer.masksToBounds = true
            slideImage.contentMode = .scaleAspectFit
            self.scrollView.addSubview(slideImage)
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(welcomeSlideShow.count),
                                        height: scrollView.frame.size.height)
    }
}
