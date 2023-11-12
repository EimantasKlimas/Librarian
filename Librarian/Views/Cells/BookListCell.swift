import UIKit

public final class BookListCell: UITableViewCell {  
    private let padding: CGFloat = Constants.Styling.padding

    private lazy var listId: Int? = nil
    private lazy var buttonAction: ((Int) -> Void)? = nil
    private lazy var storedCovers: [UIImageView] = []
    
    private lazy var bookStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = Constants.Styling.stackSpacing
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = Constants.Styling.appColor.cgColor
        view.layer.borderWidth = Constants.Styling.thickBorder
        view.layer.cornerRadius = Constants.Styling.cornerRadius
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
    
    private lazy var allButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.Text.button, for: .normal)
        button.setTitleColor(Constants.Styling.appColor, for: .normal)
        button.titleEdgeInsets = Constants.Styling.buttonInset
        button.layer.borderColor = Constants.Styling.appColor.cgColor
        button.layer.borderWidth =  Constants.Styling.thinBorder
        
        return button
    }()
        
    public func setup(
        with list: BookList,
        and associatedBooks: Books,
        _ buttonAction: @escaping (Int) -> Void
    ) {
        self.listId = list.id
        self.buttonAction = buttonAction
        
        setupView()
        setupLabel(with: list.title)
        setupAllButton()
        setupScrollView()
        setupBookStackView(with: associatedBooks)
    }
    
    public override func prepareForReuse() {
        storedCovers.forEach { coverView in
            coverView.image = UIImage(named: Constants.Resoure.defaultCover)
        }
    }
}

private extension BookListCell {
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
    
    func setupLabel(with title: String) {
        containerView.addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding)
        ])
    }
    
    func setupAllButton() {
        containerView.addSubview(allButton)
        
        NSLayoutConstraint.activate([
            allButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            allButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            allButton.widthAnchor.constraint(equalToConstant: Constants.Styling.buttonHeight)
        ])
        
        allButton.addTarget(self, action: #selector(didTapAllButton), for: .touchUpInside)
    }
    
    func setupScrollView() {
        containerView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            scrollView.topAnchor.constraint(equalTo: allButton.bottomAnchor, constant: padding)
        ])
    }
    
    func setupBookStackView(with associatedBooks: Books) {
        scrollView.addSubview(bookStackView)
        
        NSLayoutConstraint.activate([
            bookStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            bookStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            bookStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            bookStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
      
        if !bookStackView.subviews.isEmpty {
            bookStackView.subviews.forEach { subview in
                bookStackView.removeArrangedSubview(subview)
            }
        }
        
        for bookIndex in associatedBooks.indices {
            guard let book = associatedBooks[safe: bookIndex] else {
                continue
            }
            
            let bookCoverView = UIImageView(image: UIImage(named: Constants.Resoure.defaultCover))
            bookCoverView.translatesAutoresizingMaskIntoConstraints = false

            
            NSLayoutConstraint.activate([
                bookCoverView.heightAnchor.constraint(equalToConstant: Constants.Styling.coverHeight),
                bookCoverView.widthAnchor.constraint(equalToConstant: Constants.Styling.coverWidth)
            ])

            Task {
                let image = try await bookCoverView.load(from: book.image)
                UIView.transition(
                    with: bookCoverView,
                    duration: 1.0,
                    options: .transitionCrossDissolve,
                    animations: {
                        bookCoverView.image = image
                    },
                    completion: nil
                )
            }
            
            bookStackView.insertArrangedSubview(bookCoverView, at: bookIndex)
            storedCovers.append(bookCoverView)
        }
    }
    
    @objc
    func didTapAllButton() {
        guard let buttonAction, let listId else {
            return
        }
        buttonAction(listId)
    }
}
