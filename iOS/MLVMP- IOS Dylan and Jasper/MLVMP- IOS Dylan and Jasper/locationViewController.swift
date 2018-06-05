//
//  LocationViewController.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by Dylan Landry on 7/18/15.
//  Copyright (c) 2015 Dylan Landry. All rights reserved.
//

import UIKit

class LocationViewController2: UIViewController {

    
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var contentView: UIView!
    var jsonNavigator: JsonNavigator = JsonNavigator(json: jsonResponse())
    var locations = [LocationCard]()
    var brownBarLeft: UIView!
    var brownBarRight: UIView!
    var buttonUIView: UIView!
    var button: UIButton!
    
    override func viewDidLoad() {
        
        locations.append(LocationCard(name: "shoreline", pictureName: "yellowish_powder1")!)
        locations.append(LocationCard(name: "surface", pictureName: "alternate_flowered_watermilfoil5")!)
        locations.append(LocationCard(name: "shallow", pictureName: "common_bladderwort6")!)
        locations.append(LocationCard(name: "deep", pictureName: "landlocked_salmon1")!)
        locations.append(LocationCard(name: "bottom", pictureName: "freshwater_sponge4")!)
        
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        contentView.backgroundColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        
        var spacingCounter: CGFloat = 0
        
        title = "Location"
        
        for index in (0 ..< locations.count) {
            
            
            //Create green borders
            brownBarLeft = UIView(frame: CGRect(x: 0, y: spacingCounter, width: 9, height: 307))
            brownBarLeft.backgroundColor = UIColor(red:0.20, green:0.32, blue:0.20, alpha:1.0)
            brownBarRight = UIView(frame: CGRect(x: view.bounds.width - 9, y: spacingCounter, width: 9, height: 307))
            brownBarRight.backgroundColor = UIColor(red:0.20, green:0.32, blue:0.20, alpha:1.0)
            contentView.addSubview(brownBarLeft)
            contentView.addSubview(brownBarRight)
            navigationController?.navigationBar.tintColor = UIColor.white
        
            let path = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + locations[index].pictureName, ofType: "jpg")
            var image = UIImage()
            image = UIImage(contentsOfFile: path!)!

            //Resize image
            
            //Ideal proportions
            let wantedwidth = self.view.frame.width - 34
            
            
            //Actual proportions
            let width  = image.size.width
            let height = image.size.height
            
            //Adjust height based on scale
            let scale = wantedwidth/width
            let newheight = height*scale
            
            
            imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: brownBarLeft.bounds.width + 9, y: brownBarLeft.frame.origin.y + 9, width: wantedwidth, height: newheight)
            contentView.addSubview(imageView)
            //Increase border height based on image
            brownBarLeft.frame = CGRect(x: 0, y: spacingCounter, width: 9, height: imageView.frame.height + 68.5 + 30)
            brownBarRight.frame = CGRect(x: view.bounds.width - 9, y: spacingCounter, width: 9, height: imageView.frame.height + 68.5 + 30)
            
            
            //Create button shadow
            buttonUIView = UIView(frame: CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y + imageView.frame.height, width: imageView.frame.width, height: 68.5))
            buttonUIView.backgroundColor = UIColor(red:0.20, green:0.32, blue:0.20, alpha:1.0)
            buttonUIView.layer.shadowColor = UIColor.black.cgColor
            buttonUIView.layer.shadowOffset = CGSize(width: 0, height: 4)
            buttonUIView.layer.shadowRadius = 5
            buttonUIView.layer.shadowOpacity = 1.0
            buttonUIView.layer.masksToBounds = false
            contentView.addSubview(buttonUIView)
            
            //Create button title
            button = UIButton(frame: CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y, width: imageView.frame.width, height: imageView.frame.height + buttonUIView.frame.height))
            button.setTitle(locations[index].name.capitalized, for: UIControlState())
            button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 22)
            button.titleEdgeInsets.top += ((imageView.frame.height + 0))
            button.addTarget(self, action: #selector(LocationViewController2.pressed(_:)), for: UIControlEvents.touchUpInside)
            button.setTitleColor(UIColor.white, for: UIControlState())
            contentView.addSubview(button)
            spacingCounter += brownBarLeft.frame.height
        }
        
        contentView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: spacingCounter)
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.bounces = false
        scrollView.backgroundColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        scrollView.contentSize.height = contentView.bounds.height
        scrollView.autoresizingMask = UIViewAutoresizing.flexibleHeight
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        navigationController!.navigationBar.barTintColor = UIColor(red:0.07, green:0.24, blue:0.07, alpha:1.0)
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)]
        
    }
    
    func pressed(_ sender: UIButton!){
        
        //Add tag to sort thread
        SortThread.getSortThread().addToQueue(sender.titleLabel!.text!.lowercased())
        
        //Go to species table view controller filtered by location
        let speciesTableViewController = self.storyboard!.instantiateViewController(withIdentifier: "SpeciesTableViewController") as! SpeciesTableViewController
        speciesTableViewController.needToDisplayLocation = false
        speciesTableViewController.locationPicked = true
        speciesTableViewController.pickedLocation = sender.titleLabel!.text!
        self.navigationController!.pushViewController(speciesTableViewController, animated: true)
        
    }
    
      override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set up nav bar icons
        let p1 = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "backarrow", ofType: "png")
        var i = UIImage()
        if(p1 != nil)
        {
            i = UIImage(contentsOfFile: p1!)!
        }
        let backbutton = UIBarButtonItem(title: "", style: .plain , target: self, action: #selector(LocationViewController2.back))
        backbutton.tintColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        backbutton.image = i
        self.navigationItem.setLeftBarButton(backbutton, animated: false)
        
        let homeButton = UIBarButtonItem(title: "", style: .plain , target: self, action: #selector(LocationViewController2.goHome))
        
        let p2 = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "home1", ofType: "png")
        i = UIImage()
        if(p2 != nil)
        {
            
            i = UIImage(contentsOfFile: p2!)!
            
            
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

        
    }
    func back()
    {
        self.navigationController?.popViewController(animated: true)
    }
    func goHome ()
    {
        self.navigationController?.popViewController(animated: true)
    }

    
        
        

        
    

    @IBAction func pressedLocationButton(_ sender: AnyObject) {
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Keep application in portrait
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate : Bool {
        return false
    }


}
