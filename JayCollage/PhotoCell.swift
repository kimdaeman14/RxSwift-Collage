//
//  PhotoCell.swift
//  JayCollage
//
//  Created by Jaycee on 2019/12/30.
//  Copyright © 2019 Jaycee. All rights reserved.
//


import UIKit

class PhotoCell: UICollectionViewCell {

  @IBOutlet var imageView: UIImageView!
  var representedAssetIdentifier: String!

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }

  func flash() {
    imageView.alpha = 0
    setNeedsDisplay()
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.imageView.alpha = 1
    })
  }
}
