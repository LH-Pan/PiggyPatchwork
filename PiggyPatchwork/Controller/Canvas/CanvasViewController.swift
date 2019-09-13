//
//  File.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/11.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import ColorSlider

protocol ImageProviderDelegate: AnyObject {
    
    func manager(_ viewController: CanvasViewController, didGet image: UIImage?)
}

class CanvasViewController: UIViewController {
    
    weak var delegate: ImageProviderDelegate?
    
    @IBOutlet weak var canvasImageView: UIImageView!
    
    @IBOutlet weak var canvasView: UIView!
    
    @IBOutlet weak var backToPreviewBtn: UIButton! {
        
        didSet {
            
            backToPreviewBtn.setTitleColor(.hexStringToUIColor(hex: CustomColorCode.OrchidPink),
                                           for: .normal)
            
            backToPreviewBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var editCompleteBtn: UIButton! {
        
        didSet {
            
            editCompleteBtn.setTitleColor(.hexStringToUIColor(hex: CustomColorCode.OrchidPink),
                                          for: .normal)
            
            editCompleteBtn.layer.cornerRadius = 10
        }
    }
    
    var storageImage: UIImage?
    
    let canvas = Canvas()
    
    let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasImageView.image = storageImage
        
        setupCanvas(canvas: canvas, on: canvasImageView)
        
        setupColorSliderConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.delegate = self
        
        Gradient.shared.doubleColor(at: view,
                                    firstColor: CustomColorCode.PigletPink,
                                    secondColor: CustomColorCode.OrchidPink)
    }
    
    func setupCanvas(canvas: Canvas, on view: UIView) {
        
        canvas.backgroundColor = .clear
        
        canvas.frame = view.frame
        
        view.addSubview(canvas)
    }
    
    func setupColorSliderConstraints() {
        
        view.addSubview(colorSlider)
        
        colorSlider.addTarget(self,
                              action: #selector(changedColor(slider:)),
                              for: .valueChanged)
        
        let inset = CGFloat(25 / 896) * UIScreen.height
        
        colorSlider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            colorSlider.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -inset),
            colorSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset * 1.5),
            colorSlider.heightAnchor.constraint(equalToConstant: 15)
            ])
    }
    
    @objc func changedColor(slider: ColorSlider) {
        
        canvas.setStrokeColor(color: slider.color)
    }

    @IBAction func cancelEdit(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editComplete(_ sender: Any) {
        
        storageImage = canvasView.takeSnapshot()
        
        delegate?.manager(self, didGet: storageImage)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func undo(_ sender: Any) {
        
        canvas.undo()
    }
    
    @IBAction func clearAll(_ sender: Any) {
        
        canvas.clear()
    }
}

extension CanvasViewController: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .pop {
            
            return PopTransition()
            
        } else {
            
            return nil
        }
    }
}
