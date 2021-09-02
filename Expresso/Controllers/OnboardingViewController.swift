//
//  OnboardingViewController.swift
//  Expresso
//
//  Created by Jessi Febria on 05/05/21.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var imageName = ["ExpressoOnboarding-1", "ExpressoOnboarding-2", "ExpressoOnboarding-3"]
    
    var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    
    var scrollWidth: CGFloat = 0.0
    var scrollHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageControl()
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
        
        for index in 0...2 {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = self.scrollView.frame.size
            print(index)
            
            let backgroundImage = UIImageView(frame: frame)
//            subView.backgroundColor = colors[index]
            print(frame)
            backgroundImage.image = UIImage(named: imageName[index])
            backgroundImage.contentMode = .scaleToFill
//            subView.addSubview(backgroundImage)
            
            self.scrollView.addSubview(backgroundImage)
            
            if index == 2 {
                print(frame.origin.x + 20)
                let passButton = UIButton(frame: CGRect(x: frame.origin.x + 20, y: 20, width: 250, height: 40))
                passButton.center = CGPoint(x:frame.origin.x + 200 ,y: 690)
                passButton.setTitle("Let's Try It", for: .normal)
                passButton.layer.cornerRadius = 8.0
                passButton.backgroundColor = UIColor(red:45/255.0, green:57/255.0, blue:38/255.0, alpha:1.0)
                passButton.setTitleColor(UIColor.white, for: .normal)
                passButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                passButton.addTarget(self, action: #selector(self.passButton), for: .touchUpInside)
                self.scrollView.addSubview(passButton)
            }
            
        }
        
        self.scrollView.contentSize = CGSize(width: scrollWidth * 3, height: scrollHeight)
        pageControl.addTarget(self, action: #selector(self.changePage), for: UIControl.Event.valueChanged)

        // Do any additional setup after loading the view.
    }
    
    @objc func passButton(){
        performSegue(withIdentifier: "onboardingToHome", sender: nil)
    }
    
    func configurePageControl(){
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
    }
    
    @objc func changePage() {
           let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
           scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
       }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(self.scrollView.contentOffset.x / scrollWidth)
        pageControl.currentPage = Int(pageNumber)
    }

}
