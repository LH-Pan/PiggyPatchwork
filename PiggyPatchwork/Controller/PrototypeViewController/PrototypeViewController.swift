//
//  PrototypeViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class PrototypeViewController: UIViewController {
    
    @IBOutlet weak var selectionView: SelectionView!
    
    let selectionTitle: [String] = ["編排", "背景"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionView.dataSource = self
        
        selectionView.delegate = self
    }
}

extension PrototypeViewController: SelectionViewDelegate, SelectionViewDataSource {
    
    func textOfSelections(_ selectionView: SelectionView, index: Int) -> String {
        return selectionTitle[index]
    }
}
