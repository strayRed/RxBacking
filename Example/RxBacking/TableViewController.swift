//
//  TableViewController.swift
//  RxBacking_Example
//
//  Created by strayRed on 2023/1/25.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxBacking
import ViewSizeExpansion

class TableViewController: UIViewController, UITableViewDelegate {
    var sections: [Section] = staticSections
    
    lazy var source: BehaviorRelay = .init(value: sections)
    lazy var tableView: UITableView = {
        return UITableView.init(frame: view.bounds, style: .grouped)
    }()
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        RxAnimatableTableViewBacking<Section>
            .init(parentObject: tableView, shouldRetain: true)
            .reusableCell { _, _ in Reusable.tableViewCell }
            .cellConfigurationAfterSynchronized({ [weak self] cell, sectionItem, indexPath in
                guard let cell = cell as? TableViewCell, let self = self else { return }
                cell.setupTableViewItemExpansion(state: sectionItem.expansionState, tableViewWidth: self.tableView.bounds.width) { self.updateModelExpansionState($0, at: indexPath)
                }
            })
            .forwordObject(self)
            .dataSourceBinded(to: source.asObservable())
            .disposed(by: bag)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func updateModelExpansionState(_ state: ExpansionState, at indexPath: IndexPath) {
        if state == sections[indexPath.section].items[indexPath.row].expansionState { return }
        sections[indexPath.section].items[indexPath.row].updateExpansionState(state)
        source.accept(sections)
    }
    


//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.estimatedRowHeight
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
