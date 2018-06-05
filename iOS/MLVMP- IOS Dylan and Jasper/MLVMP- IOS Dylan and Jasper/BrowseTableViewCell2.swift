//  BrowseTableViewCell2.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by MIke Scott on 8/11/15.
//  Copyright (c) 2015 Dylan Landry. All rights reserved.
//

import UIKit

class BrowseCollectionView: UICollectionView {
    
    var indexPath: IndexPath!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

let collectionViewCellIdentifier: NSString = "CollectionViewCell"


//Create browse table view cell is essentially a collection view
class BrowseTableViewCell2: UITableViewCell
{
    
    var collectionView: BrowseCollectionView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let imageLength = (UIScreen.main.bounds.width-12)/4
        layout.minimumLineSpacing = 5                           //Set up margins
        layout.itemSize = CGSize(width: imageLength, height: imageLength)
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 4
        layout.itemSize = CGSize(width: imageLength, height: imageLength)
        layout.sectionInset = UIEdgeInsetsMake(20, 0,10,0);
        
        
        self.collectionView = BrowseCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier as String)
        self.collectionView.backgroundColor = UIColor(red: 226.0/255, green: 230.0/255, blue: 226.0/255, alpha: 1.0)

        
        
        self.collectionView.isScrollEnabled = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(self.collectionView)
        self.collectionView.backgroundColor = UIColor(red: 226.0/255, green: 230.0/255, blue: 226.0/255, alpha: 1.0)
        
        self.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frame = self.contentView.bounds
        self.collectionView.frame = CGRect(x: 0, y: 0.5, width: frame.size.width, height: frame.size.height - 1)
    }
    //Set up delegates // datasources
    func setCollectionViewDataSourceDelegate(dataSourceDelegate delegate: UICollectionViewDelegate & UICollectionViewDataSource, index: NSInteger) {
        self.collectionView.dataSource = delegate
        self.collectionView.delegate = delegate
        self.collectionView.tag = index
        self.collectionView.reloadData()
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate delegate: UICollectionViewDelegate & UICollectionViewDataSource, indexPath: IndexPath) {
        self.collectionView.dataSource = delegate
        self.collectionView.delegate = delegate
        self.collectionView.indexPath = indexPath
        self.collectionView.tag = indexPath.section
        self.collectionView.reloadData()
    }
}
