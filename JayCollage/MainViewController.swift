//
//  ViewController.swift
//  JayCollage
//
//  Created by Jaycee on 2019/12/30.
//  Copyright © 2019 Jaycee. All rights reserved.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    
    private let bag = DisposeBag()
    private let images = Variable<[UIImage]>([])
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var itemAdd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient()
        
        images.asObservable()
            .subscribe(onNext: { [weak self] photos in
                guard let preview = self?.imagePreview else { return }
                preview.image = UIImage.collage(images: photos,
                                                size: preview.frame.size)
            })
            .disposed(by: bag)
        
        images.asObservable()
            .subscribe(onNext: { [weak self] photos in
                self?.updateUI(photos: photos)
            })
            .disposed(by: bag)
    }
    
    
    private func updateUI(photos: [UIImage]) {
        //        buttonSave.isEnabled = photos.count > 0 && photos.count % 2 == 0
        buttonClear.isEnabled = photos.count > 0
        //        itemAdd.isEnabled = photos.count < 6
        title = photos.count > 0 ? "Photos \(photos.count)" : "Photo Collage"
        infoLabel.isHidden = photos.count > 0
        
    }
    
    
    @IBAction func actionRotate() {
        images.asObservable()
            .subscribe(onNext: { [weak self] photos in
                guard let preview = self?.imagePreview else { return }
                preview.image = UIImage.rotateCollage(images: photos,
                                                      size: preview.frame.size)
                preview.contentMode = .scaleAspectFit
            })
            .disposed(by: bag)
    }
    
    @IBAction func actionClear() {
        print("dd3")
        
        images.value = []
    }
    
    
    
    @IBAction func actionSave() {
        print("d2d")
        
        guard let image = imagePreview.image else { return }
        
        PhotoWriter.save(image)
            .subscribe(onSuccess: { [weak self] id in
                self?.showMessage("Saved with id: \(id)")
                self?.actionClear()
            }) { [weak self] error in
                self?.showMessage("Error", description: error.localizedDescription)
        }.disposed(by: bag)
    }
    
    @IBAction func actionAdd() {
        print("dd")
        let photosViewController = storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController
        photosViewController.selectedPhotos
            .subscribe(onNext: { [weak self] newImage in
                guard let images = self?.images else { return }
                images.value.append(newImage)
                }, onDisposed: {
                    print("completed photo selection")
            })
            .disposed(by: bag)
        navigationController?.pushViewController(photosViewController, animated: true)
    }
    
    func showMessage(_ title: String, description: String? = nil) {
        alert(title: title, text: description)
            .subscribe()
            .disposed(by: bag)
    }
    
    func setGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = view.layer.frame
        view.layer.insertSublayer(gradient, at: 0)
    }
}



