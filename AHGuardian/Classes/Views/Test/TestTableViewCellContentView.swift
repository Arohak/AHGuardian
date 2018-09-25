
import UIKit
import PureLayout

final class TestTableViewCellContentView: UIView {
    var topInset: NSLayoutConstraint?
    var sublayer = CALayer()

    lazy var thumbImageView: UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = table_img_height/2
        
        return view
    }()

    lazy var bgView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10

        return view
    }()
    
    lazy var textLabel: UILabel = {
        let view = UILabel.newAutoLayout()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .white
        view.textAlignment = .left
        view.numberOfLines = 0
        
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let view = UILabel.newAutoLayout()
        view.font = .systemFont(ofSize: 10)
        view.textColor = .gray
        view.textAlignment = .left
        view.numberOfLines = 0
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TestTableViewCellContentView: ViewConfiguration {
    
    func configureViews() {
        backgroundColor = bg_color
    }
    
    func buildViewHierarchy() {
        addSubview(bgView)
        addSubview(textLabel)
        addSubview(timeLabel)
    }
    
    func setupConstraints() {
        let inset: CGFloat = max_inset
        
//        thumbImageView.autoPinEdge(toSuperviewEdge: .top, withInset: inset)
//        thumbImageView.autoPinEdge(toSuperviewEdge: .left, withInset: inset)
//        thumbImageView.autoSetDimensions(to: CGSize(width: width, height: width))

        bgView.autoPinEdge(.top, to: .top, of: textLabel, withOffset: -inset/2)
        bgView.autoPinEdge(.left, to: .left, of: textLabel, withOffset: -inset/2)
        bgView.autoPinEdge(.right, to: .right, of: textLabel, withOffset: inset/2)
        bgView.autoPinEdge(.bottom, to: .bottom, of: timeLabel, withOffset: inset/2)

        textLabel.autoPinEdge(toSuperviewEdge: .top, withInset: inset)
        textLabel.autoMatch(.width, to: .width, of: self, withMultiplier: 0.7)
        textLabel.autoPinEdge(toSuperviewEdge: .right, withInset: inset)
        
        topInset = timeLabel.autoPinEdge(.top, to: .bottom, of: textLabel, withOffset: -inset)
        timeLabel.autoPinEdge(toSuperviewEdge: .right, withInset: inset)
        timeLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: inset)
    }
}

extension TestTableViewCellContentView {
    
    func setup(with item: FeedViewModelType) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let time = dateFormatter.string(from: Date())
        timeLabel.attributedText = NSAttributedString(string: time)

        setAttributedText(with: item.title)
        thumbImageView.download(image: item.image)

        setTopInset(with: item.title, and: time)
    }
}

extension TestTableViewCellContentView {

    fileprivate func setTopInset(with title: String, and time: String) {
        let widht = Screen.width * 0.7
        let timeWidth = time.widthOfString(usingFont: .systemFont(ofSize: 10))
        guard let last = title.split(separator: " ").last,
            let rect = getBoundingRect(for: textLabel, with: String(last)) else {
            return
        }
        let result = rect.origin.x + rect.size.width + max_inset
        let freeSpace = widht - result
        topInset?.constant = freeSpace < timeWidth || freeSpace < 0 ? max_inset/4 : -max_inset
        print("result = \(result), timeWidth = \(timeWidth), freeSpace = \(freeSpace)\n")
    }

    fileprivate func setAttributedText(with string: String) {
        let attributes : [NSAttributedStringKey : Any] = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 12.0),
            NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : UIColor.white
        ]
        let attributedText = NSAttributedString(string: string, attributes: attributes)
        textLabel.attributedText = attributedText
    }

    fileprivate func getBoundingRect(for label: UILabel, with string: String) -> CGRect? {
        guard let text = label.text, let stringRange = text.range(of: string) else {
            return nil
        }
        let rect = label.boundingRect(for: NSRange(stringRange, in: text))
//        if sublayer.superlayer != label.layer {
//            sublayer.borderWidth = 1
//            sublayer.frame = rect!
//            label.layer.addSublayer(sublayer)
//        }
        return rect
    }
}

extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}

extension UILabel {
    func boundingRect(for range: NSRange) -> CGRect? {
        guard let attributedText = attributedText else { return nil }
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0.0
        layoutManager.addTextContainer(textContainer)
        var glyphRange = NSRange()
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)

        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
}
