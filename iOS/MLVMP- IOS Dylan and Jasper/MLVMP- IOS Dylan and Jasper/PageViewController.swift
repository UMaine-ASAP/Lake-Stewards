//
//
//  PageViewController.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by MIke Scott on 8/6/15.
//  Copyright (c) 2015 Dylan Landry. All rights reserved.
//


//Used to page between images for multiple species on browse page

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    //
    var species = Species(name: "Empty", scientificName: "", tags: [], pictures: [], invasive: [],  information: [])
    var speciesList: [Species]!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    var photoList = [String]()
    
    var startIndex = 0
    var speciesIndex = 0
    var photoIndex = 0
    var dotArray = [UIView]()
    var dotChange = false
    var navHeight = CGFloat(0)
    func viewControllerAtIndex(_ index: Int) -> ContentViewController
    {
        //If index is at start or end, no new controller is created
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count))
        {
            return ContentViewController()
        }
        
        let v: ContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
        //Get image and index for current page
        v.imageFile = self.pageImages[index] as! String
        v.pageIndex = index
        v.fromResult = false
        return v
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        //Set up view controllers to be scrolled through
        let startVC = self.viewControllerAtIndex(photoIndex) as ContentViewController
        let viewControllers = NSArray(object: startVC)
        self.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
        self.view.frame = CGRect(x: 0,y: 0, width:self.view.frame.width, height: UIScreen.main.bounds.height - navHeight)
        
        //Set up nav buttons
        let homeButton = UIBarButtonItem(title: "Back", style: .plain , target: self, action: #selector(PageViewController.Back))
        self.navigationItem.setLeftBarButton(homeButton, animated: false)
        navigationController?.navigationBar.tintColor = UIColor.white
        homeButton.tintColor = UIColor.white
       
        
    }
    
    func Back()
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    // MARK: - Page View Controller Data Source
    //Scroll backward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        if (index == 0 || index == NSNotFound)
        {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    //Scroll forwards
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
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
    
    //
    
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return photoIndex
    }
    
}
