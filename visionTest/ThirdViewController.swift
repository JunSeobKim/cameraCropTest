//
//  ThirdViewController.swift
//  visionTest
//
//  Created by 김준섭 on 2023/07/21.
//

import UIKit

class ThirdViewController: UIViewController {
    
    var imageStr: UIImage?

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ThirdVC")
        setUI()
    }
    
    func setUI() {
        if let imageStr = self.imageStr {
            self.image.image = imageStr
//            self.image.transform = self.image.transform.rotated(by: .pi/2)
        }
    }
}
