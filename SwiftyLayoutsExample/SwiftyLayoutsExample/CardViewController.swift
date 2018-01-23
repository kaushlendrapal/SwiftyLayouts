//
//  CardViewController.swift
//  SwiftyLayoutsExample
//
//  Created by kaushal on 23/01/18.
//  Copyright © 2018 kaushal. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    var viewModel: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("dependency value for viewModel \(viewModel)")
        // Do any additional setup after loading the view.
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
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

