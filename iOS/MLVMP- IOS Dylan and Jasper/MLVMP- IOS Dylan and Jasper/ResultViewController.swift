//
//  ResultViewController.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by Dylan Landry on 7/16/15.
//  Copyright (c) 2015 Dylan Landry. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var jsonNavigator: JsonNavigator = JsonNavigator(json: jsonResponse())
    var selectedSpeciesName = String()
    var species = Species(name: "Empty", scientificName: "", tags: [], pictures: [], invasive: [],information:  [])
    var button = UIButton()
    var globalPic = UIImage()
    var spacingCounter: CGFloat = 0
    var leftIndent: CGFloat = 0
    var textWidth: CGFloat = 0
    var infoTextMargin: CGFloat = 3
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Set up nav bar icons
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        let p1 = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "backarrow", ofType: "png")
        var i = UIImage()
        if(p1 != nil)
        {
            i = UIImage(contentsOfFile: p1!)!
        }
        let backbutton = UIBarButtonItem(title: "", style: .plain , target: self, action: #selector(ResultViewController.back))
        backbutton.tintColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        backbutton.image = i
        self.navigationItem.setLeftBarButton(backbutton, animated: false)
        
        
        
        let homeButton = UIBarButtonItem(title: "", style: .plain , target: self, action: #selector(ResultViewController.goHome))
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

    override func viewDidLoad()
    {
        //Set up nav bar icons
        let homeButton = UIBarButtonItem(title: "Home", style: .plain , target: self, action: #selector(ResultViewController.goHome))
        homeButton.tintColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        self.navigationItem.setRightBarButton(homeButton, animated: false)
        let p1 = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + "backarrow", ofType: "png")
        var i = UIImage()
        if(p1 != nil)
        {
            i = UIImage(contentsOfFile: p1!)!
        }
        let backbutton = UIBarButtonItem(title: "", style: .plain , target: self, action: #selector(ResultViewController.back))
        backbutton.tintColor = UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)
        backbutton.image = i
        self.navigationItem.setLeftBarButton(backbutton, animated: false)
        self.navigationController!.navigationBar.tintColor = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:0.89, green:0.90, blue:0.89, alpha:1.0)]
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor(red:0.00, green:0.16, blue:0.00, alpha:1.0)
        
        //Spacing variables
        let pictureBottomMargin: CGFloat = 10
        scrollView.contentSize.height = 0
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.superview!.frame.width, height: scrollView.superview!.frame.height)
        
        //HEADER
        self.title = species.name
        
        
        //PICTURE
        var parsedImageName = species.pictures?[0].components(separatedBy: ".")
        let newImageName: String = parsedImageName![0] as String
        let path = Bundle.main.path(forResource: "MVLMP Images (Resized)/" + newImageName, ofType: "jpg")
        var uncroppedImage = UIImage()
        var uncroppedImageView = UIImageView()
        if(path != nil)
        {
        
            uncroppedImage = UIImage(contentsOfFile: path!)!
            uncroppedImageView = UIImageView(image: uncroppedImage)
            
        }
        else
        {
            
        }
        
        let imageWidth = (scrollView.frame.width/20)*17
        var imageHeight = imageWidth/3*2
        let w = uncroppedImage.size.width
        let h = uncroppedImage.size.height
        
        //Scale image
        let scale = imageWidth/w
        imageHeight = h*scale

        uncroppedImageView.frame = CGRect(x: (scrollView.frame.width - (scrollView.frame.width/20)*17)/3.2, y: 0, width: imageWidth, height: imageHeight)
        //Set up button over picture to view other pictures of species
        button.frame = CGRect(x: (scrollView.frame.width - (scrollView.frame.width/20)*17)/2, y: 0, width: imageWidth, height: imageHeight)
                   button.addTarget(self, action: #selector(ResultViewController.picTap), for: UIControlEvents.touchUpInside)
                scrollView.addSubview(button)
        
        
        leftIndent = ((scrollView.frame.width - (scrollView.frame.width/20)*17)/3.2)
        textWidth = (scrollView.frame.width/20)*17
        spacingCounter += uncroppedImageView.frame.height + pictureBottomMargin
        scrollView.addSubview(uncroppedImageView)
        
        //Set up dots indicating how many pictures of species there are
        let dotHolder = UIView()
        let width = ((species.pictures!.count) - 1)*20 + 14
        dotHolder.frame = CGRect(x: CGFloat(0), y: spacingCounter, width: CGFloat(width), height: CGFloat(30))
        dotHolder.frame.origin.x = (UIScreen.main.bounds.width/2) - dotHolder.frame.width/2 - leftIndent/2
        var xc = 0
        for x in 0...species.pictures!.count-1
        {
            let dot = UIView()
            
            if (x == 0)
            {dot.backgroundColor = UIColor(red: 50/255, green: 82/255, blue: 50/255, alpha: 1.0)}
            else
            {dot.backgroundColor = UIColor(red: 0/255, green: 45/255, blue: 0/255, alpha: 1.0)}
            dot.frame = CGRect(x: xc, y: 2, width: 14, height: 14)
            dot.layer.cornerRadius = dot.frame.size.width/2
            dot.clipsToBounds = true
            xc += 20
            dotHolder.addSubview(dot)
            
            
        }
        scrollView.addSubview(dotHolder)
        spacingCounter += 35
       
        //Write species info to page
        
        //Loading all provided information into a dictionary so that it can be drawn into UILabels using a for loop.
        let nameArray: [String] = [species.name]
        
        var scientificNameArray = [String]()
        if(species.scientificName != nil){
        scientificNameArray = [species.scientificName!]
        }
        
        var speciesContents = ["Name": nameArray]
        var label = UILabel(frame: CGRect(x: 0, y: spacingCounter, width: UIScreen.main.bounds.width-leftIndent, height: 50))
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        var tempArray = speciesContents["Name"]
        var tempString = tempArray?.first
        
        label.text = tempString
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        spacingCounter += label.frame.height
        scrollView.addSubview(label)

        
        if(species.scientificName != nil){
        if(scientificNameArray.count > 0){
            speciesContents["Scientific Name"] = scientificNameArray
            label = UILabel(frame: CGRect(x: 0, y: spacingCounter, width: UIScreen.main.bounds.width - leftIndent, height: 75))
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.textAlignment = .center
            tempArray = speciesContents["Scientific Name"]
            tempString = tempArray?.first
            
            label.text = tempString
            label.font = UIFont(name: "HelveticaNeue-Italic", size: 20)
            spacingCounter += label.frame.height
            scrollView.addSubview(label)

        }
        }
        spacingCounter += 20
        for infoSection in species.information!
        {
            createLabel(infoSection.title, bullets: infoSection.bullets)
        }
        //Adjust scrollview to size of text
        if(spacingCounter > scrollView.contentSize.height)
        {
            
            scrollView.contentSize.height = spacingCounter
            scrollView.contentOffset.x = 0
            scrollView.contentOffset.y = 0
                        
        }

    }
    
    
    
    
    func createLabel(_ title: String, bullets: [String])
    {
        //Create label for title of section
        let label = UILabel(frame: CGRect(x: leftIndent, y: spacingCounter, width: textWidth, height: 20))
        label.text = title
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        if(title == "Invasive")
        {
            label.text = title + "\n"
            spacingCounter += infoTextMargin*6
        }
        spacingCounter += label.frame.height
        scrollView.addSubview(label)
    
        //Create labels for bullets
        var informationContents: [String] = bullets
        for index2 in (0 ..< informationContents.count)
        {
            let maximumLabelSize: CGSize = CGSize(width: textWidth, height: 150)
            let labelRect: CGRect = (informationContents[0] as NSString).boundingRect(with: maximumLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
            let informationLabel = UILabel(frame: CGRect(x: leftIndent, y: spacingCounter, width: labelRect.width, height: labelRect.height))
            if !(title == "Invasive")
            {
                
                
                
                informationLabel.numberOfLines = 0
                informationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
                informationLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14)
                informationLabel.text = "- " + informationContents[index2] + "\n"
                informationLabel.textAlignment = NSTextAlignment.left
                informationLabel.preferredMaxLayoutWidth = scrollView.frame.width
                informationLabel.numberOfLines = 0
                informationLabel.frame = CGRect(x: informationLabel.frame.origin.x, y: informationLabel.frame.origin.y, width: scrollView.frame.width - 70, height: informationLabel.frame.height)
                informationLabel.sizeToFit()
            }
            spacingCounter += informationLabel.frame.height + infoTextMargin
            scrollView.addSubview(informationLabel)

        }
    }
    //Go to slideshow of all species pictures
    func picTap()
    {

        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SlideshowViewController") as! SlideshowViewController
        vc.jsonNavigator = jsonNavigator
        vc.species = self.species
        self.navigationController?.pushViewController(vc as UIViewController, animated: true)
    }
    
    func goHome()
    {
        let switchViewController = self.navigationController?.viewControllers[1] as! SpeciesTableViewController
        let times = jsonNavigator.orderOfNavigation.count
        switchViewController.jsonNavigator = JsonNavigator(json: jsonResponse())
        SortThread.getSortThread().resetMatches()
        
        for x in (0 ..< times)
        {
            jsonNavigator.regress()
        }
        self.navigationController?.popToViewController(switchViewController, animated: true)
    }
    func back()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
       override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate : Bool
    {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation)
    }

    
}


