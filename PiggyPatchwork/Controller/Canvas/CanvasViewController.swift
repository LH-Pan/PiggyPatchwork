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
    
    let widthSlider = UISlider()
    
    let palette = UIImageView()
    
    let thickness = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasImageView.image = storageImage
        
        setupCanvas(canvas: canvas, on: canvasImageView)
        
        setupColorSlider()
        
        setupWidthSlider()
        
        setupPaletteImage()
        
        setupThicknessImage()

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
    
    func setupColorSlider() {
        
        view.addSubview(colorSlider)
        
        colorSlider.addTarget(self,
                              action: #selector(changedStrokeColor(slider:)),
                              for: .valueChanged)
        
        let inset = CGFloat(25 / 896 * UIScreen.height)
        
        colorSlider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset * 1.5),
            colorSlider.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -inset),
            colorSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset * 1.5),
            colorSlider.heightAnchor.constraint(equalToConstant: 15)
            ])
    }
    
    @objc func changedStrokeColor(slider: ColorSlider) {
        
        canvas.setStrokeColor(color: slider.color)
    }
    
    func setupWidthSlider() {
        
        view.addSubview(widthSlider)
        
        widthSlider.addTarget(self,
                              action: #selector(changedStrokeWidth(slider:)),
                              for: .valueChanged)
        
        widthSlider.minimumValue = 1
        widthSlider.maximumValue = 50
        widthSlider.minimumTrackTintColor = .black
        widthSlider.maximumTrackTintColor = .black
        
        let inset = CGFloat(25 / 896 * UIScreen.height)
        
        widthSlider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            widthSlider.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: inset),
            widthSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset * 1.5),
            widthSlider.heightAnchor.constraint(equalToConstant: 15 / 896 * UIScreen.height)
            ])
        
    }
    
    @objc func changedStrokeWidth(slider: UISlider) {
        
        canvas.setStrokeWidth(width: slider.value)
    }
    
    func setupPaletteImage() {
        
        view.addSubview(palette)
        
        palette.image = UIImage.asset(.palette)
        
        let inset = CGFloat(10 / 896 * UIScreen.height)
        
        let imageSideLenth = CGFloat(40 / 896 * UIScreen.height)
        
        palette.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            palette.centerXAnchor.constraint(equalTo: colorSlider.centerXAnchor),
            palette.bottomAnchor.constraint(equalTo: colorSlider.topAnchor, constant: -inset),
            palette.widthAnchor.constraint(equalToConstant: imageSideLenth),
            palette.heightAnchor.constraint(equalToConstant: imageSideLenth)
            ])
    }
    
    func setupThicknessImage() {
        
        view.addSubview(thickness)
        
        thickness.image = UIImage.asset(.thickness)

        let imageSideLenth = CGFloat(30 / 414 * UIScreen.width)
        
        thickness.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thickness.centerXAnchor.constraint(equalTo: widthSlider.centerXAnchor),
            thickness.centerYAnchor.constraint(equalTo: palette.centerYAnchor),
            thickness.widthAnchor.constraint(equalToConstant: imageSideLenth),
            thickness.heightAnchor.constraint(equalToConstant: imageSideLenth)
            ])
        
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
