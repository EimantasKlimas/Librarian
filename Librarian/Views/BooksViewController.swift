import UIKit

protocol BooksViewInteracting: AnyObject {
    func startedUpdate()
    func didUpdate()
}
final class BooksViewController: UIViewController {
    
    private let viewModel: BooksViewModel
    
    lazy var refreshControl = {
        let control = UIRefreshControl()
        control.translatesAutoresizingMaskIntoConstraints = false

        return control
    }()
    
    lazy var tableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(BooksCell.self, forCellReuseIdentifier: "bookCell")
        view.rowHeight = UITableView.automaticDimension
        view.dataSource = self.viewModel.datasource
        view.delegate = self.viewModel.datasource
        view.backgroundColor = .clear
        view.separatorStyle = .none
        
        return view
    }()
    
    init(
        booksViewModel: BooksViewModel
    ) {
        self.viewModel = booksViewModel
        
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshControl.didMoveToSuperview()
    }
}

private extension BooksViewController {
    func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.Styling.padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        viewModel.refreshBooks()
    }
}

extension BooksViewController: BooksViewInteracting {
    func startedUpdate() {
        refreshControl.beginRefreshing()
    }
    
    func didUpdate() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}
