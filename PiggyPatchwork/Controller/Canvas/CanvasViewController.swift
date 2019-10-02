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
    
    @IBOutlet weak var backToPreviewBtn: UIButton! 
    
    @IBOutlet weak var editCompleteBtn: UIButton!
    
    var storageImage: UIImage?
    
    let canvas = Canvas()
    
    let strokeColorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
    
    let strokeWidthSlider = UISlider()
    
    let paletteImageView = UIImageView()
    
    let thicknessImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasImageView.image = storageImage
        
        setupCanvas(canvas: canvas, on: canvasImageView)
        
        setupColorSlider()
        
        setupWidthSlider()
        
        setupPaletteImage()
        
        setupThicknessImage()
        
        setupButtons()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.delegate = self
        
        Gradient.doubleColor(at: view,
                             firstColor: CustomColor.PigletPink,
                             secondColor: CustomColor.OrchidPink)
    }
    
    
    func setupButtons() {
        
        backToPreviewBtn.setupNavigationBtn()
        
        editCompleteBtn.setupNavigationBtn()
        
    }
    
    func setupCanvas(canvas: Canvas, on view: UIView) {
        
        canvas.backgroundColor = .clear
        
        canvas.frame = view.frame
        
        view.addSubview(canvas)
    }
    
    func setupColorSlider() {
        
        view.addSubview(strokeColorSlider)
        
        strokeColorSlider.addTarget(self,
                                    action: #selector(changedStrokeColor(slider:)),
                                    for: .valueChanged)
        
        let inset = CGFloat(25 * UIScreen.screenHeightRatio)
        
        strokeColorSlider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            strokeColorSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset * 1.5),
            strokeColorSlider.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -inset),
            strokeColorSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset * 1.5),
            strokeColorSlider.heightAnchor.constraint(equalToConstant: 15)
            ])
    }
    
    @objc func changedStrokeColor(slider: ColorSlider) {
        
        canvas.setStrokeColor(color: slider.color)
    }
    
    func setupWidthSlider() {
        
        view.addSubview(strokeWidthSlider)
        
        strokeWidthSlider.addTarget(self,
                              action: #selector(changedStrokeWidth(slider:)),
                              for: .valueChanged)
        
        strokeWidthSlider.minimumValue = 1
        strokeWidthSlider.maximumValue = 50
        
        strokeWidthSlider.minimumTrackTintColor = .black
        strokeWidthSlider.maximumTrackTintColor = .black
        
        let inset = CGFloat(25 * UIScreen.screenHeightRatio)
        
        strokeWidthSlider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            strokeWidthSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            strokeWidthSlider.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: inset),
            strokeWidthSlider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset * 1.5),
            strokeWidthSlider.centerYAnchor.constraint(equalTo: strokeColorSlider.centerYAnchor)
            ])
    }
    
    @objc func changedStrokeWidth(slider: UISlider) {
        
        canvas.setStrokeWidth(width: slider.value)
    }
    
    func setupPaletteImage() {
        
        view.addSubview(paletteImageView)
        
        paletteImageView.image = UIImage.asset(.palette)
        
        let inset = CGFloat(10 * UIScreen.screenHeightRatio)
        
        let imageSideLenth = CGFloat(40 * UIScreen.screenHeightRatio)
        
        paletteImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            paletteImageView.centerXAnchor.constraint(equalTo: strokeColorSlider.centerXAnchor),
            paletteImageView.bottomAnchor.constraint(equalTo: strokeColorSlider.topAnchor, constant: -inset),
            paletteImageView.widthAnchor.constraint(equalToConstant: imageSideLenth),
            paletteImageView.heightAnchor.constraint(equalToConstant: imageSideLenth)
        ])
    }
    
    func setupThicknessImage() {

        view.addSubview(thicknessImageView)
        
        thicknessImageView.image = UIImage.asset(.thickness)

        let imageSideLenth = CGFloat(30 * UIScreen.screenWidthRatio)
        
        thicknessImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thicknessImageView.centerXAnchor.constraint(equalTo: strokeWidthSlider.centerXAnchor),
            thicknessImageView.centerYAnchor.constraint(equalTo: paletteImageView.centerYAnchor),
            thicknessImageView.widthAnchor.constraint(equalToConstant: imageSideLenth),
            thicknessImageView.heightAnchor.constraint(equalToConstant: imageSideLenth)
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
