//
//  SelectionViewProtocol.swift
//  SelectionViewAssignment
//
//  Created by 潘立祥 on 2019/8/28.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit

class SelectionView: UIView {
    
    weak var delegate: SelectionViewDelegate?
    
    weak var dataSource: SelectionViewDataSource? {
        
        didSet {
            addButton()
        }
    }
    
    let indicatorView = UIView()
    
    var selectedIndex: Int = 0
    
    func addButton() {
        
        guard let dataSource = dataSource else { return }
        
        let btnWidth = UIScreen.width / CGFloat(dataSource.numberOfSelections(self))
        
        let btnHeight = self.bounds.height - 2
        
        for index in 0...(dataSource.numberOfSelections(self) - 1) {
            
            let button = UIButton()
            
            button.tag = index
            
            button.frame = CGRect(x: btnWidth * CGFloat(index),
                                  y: 0,
                                  width: btnWidth, height: btnHeight)
            
            button.setTitle(dataSource.textOfSelections(self, index: index),
                            for: .normal)
            
            button.setTitleColor(dataSource.colorOfSelectionText(self),
                                 for: .normal)
            
            button.titleLabel?.font = dataSource.fontOfText(self)
            
            button.backgroundColor = .white
            
            self.addSubview(button)
            
            button.addTarget(self,
                             action: #selector(moveIndicatorView(_:)),
                             for: .touchUpInside)
            
            if index == 0 {
                
                indicatorView.frame = CGRect(x: 0,
                                             y: btnHeight,
                                             width: btnWidth * 2 / 3,
                                             height: 2)
                
                indicatorView.center.x = button.center.x
                
                indicatorView.layer.cornerRadius = 15
                
                indicatorView.backgroundColor = dataSource.colorOfIndicatorView(self)
                
                self.addSubview(indicatorView)
            }
        }
    }
    
    @objc func moveIndicatorView(_ sender: UIButton) {
        
        selectedIndex = sender.tag
        
        guard let delegate = delegate else { return }
        
        if delegate.enable?(self, index: sender.tag) == true {
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.indicatorView.center.x = sender.center.x
            })
            
            delegate.didSelected?(self, index: sender.tag)
        }
    }
}

protocol SelectionViewDataSource: AnyObject {
    
    func numberOfSelections(_ selectionView: SelectionView) -> Int
    
    func textOfSelections(_ selectionView: SelectionView, index: Int) -> String
    
    func colorOfIndicatorView(_ selectionView: SelectionView) -> UIColor
    
    func colorOfSelectionText(_ selectionView: SelectionView) -> UIColor
    
    func fontOfText(_ selectionView: SelectionView) -> UIFont
}

@objc protocol SelectionViewDelegate: AnyObject {
    
    @objc optional func didSelected(_ selectionView: SelectionView, index: Int)
    
    @objc optional func enable(_ selectionView: SelectionView, index: Int) -> Bool
}

extension SelectionViewDataSource {
    
    func numberOfSelections(_ selectionView: SelectionView) -> Int {
        return 2
    }
    
    func colorOfIndicatorView(_ selectionView: SelectionView) -> UIColor {
        return CustomColor.LemonadeYellow
    }
    
    func colorOfSelectionText(_ selectionView: SelectionView) -> UIColor {
        return .blue
    }
    
    func fontOfText(_ selectionView: SelectionView) -> UIFont {
        return .systemFont(ofSize: 18)
    }
}
