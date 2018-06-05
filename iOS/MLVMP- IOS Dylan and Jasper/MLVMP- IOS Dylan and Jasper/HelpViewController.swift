//
//  HelpViewController.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by MIke Scott on 8/12/15.
//  Copyright (c) 2015 Dylan Landry. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController
{
    
    var pageViewController = TutorialPageViewController()
    override func viewDidLoad()
    {   title = "Help"
        super.viewDidLoad()
        let homeButton = UIBarButtonItem(title: "", style: .plain , target: self, action: #selector(HelpViewController.goHome))

        let p1 = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "home1", ofType: "png")
        var i = UIImage()
        if(p1 != nil)
        {
            i = UIImage(contentsOfFile: p1!)!
        }
        //Resize image
        let newSize = CGSize(width: 17, height: 15)
        let newRect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height).integral
        let imageRef = i.cgImage
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        // Set the quality level to use when rescaling
        context!.interpolationQuality = CGInterpolationQuality.high
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
        context?.concatenate(flipVertical)
        // Draw into the context; this scales the image
        context?.draw(imageRef!, in: newRect)
        let newImageRef = context?.makeImage()! as! CGImage
        let newImage = UIImage(cgImage: newImageRef)
        // Get the resized image from the context and a UIImage
        UIGraphicsEndImageContext()
        

        homeButton.tintColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        homeButton.image = newImage

        self.navigationItem.setRightBarButton(homeButton, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        
        
        //Set up tutorial slideshow
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "TutorialPageViewController") as! TutorialPageViewController
        self.pageViewController.fromHelp = true
        self.pageViewController.view.frame = CGRect(x: 0,y: 0, width:self.view.frame.width, height:self.view.frame.size.height)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let p1 = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "backarrow", ofType: "png")
        var i = UIImage()
        if(p1 != nil)
        {
            
            i = UIImage(contentsOfFile: p1!)!
            
            
        }
        let backbutton = UIBarButtonItem(title: "", style: .plain , target: self, action: #selector(HelpViewController.back))
        backbutton.tintColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        backbutton.image = i
        self.navigationItem.setLeftBarButton(backbutton, animated: false)
        
    }
    func back()
    {
        self.navigationController?.popViewController(animated: true)
    }

    func goHome()
    {
        let switchViewController = self.navigationController?.viewControllers[1] as! SpeciesTableViewController
        switchViewController.jsonNavigator = JsonNavigator(json: jsonResponse())
        SortThread.getSortThread().resetMatches()
        self.navigationController?.popToViewController(switchViewController, animated: true)
    }
    
    
     
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate : Bool {
        return false
    }

    
}
