//
//  GalleryViewController.swift
//  CrazyAnimalsFlipCards
//
//  Created by Роман Кабиров on 08.11.17.
//  Copyright © 2017 Logical Mind. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var innnerView: UIView?
    var bigImage: UIImageView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeToBack))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(swipe)

        buildScene()
    }
    
    @objc func swipeToBack(sender: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    func buildScene() {
        innnerView?.removeFromSuperview()
        
        innnerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 32, height: self.view.frame.height - 32))
        innnerView?.backgroundColor = UIColor.clear
        
        let cardSize: CGFloat = ((innnerView?.frame.width)! / 3) - 11
        
        var index = 0
        
        // total 34 animals
        
        let totalRowsCount = 12
        
        let topLevel = UserDefaults.standard.integer(forKey: "topLevel") - 1

        var imgMaxCode = 0
        
        for i in 0..<Data.levels.count {
            if i >= topLevel {
                break
            }
            if i > 40 {
                break
            }
            let level = Data.levels[i]
            for c in level {
                if c > imgMaxCode {
                    imgMaxCode = c
                }
            }
        }
        
        for row in 0..<totalRowsCount {
            for col in 0..<3 {
                let x = (CGFloat(col) * cardSize) + CGFloat(col * 16)
                let y = (CGFloat(row) * cardSize) + CGFloat(row * 16)
                
                let rootFlipView = Ex2CardUIView(frame: CGRect(x: x, y: y, width: cardSize, height: cardSize))
                
                var imgName = "card-question"
                rootFlipView.imgName = ""

                if index < imgMaxCode {
                    imgName = "img\(index + 1)"
                    rootFlipView.imgName = imgName
                }
                
                if index >= 34 {
                    break
                }
                
                if rootFlipView.imgName == "" {
                    // break
                }
                
                let cardBack = createCard(0, 0, cardSize, imgName)

                let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
                rootFlipView.isUserInteractionEnabled = true
                rootFlipView.addGestureRecognizer(tap)
                
                rootFlipView.addSubview(cardBack)
                innnerView?.addSubview(rootFlipView)
                index += 1
            }
        }
        
        scrollView.contentInset.bottom = (cardSize * CGFloat(totalRowsCount)) + (16 * CGFloat(totalRowsCount))
        scrollView.addSubview(innnerView!)
        innnerView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height + scrollView.contentInset.bottom)
        
        // gameView.addSubview(innnerView!)
    }
    
    func createCard(_ x: CGFloat, _ y: CGFloat, _ size: CGFloat, _ imgName: String) -> UIImageView {
        let frame = CGRect(x: x, y: y, width: size, height: size)
        let card = UIImageView(frame: frame)
        card.image = UIImage(named: imgName)
        
        card.layer.masksToBounds = true
        card.layer.borderWidth = 2
        card.layer.borderColor = UIColor.white.cgColor
        card.layer.cornerRadius = 8
        
        return card
    }
    
    
    @objc func cardTapped(sender: UITapGestureRecognizer) {
        if bigImage != nil {
            bigImage?.removeFromSuperview()
            bigImage = nil
            return
        }

        let v = sender.view as! Ex2CardUIView
        if v.imgName == "" { return }
        
        let frame = CGRect(x: 10, y: (view.frame.height / 2) - (view.frame.width / 2), width: view.frame.width - 20, height: view.frame.width - 20)
        
        bigImage = UIImageView(frame: frame)
        
        bigImage?.image = UIImage(named: v.imgName!)
        bigImage?.layer.masksToBounds = true
        bigImage?.layer.borderWidth = 2
        bigImage?.layer.borderColor = UIColor.white.cgColor
        bigImage?.layer.cornerRadius = 8
        
        bigImage?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(bigImageTap))
        bigImage?.isUserInteractionEnabled = true
        bigImage?.addGestureRecognizer(tap)

        view.addSubview(bigImage!)
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.bigImage?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }

    @objc func bigImageTap(sender: UITapGestureRecognizer) {
        bigImage?.removeFromSuperview()
        bigImage = nil
    }
    
}

class Ex2CardUIView: UIView {
    var imgName: String?
}
