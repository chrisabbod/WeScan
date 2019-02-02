//
//  ViewController.swift
//  WeScanExample
//
//  Created by Chris Abbod on 1/28/19.
//  Copyright © 2019 Chris Abbod. All rights reserved.
//

import UIKit
import WeScan

class ViewController: UIViewController, ImageScannerControllerDelegate {

    @IBOutlet weak var documentImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func scanButton(_ sender: Any) {
        let scannerViewController = ImageScannerController()
        scannerViewController.imageScannerDelegate = self
        present(scannerViewController, animated: true)
        print("SCAN BUTTON PRESSED!")
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        // You are responsible for carefully handling the error
        print(error)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // The user successfully scanned an image, which is available in the ImageScannerResults
        // You are responsible for dismissing the ImageScannerController
        
        //create image url
        let imageName: String = "scannedImage"
        let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
        let imageUrl: URL = URL(fileURLWithPath: imagePath)
        
        //store image url
        let newImage: UIImage = results.scannedImage // create your UIImage here
        try? newImage.pngData()?.write(to: imageUrl)
        
        loadImage(name: imageName)
        
        //documentImageView.image = results.scannedImage
        
        scanner.dismiss(animated: true)
    }
    
    func loadImage(name: String) {
        //declare where the image is stored
        let imageName = name // your image name here
        let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
        let imageUrl: URL = URL(fileURLWithPath: imagePath)
        
        //load the image
        guard FileManager.default.fileExists(atPath: imagePath),
            let imageData: Data = try? Data(contentsOf: imageUrl),//scale: allows for proper image scaling for non-retina devices
            let image: UIImage = UIImage(data: imageData, scale: UIScreen.main.scale) else {
                return // No image found!
        }
        
        //This line allows for proper scaling for non retina devices
        //image = UIImage(data: imageData, scale: UIScreen.main.scale)
        
        //set document image
        documentImageView.image = image
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // The user tapped 'Cancel' on the scanner
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
    }
    
}

