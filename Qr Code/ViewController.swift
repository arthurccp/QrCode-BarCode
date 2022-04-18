//
//  ViewController.swift
//  Qr Code
//
//  Created by Arthur Silva on 14/04/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var dataField: UITextField!
    @IBOutlet weak var codeSelector: UISegmentedControl!
    @IBOutlet weak var DisplayCodeView: UIImageView!
    @IBOutlet weak var shareOutlet: UIButton!
    
    private var image: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.DisplayCodeView.image = self.image
            }
        }
    }
    
    fileprivate enum Options: Int, CaseIterable {
        case barcode = 0
        case qrcode = 1
    }
    
    fileprivate enum OptionsName: String, CaseIterable {
        case barcode = "CICode128BarcodeGenerator"
        case qrcode = "CIQRCodeGenerator"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareOutlet.isHidden = true
        dataField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func didChangeOption(_ sender: Any) {
        generateImage()
    }
    
    private func generateImage() {
        guard let selectedOption =  Options(rawValue: codeSelector.selectedSegmentIndex) else { return }
        switch selectedOption {
        case .barcode:
            showCodeBy(name: .barcode)
            shareOutlet.setTitle("Compartilhar barcode", for: .normal)
            break
        case .qrcode:
            showCodeBy(name: .qrcode)
            shareOutlet.setTitle("Compartilhar qrcode", for: .normal)
            break
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [self.DisplayCodeView.image],
                                                  applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true,completion: nil)
    }

    
    @IBAction func generate(_ sender: UIButton) {
        
        
        //            if let text = dataField.text{
        //            let data = text.data(using: .ascii, allowLossyConversion: false)
        //
        //            if codeSelector.selectedSegmentIndex == 0 {
        //                 filter = CIFilter(name: "CICode128BarcodeGenerator")
        //            }
        //            if codeSelector.selectedSegmentIndex == 1 {
        //                filter = CIFilter(name: "CIQRCodeGenerator")
        //            }
        //            filter.setValue(data, forKey: "inputMessage")
        //            showCode()
        //        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        generateImage()
    }
    
    fileprivate func showCodeBy(name: OptionsName) {
        guard let text = dataField.text else { return }
        guard let data = text.data(using: .ascii, allowLossyConversion: false) else  { return }
        let filter = CIFilter(name: name.rawValue)
        let context = CIContext()
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        if let output = filter?.outputImage?.transformed(by: transform) {
            if let retImg = context.createCGImage(output, from: output.extent) {
                image =  UIImage(cgImage: retImg)
            }
        }
        shareOutlet.isHidden = false
    }
    
}
