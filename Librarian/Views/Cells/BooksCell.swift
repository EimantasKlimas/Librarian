import UIKit

public final class BooksCell: UITableViewCell {
    private let padding: CGFloat = Constants.Styling.padding
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = Constants.Styling.appColor.cgColor
        view.layer.borderWidth = Constants.Styling.thickBorder
        view.layer.cornerRadius = Constants.Styling.cornerRadius
        return view
    }()
    
    private lazy var coverView: UIImageView = {
        let view = UIImageView(image: UIImage(named: Constants.Resoure.defaultCover))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = .zero
        label.textColor = Constants.Styling.appColor
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(Constants.Styling.subtitleFontSize)
        label.numberOfLines = .zero
        label.textColor = Constants.Styling.appColor
        
        return label
    }()
        
    public func setup(
        with book: BookWithDetail
    ) {
        setupView()
        setupCoverView(with: book.image)
        setupLabels(with: book.title, and: book.author)
    }
    
    public override func prepareForReuse() {
        titleLabel.text = nil
        authorLabel.text = nil
        coverView.image = UIImage(named: Constants.Resoure.defaultCover)
    }
}

private extension BooksCell {
    func setupView() {
        contentView.addSubview(containerView)
        contentView.backgroundColor = .clear
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    func setupCoverView(with image: String) {
        containerView.addSubview(coverView)
        
        NSLayoutConstraint.activate([
            coverView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            coverView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            coverView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            coverView.heightAnchor.constraint(equalToConstant: Constants.Styling.coverHeight),
            coverView.widthAnchor.constraint(equalToConstant: Constants.Styling.coverWidth)
        ])
        
        Task {
            let image = try await coverView.load(from: image)
            UIView.transition(
                with: coverView,
                duration: 1.0,
                options: .transitionCrossDissolve,
                animations: { [weak self] in
                    guard let self else {
                        return
                    }
                    self.coverView.image = image
                },
                completion: nil
            )
        }
    }
    
    func setupLabels(with title: String, and author: String) {
        containerView.addSubview(titleLabel)
        containerView.addSubview(authorLabel)
        titleLabel.text = title
        authorLabel.text = author
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding)
        ])
    }
}
