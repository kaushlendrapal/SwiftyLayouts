//
//  CardViewController.swift
//  SwiftyLayoutsExample
//
//  Created by kaushal on 23/01/18.
//  Copyright © 2018 kaushal. All rights reserved.
//

import UIKit
import SwiftyLayouts

fileprivate struct RegisteredCellClassIdentifier {
    static let layoutCollectionViewCell:String = "LayoutCollectionViewCell"
    static let layoutCollectionViewHeader:String = "LayoutCollectionViewHeader"
    static let layoutCollectionViewFooter:String = "LayoutCollectionViewFooter"

}

class CardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, LayoutDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: String!
    var collectionDataSource:[Feature]!
    
    var customLayout:CardViewLayout? {
        return collectionView.collectionViewLayout as? CardViewLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionViewLayout()
        setUpView()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setupNavigationBarItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView() -> Void {
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: RegisteredCellClassIdentifier.layoutCollectionViewHeader)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier: RegisteredCellClassIdentifier.layoutCollectionViewFooter)
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        customLayout?.delegate = self
    }
    
    func setupNavigationBarItems() -> Void {
//        self.title = "Swifty Layouts"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.title = ""
    }
}

extension CardViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var layoutCell:LayoutCollectionViewCell!
        layoutCell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisteredCellClassIdentifier.layoutCollectionViewCell, for: indexPath) as! LayoutCollectionViewCell
        // Configure the cell
        layoutCell.configureCell()
        
        return layoutCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var separator:UICollectionReusableView
        
        if (kind == UICollectionElementKindSectionHeader) {
            separator = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier:RegisteredCellClassIdentifier.layoutCollectionViewHeader, for: indexPath)
            separator.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            if indexPath == IndexPath(index:0) {
                separator.backgroundColor = #colorLiteral(red: 0.7598647549, green: 0.5621008782, blue: 1, alpha: 1)
            }
            
        } else if (kind == UICollectionElementKindSectionFooter) {
            separator = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier:RegisteredCellClassIdentifier.layoutCollectionViewFooter, for: indexPath)
            separator.backgroundColor = #colorLiteral(red: 0.7598647549, green: 0.5621008782, blue: 1, alpha: 1)
        } else {
            separator = UICollectionReusableView(frame: CGRect.zero)
        }

        return separator
    }
//    */
}

extension CardViewController {
    
    func collectionView(_ collectionView:UICollectionView, heightForCellAtIndexPath indexPath:IndexPath) -> CGFloat {
        return 120
    }
    
    func collectionView(_ collectionView:UICollectionView, ofSuplementryViewKind kind: String,  heightAtIndexPath indexPath:IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat.leastNormalMagnitude
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            if indexPath == IndexPath(index:0) {
                height = 200 //CGFloat.leastNormalMagnitude
            } else {
                height = 50
            }
        case UICollectionElementKindSectionFooter:
            if indexPath == IndexPath(index:0) {
                height = 200 //CGFloat.leastNormalMagnitude
            } else {
                height = CGFloat.leastNormalMagnitude
            }
        default:
            height = 50
        }
        
        return height
    }
 
}

private extension CardViewController {
    func setupCollectionViewLayout() {
        guard let customLayout = customLayout else { return }
        // register for layout elements
        var layoutSetting = LayoutSetting(contentMargin: UIEdgeInsets.zero, sectionMargin: UIEdgeInsetsMake(5, 10, 5, 10), cellMargin: UIEdgeInsetsMake(5, 10, 5, 10))
        layoutSetting.floatingHeaders = true
        customLayout.layoutSetting = layoutSetting
    }
}

enum CardViewControllerDependecy {
    typealias RawValue = (String, Any)
    case cardViewController(identifier:String, dependency:Any)
    
    @discardableResult func instantiateCardViewController() -> CardViewController {
        switch self {
        case .cardViewController(identifier:let identifier, dependency: let collectionDataSource):
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let cardVC:CardViewController = storyboard.instantiateViewController(withIdentifier:identifier) as! CardViewController
            guard let collectionDataSource = collectionDataSource as? [Feature] else {
                fatalError("dependency must type cast to String ")
            }
            cardVC.collectionDataSource = collectionDataSource
            return cardVC
        }
    }
}

extension CardViewController {
    class func mock_collectionDatasource_fromFeatureModel() -> ([Feature]) {
        var features:[Feature] = []
        features.append(Feature(name: "Feature_1", date: nil, key: "key_1", subFeatureCount:1))
        features.append(Feature(name: "Feature_2", date: nil, key: "key_2", subFeatureCount:1))
        features.append(Feature(name: "Feature_3", date: nil, key: "key_3", subFeatureCount:1))
        features.append(Feature(name: "Feature_4", date: nil, key: "key_4", subFeatureCount:1))
        features.append(Feature(name: "Feature_5", date: nil, key: "key_5", subFeatureCount:1))
        features.append(Feature(name: "Feature_6", date: nil, key: "key_6", subFeatureCount:1))
        features.append(Feature(name: "Feature_7", date: nil, key: "key_7", subFeatureCount:1))
        features.append(Feature(name: "Feature_8", date: nil, key: "key_8", subFeatureCount:1))
        features.append(Feature(name: "Feature_9", date: nil, key: "key_9", subFeatureCount:1))
        features.append(Feature(name: "Feature_10", date: nil, key: "key_10", subFeatureCount:1))
        
        return features
    }

}

extension LayoutCollectionViewCell {
   
    func configureCell() -> Void {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.contentView.layer.borderWidth = 5
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 10
        self.layer.shadowColor = #colorLiteral(red: 0.7123416428, green: 0.7265018714, blue: 0.7689825574, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5
        layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:0).cgPath
    }
}
