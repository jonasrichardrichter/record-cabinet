//
//  AddRecordNavigationController.swift
//  Record Cabinet
//
//  Created by Jonas Richard Richter on 26.03.22.
//

import UIKit
import Logging
import CoreData

class AddRecordViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var contentSize: CGSize  = { [unowned self] in
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }()
    
    var selectImageButton: UIButton!
    var nameTextField: UITextField!
    var artistTextField: UITextField!
    var datePickerLabel: UILabel!
    var datePicker: UIDatePicker!
    
    var scrollView: UIScrollView!
    var containerView: UIView!
    
    var delegate: AddRecordDelegate?
    
    var container: NSPersistentContainer!
    var logger = Logger(for: "AddRecordViewController")
    
    // MARK: - NavigationItem Buttons
    
    lazy var leftBarButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "CANCEL".localized(), image: nil, primaryAction: UIAction(handler: { action in
            self.dismiss(animated: true)
        }), menu: nil)
    }()
    
    lazy var rightBarButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "ADD".localized(), image: nil, primaryAction: UIAction(handler: { action in
            self.logger.trace("Trying to add Record to Core Data.")
            self.addRecordButtonAction()
        }), menu: nil)
    }()
    
    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Core Data
        self.container = NSPersistentContainer(name: "Record_Cabinet")
        
        self.container.loadPersistentStores { storeDescription, error in
            if let error = error {
                self.logger.error("Unresolved error: \(error)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavbar()
        self.setupView()
    }
    
    // MARK: - View Setup
    
    func setupNavbar() {
        self.title = "ADD_RECORD_TITLE".localized()
        
        // Don't let the user dismiss the modal via swipe because that could lead to unwanted data loss
        self.isModalInPresentation = true
        
        self.navigationItem.leftItemsSupplementBackButton = false
        self.navigationItem.leftBarButtonItem = self.leftBarButton
        
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        self.navigationItem.rightBarButtonItem?.style = .done
        
    }
    
    func setupView() {
        self.view.backgroundColor = .systemBackground
        
        self.scrollView = UIScrollView(frame: .zero)
        self.scrollView.backgroundColor = .systemBackground
        self.scrollView.frame = self.view.bounds
        self.scrollView.contentSize = self.contentSize
        
        self.containerView = UIView()
        self.containerView.backgroundColor = .systemBackground
        self.containerView.frame.size = self.contentSize
        
        self.selectImageButton = UIButton(configuration: .tinted())
        self.nameTextField = UITextField()
        self.artistTextField = UITextField()
        self.datePicker = UIDatePicker()
        
        self.selectImageButton.configuration?.image = UIImage(systemName: "camera.on.rectangle")
        self.selectImageButton.configuration?.cornerStyle = .dynamic
        self.selectImageButton.configuration?.buttonSize = .large
        
        self.nameTextField.borderStyle = .roundedRect
        self.nameTextField.backgroundColor = .systemGroupedBackground
        self.nameTextField.font = .preferredFont(forTextStyle: .headline)
        self.nameTextField.placeholder = "ADD_RECORD_NAME_PLACEHOLDER".localized()
        self.nameTextField.textAlignment = .center
        
        self.artistTextField.borderStyle = .roundedRect
        self.artistTextField.backgroundColor = .systemBackground
        self.artistTextField.font = .preferredFont(forTextStyle: .subheadline)
        self.artistTextField.placeholder = "ADD_RECORD_ARTIST_PLACEHOLDER".localized()
        self.artistTextField.textAlignment = .center
        
        self.datePickerLabel = UILabel()
        self.datePickerLabel.text = "ADD_RECORD_DATE_PICKER_LABEL".localized()
        self.datePickerLabel.font = .preferredFont(forTextStyle: .callout)
        
        self.datePicker.preferredDatePickerStyle = .compact
        self.datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Date()
        
        self.selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        self.nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.artistTextField.translatesAutoresizingMaskIntoConstraints = false
        self.datePickerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        self.nameTextField.becomeFirstResponder()
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)
        
        self.containerView.addSubview(self.selectImageButton)
        self.containerView.addSubview(self.nameTextField)
        self.containerView.addSubview(self.artistTextField)
        self.containerView.addSubview(self.datePickerLabel)
        self.containerView.addSubview(self.datePicker)
        
        NSLayoutConstraint.activate([
            self.selectImageButton.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.selectImageButton.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 15),
            self.selectImageButton.heightAnchor.constraint(equalToConstant: 150),
            self.selectImageButton.widthAnchor.constraint(equalToConstant: 150),
            
            self.nameTextField.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.nameTextField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.containerView.trailingAnchor.constraint(equalTo: self.nameTextField.trailingAnchor, constant: 20),
            self.nameTextField.topAnchor.constraint(equalTo: self.selectImageButton.bottomAnchor, constant: 20),
            
            self.artistTextField.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor, constant: 10),
            self.artistTextField.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.artistTextField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.containerView.trailingAnchor.constraint(equalTo: self.artistTextField.trailingAnchor, constant: 20),
            
            self.datePickerLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
            self.datePickerLabel.topAnchor.constraint(equalTo: self.artistTextField.bottomAnchor, constant: 25),
            
            self.datePickerLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.datePicker.leadingAnchor, constant: 10),
            self.datePicker.centerYAnchor.constraint(equalTo: self.datePickerLabel.centerYAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.datePicker.trailingAnchor, constant: 20),
//            self.datePicker.bottomAnchor.constraint(greaterThanOrEqualTo: self.containerView.bottomAnchor, constant: 15)
        ])
        
        self.view.invalidateIntrinsicContentSize()
        self.view.layoutIfNeeded()
        self.view.layoutSubviews()
    }
    
    // MARK: - Button Actions
    
    private var loadingSpinner: UIActivityIndicatorView {
        let spinner  = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        return spinner
    }
    
    func addRecordButtonAction() {
        // Show spinner and disable cancel button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.loadingSpinner)
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
        if self.nameTextField.text.orEmpty().isEmpty {
            let alert = UIAlertController(title: "ALERT_ERROR".localized(), message: "ADD_RECORD_ALERT_NO_NAME".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel))
            
            self.present(alert, animated: true)
            
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem = self.rightBarButton
            
            return
        }
        
        if self.artistTextField.text.orEmpty().isEmpty {
            let alert = UIAlertController(title: "ALERT_ERROR".localized(), message: "ADD_RECORD_ALERT_NO_ARTIST".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel))
            self.present(alert, animated: true)
            
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem = self.rightBarButton
            
            return
        }
        
        #warning("Complete implementation")
        if Calendar.current.isDateInToday(self.datePicker.date) {
            let alert = UIAlertController(title: "ADD_RECORD_ALERT_NO_DATE_TITLE".localized(), message: "ADD_RECORD_ALERT_NO_DATE_DESCR".localized(), preferredStyle: .alert)
            
            self.present(alert, animated: true)
            
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem = self.rightBarButton
            
            return
        }
        
        let record = Record(context: self.container.viewContext)
        
        record.name = self.nameTextField.text.orEmpty()
        record.artist = self.artistTextField.text.orEmpty()
        record.releaseDate = self.datePicker.date
        
        do {
            try self.container.viewContext.save()
        } catch {
            let alert = UIAlertController(title: "ALERT_ERROR".localized(), message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CANCEL".localized(), style: .cancel))
            self.present(alert, animated: true)
            return
        }
        self.delegate?.reloadData()
        self.dismiss(animated: true)
    }
}
