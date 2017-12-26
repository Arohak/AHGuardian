//
//  TagsLabel.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit

class TagsLabel: UILabel {
    
    open var tags: [Tag]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
        self.setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = .left
        self.isUserInteractionEnabled = true
    }
    
    private func setupGesture() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(TagsLabel.tap(recognizer:)))
        self.addGestureRecognizer(recognizer)
    }
    
    @objc private func tap(recognizer: UITapGestureRecognizer) {
        guard let label = recognizer.view as? UILabel else {
            return
        }
        let container = NSTextContainer(size: label.frame.size)
        container.lineFragmentPadding = 0.0
        container.lineBreakMode = label.lineBreakMode
        container.maximumNumberOfLines = label.numberOfLines
        
        let manager = NSLayoutManager()
        manager.addTextContainer(container)
        
        guard let attributedText = label.attributedText else {
            return
        }
        let storage = NSTextStorage(attributedString: attributedText)
        storage.addLayoutManager(manager)
        
        let touchPoint = recognizer.location(in: label)
        let indexOfCharacter = manager.characterIndex(for: touchPoint,
                                                      in: container,
                                                      fractionOfDistanceBetweenInsertionPoints: nil)
        guard var tags = self.tags else {
            return
        }
        var tag = tags[indexOfCharacter]
        tag.enabled = !tag.enabled
        tags[indexOfCharacter] = tag
        self.setTags(tags)
    }
    
    open func setTags(_ strings: [String], color: UIColor = UIColor.red) {
        let tags = strings.map { (value) -> Tag in
            let dict = Tag(title: value, color: color)
            return dict
        }
        
        setTags(tags)
    }
    
    open func setTags(_ tags: [Tag]) {
        self.tags = tags
        
        let mutableString = NSMutableAttributedString()
        let cell = UITableViewCell()
        for (_, tag) in tags.enumerated() {
            let view = TagView()
            view.label.attributedText = tag.attributedTitle()
            view.label.backgroundColor = tag.enabled ? tag.color : UIColor.lightGray
            let size = view.systemLayoutSizeFitting(view.frame.size,
                                                    withHorizontalFittingPriority: UILayoutPriority.fittingSizeLevel,
                                                    verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
            view.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: size.height)
            cell.contentView.addSubview(view)
            
            let image = view.image()
            let attachment = NSTextAttachment()
            attachment.image = image
            
            let attrString = NSAttributedString(attachment: attachment)
            mutableString.beginEditing()
            mutableString.append(attrString)
            mutableString.endEditing()
        }
        
        self.attributedText = mutableString
    }
}

extension TagsLabel {
    
    class TagView: UIView {
        
        lazy var label = { () -> UILabel in
            let label = UILabel()
            label.textColor = UIColor.white
            label.translatesAutoresizingMaskIntoConstraints = false
            label.layer.cornerRadius = 8
            label.layer.masksToBounds = true
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.setupViews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        private func setupViews() {
            self.backgroundColor = bg_color
            self.addSubview(self.label)
            self.setupConstraints()
        }
        
        private func setupConstraints() {
            var constraints = [NSLayoutConstraint]()
            constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-4.0-[label]-4.0-|",
                                                                          options: .directionLeadingToTrailing,
                                                                          metrics: nil,
                                                                          views: ["label" : self.label]))
            constraints.append(NSLayoutConstraint(item: self.label,
                                                  attribute: .height,
                                                  relatedBy: .greaterThanOrEqual,
                                                  toItem: nil,
                                                  attribute: .height,
                                                  multiplier: 1,
                                                  constant: 24))
            constraints.append(NSLayoutConstraint(item: self.label,
                                                  attribute: .top,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .top,
                                                  multiplier: 1,
                                                  constant: 6))
            constraints.append(NSLayoutConstraint(item: self,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: self.label,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: 6))
            NSLayoutConstraint.activate(constraints)
        }
        
        
        open func image() -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
            guard let context = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: context)
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
                return nil
            }
            UIGraphicsEndImageContext()
            return image
        }
    }
}

struct Tag {
    
    var title: String
    var color: UIColor
    var category: String?
    var url: URL?
    var enabled: Bool = false
    
    init(title: String, color: UIColor) {
        self.title = title
        self.color = color
    }
    
    init(dictionary: [String : Any]) {
        var value: UInt32 = 0
        let scanner = Scanner(string: (dictionary["COLOR"] as! String))
        scanner.scanHexInt32(&value)
        let color = UIColor(red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat(value & 0x0000FF) / 255.0,
                            alpha: 1.0)
        self.color = color
        self.category = (dictionary["CATEGORY"] as? String)
        self.title = (dictionary["TITLE"] as! String)
        self.url = URL(string: (dictionary["URL"] as! String))
        self.enabled = (dictionary["ENABLED"] as! Bool)
    }
    
    func attributedTitle() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        if #available(iOS 11.0, *) {
            paragraphStyle.headIndent = paragraphStyle.firstLineHeadIndent
            paragraphStyle.tailIndent = paragraphStyle.firstLineHeadIndent
        } else {
            paragraphStyle.firstLineHeadIndent = 10
            paragraphStyle.headIndent = 10
            paragraphStyle.tailIndent = 10
        }
        
        let attributes = [
            NSAttributedStringKey.paragraphStyle  : paragraphStyle,
            NSAttributedStringKey.font            : UIFont.boldSystemFont(ofSize: 14)
        ]
        return NSAttributedString(string: self.title, attributes: attributes)
    }
}
