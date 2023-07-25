//
//  SecondViewController.swift
//  visionTest
//
//  Created by 김준섭 on 2023/07/20.
//

import UIKit
import AVFoundation
import Photos

protocol SecondViewControllerDelegate {
    func moveToThirdVC()
    func captureImage(image: UIImage)
}

class SecondViewController: UIViewController {
    
    // delegate
    var delegate: SecondViewControllerDelegate?

    // AVCaptureSession 및 기타 변수 선언
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var photoOutput: AVCapturePhotoOutput!
    var videoOutput: AVCaptureVideoDataOutput!
    
    // MARK: -- IBOutlet
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cardBorderView: UIView!
    
    // MARK: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setUI()
    }
    
    func setUI() {
        cardBorderView.layer.borderWidth = 3
        cardBorderView.layer.borderColor = UIColor.yellow.cgColor
        cardBorderView.backgroundColor = .clear
        cardBorderView.widthAnchor.constraint(equalTo: cameraView.widthAnchor, multiplier: 2 / 3).isActive = true
//        cardBorderView.widthAnchor.constraint(equalToConstant: cameraView.widthAnchor * 2 / 3).isActive = true
        cardBorderView.heightAnchor.constraint(equalTo: cardBorderView.widthAnchor, multiplier: 5 / 9).isActive = true
//        cardBorderView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        cardBorderView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    // MARK: -- IBAction
    // 촬영 버튼 동작 처리
    @IBAction func captureButtonTapped(_ sender: UIButton) {
        // 촬영 처리 및 인식 로직
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // 모달 닫기 버튼 동작 처리
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension SecondViewController: AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    // AVCaptureSession 설정 및 카메라 미리보기 레이어 생성
    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        captureSession.sessionPreset = .photo
        
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("카메라를 찾을 수 없습니다.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(input)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = .resizeAspectFill
            videoPreviewLayer?.frame = cameraView.layer.bounds
            cameraView.layer.addSublayer(videoPreviewLayer!)
            
            if let photoOutput = photoOutput, captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            photoOutput = AVCapturePhotoOutput()
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            // 실행
            DispatchQueue.global().async {
                self.captureSession?.startRunning()
            }
            
        } catch {
            print("카메라 설정 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    // 사진 촬영 완료 후 데이터 받는 메소드
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("didFinishProcessingPhoto")
        if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) {
            print("photoOutput")

            // crop 할 영역 좌표
            // width, height 바꿔서 좌표 지정해야함. width = 세로, height = 가로
            let exampleImage = UIImage(named: "exampleImage")
            let cropRect = CGRect(x: ((image.size.height / 2) - (image.size.width * 10 / 27) / 2) - 100, y: image.size.width / 6 + 50, width: image.size.width * 10 / 27, height: image.size.width * 2 / 3)

            // crop 메서드를 사용하여 이미지 crop
            let croppedImage = image.crop(toRect: cropRect)
            
            dismiss(animated: true) {
                self.delegate?.captureImage(image: croppedImage!)
            }
        }
    }
}

extension UIImage {
    // image crop
    func crop(toRect rect: CGRect) -> UIImage? {
            guard let cgImage = self.cgImage else { return nil }
            let scale = self.scale
            
            // 좌표값을 이미지의 scale에 맞게 조정
            let scaledRect = CGRect(x: rect.origin.x * scale,
                                    y: rect.origin.y * scale,
                                    width: rect.size.width * scale,
                                    height: rect.size.height * scale)
            
            // CGImage를 기준으로 crop
            if let croppedCGImage = cgImage.cropping(to: scaledRect) {
                let croppedImage = UIImage(cgImage: croppedCGImage, scale: scale, orientation: self.imageOrientation)
                return croppedImage
            }
            
            return nil
        }
}
