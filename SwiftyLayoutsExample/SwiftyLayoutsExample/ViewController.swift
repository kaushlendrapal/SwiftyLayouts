//
//  ViewController.swift
//  SwiftyLayoutsExample
//
//  Created by kaushal on 17/01/18.
//  Copyright © 2018 kaushal. All rights reserved.
//

import UIKit

fileprivate struct RegisteredCellClassIdentifier {
    static let layoutTableViewCell:String = "LayoutTableViewCell"
}
let tableViewDataSource:[String] = ["CardView Layout", "WeekView Layout", "TimeSlot Layout"]

final class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupNavigationBarItems()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView() -> Void {
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setupNavigationBarItems() -> Void {
        self.title = "Swifty Layouts"
    }
}

//MARK: Tableview DataSource & Delegate
extension ViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var layoutCell:LayoutTableViewCell!
        layoutCell = tableView.dequeueReusableCell(withIdentifier: RegisteredCellClassIdentifier.layoutTableViewCell, for: indexPath) as! LayoutTableViewCell
        let labelText = tableViewDataSource[indexPath.row]
        layoutCell.configureLayoutcell(with: labelText)
        return layoutCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionDatasource:[Feature] = CardViewController.mock_collectionDatasource_fromFeatureModel()
        let labelText = tableViewDataSource[indexPath.row]
        let cardViewController = CardViewControllerDependecy.cardViewController(identifier:"CardViewController", dependency: collectionDatasource).instantiateCardViewController()
        cardViewController.title = labelText
        self.navigationController?.pushViewController(cardViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//MARK Configure Layout cell
extension LayoutTableViewCell {
    func configureLayoutcell(with layoutText:String) -> Void {
        self.layoutLabel.text = layoutText
    }
}












