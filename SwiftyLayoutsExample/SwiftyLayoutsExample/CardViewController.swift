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
}

class CardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, LayoutDelegate  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: String!
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView() -> Void {
        collectionView.delegate = self
        collectionView.dataSource = self
        customLayout?.delegate = self
        
    }
}

extension CardViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var layoutCell:LayoutCollectionViewCell!
        layoutCell = collectionView.dequeueReusableCell(withReuseIdentifier: RegisteredCellClassIdentifier.layoutCollectionViewCell, for: indexPath) as! LayoutCollectionViewCell
        // Configure the cell
        
        return layoutCell
    }
}

extension CardViewController {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if (indexPath.row % 2) == 0 {
            return 50
        } else {
            return 100
        }
    }
}

private extension CardViewController {
    func setupCollectionViewLayout() {
        guard let collectionView = collectionView, let customLayout = customLayout else { return }
        // register for layout elements
        var layoutSetting = LayoutSetting(contentMargin: UIEdgeInsets.zero, sectionMargin: UIEdgeInsets.zero, cellMargin: UIEdgeInsetsMake(2, 10, 2, 10))
        layoutSetting.updateCellMargin(cellMargin: UIEdgeInsetsMake(5, 10, 5, 10))
        customLayout.layoutSetting = layoutSetting
    }
}

enum CardViewControllerDependecy {
    typealias RawValue = (String, Any)
    
    case cardViewController(identifier:String, dependency:Any)
    
    @discardableResult func instantiateCardViewController() -> CardViewController {
        switch self {
        case .cardViewController(identifier:let identifier, dependency: let viewModel):
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let cardVC:CardViewController = storyboard.instantiateViewController(withIdentifier:identifier) as! CardViewController
            guard let viewModel = viewModel as? String else {
                fatalError("dependency must type cast to String ")
            }
            cardVC.viewModel = viewModel
            return cardVC
        }
    }
}

