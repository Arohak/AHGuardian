//
//  ASFeedTableCell.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import AsyncDisplayKit

final class ASFeedTableCell: ASCellNode {

    fileprivate var thumbImageView: ASNetworkImageNode!
    fileprivate var categoryLabel: ASTextNode!
    fileprivate var titleLabel: ASTextNode!
    fileprivate var tagButtons: [ASButtonNode] = []
    var selectButton: ASButtonNode!

    init(with item: FeedViewModelType) {
        super.init()

        setup(with: item)
        automaticallyManagesSubnodes = true
    }

    fileprivate func createLayerTextNode(with string: String, font: UIFont) -> ASTextNode {
        let node = ASTextNode()
        node.isLayerBacked = true
        let color = UIColor.white
        node.attributedText = NSAttributedString(string: string, attributes: [.font: font, .foregroundColor: color])

        return node
    }
    
    fileprivate func createButtonNode(with string: String, font: UIFont) -> ASButtonNode {
        let node = ASButtonNode()
        let title = " " + string + " "
        let fColor = UIColor.white
        let bColor = UIColor.gray
        node.setAttributedTitle(NSAttributedString(string: title, attributes: [.font: font, .foregroundColor: fColor, .backgroundColor: bColor]), for: .normal)
        
        return node
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let inset: CGFloat = max_inset

        let oneStack = ASStackLayoutSpec.vertical()
        oneStack.style.flexShrink = 1.0
        oneStack.style.flexGrow = 1.0
        
        selectButton.style.preferredSize = CGSize(width: 2*inset, height: 3*inset)

        oneStack.children = [categoryLabel, titleLabel]
        
        thumbImageView.style.preferredSize = CGSize(width: table_img_height, height: table_img_height)
        
        let imageInsets = UIEdgeInsets(top: min_inset, left: min_inset, bottom: min_inset, right: min_inset)
        let imageInset = ASInsetLayoutSpec(insets: imageInsets, child: thumbImageView)
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let twoStack = ASStackLayoutSpec.horizontal()
        twoStack.alignItems = ASStackLayoutAlignItems.center
        twoStack.justifyContent = ASStackLayoutJustifyContent.start
        twoStack.children = [imageInset, oneStack]
        
        selectButton.style.preferredSize = CGSize(width: 2*inset, height: 3*inset)
        selectButton.style.layoutPosition = CGPoint(x: constrainedSize.max.width - (2*inset + 5), y: 5)
  
        let buttonInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let count = 3
        let specsCount = ceil(Double(tagButtons.count)/Double(count))
        var tagButtonSpecs = Array(repeating: Array<ASInsetLayoutSpec>(), count: Int(specsCount))
        tagButtonSpecs.enumerated().forEach { (i, tagButtonSpec) in
            for index in i*count..<(i + 1)*count {
                if index < tagButtons.count {
                    let buttonSpec = ASInsetLayoutSpec(insets:buttonInset, child: tagButtons[index])
                    tagButtonSpecs[i].append(buttonSpec)
                }
            }
        }
        
        var tagSpecs = Array<ASStackLayoutSpec>()
        tagButtonSpecs.enumerated().forEach { (i, tagButtonSpec) in
            let spec = ASStackLayoutSpec.horizontal()
            spec.children = tagButtonSpec
            tagSpecs.append(spec)
        }
        
        let tagStack = ASStackLayoutSpec.vertical()
        tagStack.alignItems = ASStackLayoutAlignItems.center
        tagStack.justifyContent = ASStackLayoutJustifyContent.start
        tagStack.children = tagSpecs

        let threeStack = ASStackLayoutSpec.vertical()
        threeStack.alignItems = ASStackLayoutAlignItems.center
        threeStack.justifyContent = ASStackLayoutJustifyContent.start
        threeStack.children = [twoStack, tagStack]
        
        let absoluteSpec = ASAbsoluteLayoutSpec(children: [threeStack, selectButton])
        absoluteSpec.sizing = .sizeToFit
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0), child: absoluteSpec)
    }
}

extension ASFeedTableCell {

    func setup(with item: FeedViewModelType) {
        thumbImageView = ASNetworkImageNode()
        thumbImageView.shouldRenderProgressImages = true
        thumbImageView.cornerRadius = table_img_height/2
        thumbImageView.clipsToBounds = true
        thumbImageView.url = item.image
        
        categoryLabel = createLayerTextNode(with: item.category, font: UIFont.boldSystemFont(ofSize: 16))
        titleLabel = createLayerTextNode(with: item.title, font: UIFont.systemFont(ofSize: 12))

        selectButton = ASButtonNode()
        selectButton.setBackgroundImage(UIImage(named: "img_favorit_select"), for: .normal)
        selectButton.setBackgroundImage(UIImage(named: "img_favorit_deselect"), for: .selected)
        selectButton.isSelected = item.isSelected
        
        for tag in item.tags {
            let button = createButtonNode(with: tag, font: UIFont.systemFont(ofSize: 14))
            tagButtons.append(button)
        }
    }
}

