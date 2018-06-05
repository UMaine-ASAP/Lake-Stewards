//
//  ResultPageViewController.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by MIke Scott on 8/11/15.
//  Copyright (c) 2015 Dylan Landry. All rights reserved.
//

//Governs pageviewcontroller showing species pictures

import UIKit

class ResultPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    var species = Species(name: "Empty", scientificName: "", tags: [], pictures: [], invasive: [], information: [])
    var pageTitles: NSArray!
    var pageImages: NSArray!
    var dotArray = [UIView]()
    var startIndex = 0
    
    //Set up image to be shown at current indexed page
    func viewControllerAtIndex(_ index: Int) -> ContentViewController
    {
        
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count))
        {
            return ContentViewController()
        }
        let v: ContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        v.imageFile = self.pageImages[index] as! String
        v.pageIndex = index
        return v
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.pageTitles = species.pictures as! NSArray
        self.pageImages = species.pictures as! NSArray

        self.dataSource = self
        self.delegate = self
        let startVC = self.viewControllerAtIndex(startIndex) as ContentViewController
        let viewControllers = NSArray(object: startVC)
        
        self.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        self.view.frame = CGRect(x: 0,y: 0, width:self.view.frame.width, height: UIScreen.main.bounds.height - self.navigationController!.navigationBar.frame.height)
        
        
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    func Back()
    {   self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Page View Controller Data Source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //Increment index to keep track of dots
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        if (index == 0 || index == NSNotFound)
        {
            return nil
            
        }
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {   //Increment image to keep track of dots
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        if (index == NSNotFound)
        {
            return nil
        }
        index += 1
        if (index == self.pageTitles.count)
        {
            return nil
        }
        return self.viewControllerAtIndex(index)
        
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
}
