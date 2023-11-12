import UIKit

protocol BookDetailInteracting: AnyObject {
    func startedUpdate()
    func didUpdate()
}
final class BookDetailViewController: UIViewController {
    
    private let viewModel: BookDetailViewModel
    private let padding: CGFloat = Constants.Styling.padding
    
    lazy var refreshControl = {
        let control = UIRefreshControl()
        control.translatesAutoresizingMaskIntoConstraints = false

        return control
    }()
    
    private lazy var coverView: UIImageView = {
        let view = UIImageView(image: UIImage(named: Constants.Resoure.defaultCover))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = Constants.Styling.stackSpacing
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.getTitle()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = .zero
        label.font = .boldSystemFont(ofSize: Constants.Styling.titleFontSize)
        label.textColor = Constants.Styling.appColor.withAlphaComponent(1)
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.getAuthor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = .zero
        label.textColor = Constants.Styling.appColor
        
        return label
    }()
    
    private lazy var isbnLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.getISBN()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = .zero
        label.textColor = Constants.Styling.appColor
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.getDescription()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = .zero
        label.textColor = Constants.Styling.appColor
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.getPublicationDate()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = .zero
        label.textColor = Constants.Styling.appColor
        
        return label
    }()
        
    init(
        viewModel: BookDetailViewModel
    ) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupRefreshControl()
        setupCoverView()
        setupLabelStackView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshControl.didMoveToSuperview()
    }
}

private extension BookDetailViewController {
    func setupScrollView() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.Styling.padding),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupCoverView() {
        scrollView.addSubview(coverView)
        
        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: padding),
            coverView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            coverView.widthAnchor.constraint(equalToConstant: Constants.Styling.coverDetailWidth),
            coverView.heightAnchor.constraint(equalToConstant: Constants.Styling.coverDetailHeight)
        ])
        
        fetchCoverImage()
    }
    
    func setupRefreshControl() {
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    func setupLabelStackView() {
        scrollView.addSubview(labelStackView)
        
        [
            titleLabel,
            authorLabel,
            isbnLabel,
            dateLabel,
            descriptionLabel
        ].forEach { label in
            labelStackView.addArrangedSubview(label)
        }
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: coverView.bottomAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
        
        labelStackView.setCustomSpacing(20, after: dateLabel)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        viewModel.refreshBooks()
    }
}

extension BookDetailViewController: BookDetailInteracting {
    func fetchCoverImage() {
        Task {
            let image = try await coverView.load(from: viewModel.getImage())
            UIView.transition(
                with: coverView,
                duration: 1.0,
                options: .transitionCrossDissolve,
                animations: { [weak self] in
                    self?.coverView.image = image
                },
                completion: nil
            )
        }
    }
    
    func startedUpdate() {
        refreshControl.beginRefreshing()
    }
    
    func didUpdate() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            titleLabel.text = viewModel.getTitle()
            authorLabel.text = viewModel.getAuthor()
            isbnLabel.text = viewModel.getISBN()
            dateLabel.text = viewModel.getPublicationDate()
            descriptionLabel.text = viewModel.getDescription()
            
            fetchCoverImage()
            self.refreshControl.endRefreshing()
        }
    }
}
