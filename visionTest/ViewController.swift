//
//  ViewController.swift
//  visionTest
//
//  Created by 김준섭 on 2023/07/20.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openCustomCameraButtonTapped(_ sender: UIButton) {
        guard let customCameraVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else { return }
        customCameraVC.modalPresentationStyle = .fullScreen
        customCameraVC.delegate = self
        present(customCameraVC, animated: true, completion: nil)
    }
    
}

extension ViewController: SecondViewControllerDelegate {
    func captureImage(image: UIImage) {
        guard let thirdVC = self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as? ThirdViewController else { return }
        print(image)
        thirdVC.imageStr = image
        self.navigationController?.pushViewController(thirdVC, animated: true)
    }
    
    func moveToThirdVC() {
        guard let thirdVC = self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as? ThirdViewController else { return }
        self.navigationController?.pushViewController(thirdVC, animated: true)
    }
}
