
//
//  HomeViewController.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by Administrator on 7/15/15.
//  Copyright (c) 2015 Dylan Landry. All rights reserved.
//

import Foundation


import UIKit

class HomeViewController: UIViewController {
    
    
    
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UITextView!
    
    var jsonNavigator = JsonNavigator(json: jsonResponse())
    var sortThread = SortThread.getSortThread()
    
    //Enter app
    func proceed()
    {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SpeciesTableViewController") as! SpeciesTableViewController
        vc.jsonNavigator = jsonNavigator
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        //Change title of button depending on first launch of app or not
        let notfirstLaunch = UserDefaults.standard.bool(forKey: "FirstLaunch")
        if notfirstLaunch
        {
            proceedButton.setTitle("Explore Aquatic Phenomena", for: UIControlState())
        }
        else
        {
            proceedButton.setTitle("Proceed to Tutorial", for: UIControlState())
            
        }
        
    }
    
    override func viewDidLoad()
    {
        
        text.frame = CGRect(x: 35, y: 92, width: 312, height: 109)
        //Set up navigation bar
        self.title = "Welcome"
        navigationController!.navigationBar.barTintColor = UIColor(red:0.07, green:0.24, blue:0.07, alpha:1.0)
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)]
        self.navigationController!.navigationBar.isTranslucent = false
        
        //Set up logo for welcome page
        proceedButton.addTarget(self, action: #selector(HomeViewController.proceed), for: UIControlEvents.touchUpInside)
        let path = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "MVLMPlogoforhelp", ofType: "png")
        var image1 = UIImage()
        if (path != nil)
        {
          image1 = UIImage(contentsOfFile: path!)!
        }
       
        let imageAspectRatio = image.bounds.width / image.bounds.height
        let imageview = UIImageView(image: image1)
        imageview.frame = CGRect(x: 18, y: 160, width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 20)/imageAspectRatio)
        self.view.addSubview(imageview)
        
        //Start species sorting thread
        sortThread.getThread().start()
  
        
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate : Bool {
        return false
    }

    
}
//Initialize search tree from json file
func jsonResponse() -> [String : AnyObject] {
    
    let path = Bundle.main.path(forResource: "searchTree(complete)", ofType: "json")!
    let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.uncached)
    let json: AnyObject! = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
    
    return json as! [String : AnyObject]
}

