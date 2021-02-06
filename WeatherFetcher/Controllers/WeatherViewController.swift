//
//  WeatherDetailsViewController.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import UIKit

class WeatherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    fileprivate var header : StretchHeaderLists!
    fileprivate var viewModel: WeatherViewModel
    
    public let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.hidesWhenStopped = true
        aiv.color = .white
        return aiv
    }()
    
    private let cityLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 30, weight: .medium)
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private let gpsIcon: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "ic-gps")?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .white
        return imgView
    }()
    
    private let weatherConditionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 17)
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private let currentTempLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 70, weight: .light)
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private let tempMaxLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        lbl.textAlignment = .right
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    
    private let tempMinLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: Constants.dailyForeCastCellID)
        return tableView
    }()
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModel()
        setupHeaderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.requestWeatherData()
    }
    
    func setupViewModel(){
        viewModel.reloadClosure = { [weak self] in
            self?.loadCurrentdata()
            self?.tableView.reloadData()
        }
        
        viewModel.animationFails = { [weak self] error in
            self?.presentActionAlert(title: "Failed to fetch weather data", message: error.localizedDescription, event: {
                self?.activityIndicatorView.stopAnimating()
            })
        }
        
        viewModel.animationSucceeds = { [weak self] in
            self?.activityIndicatorView.stopAnimating()
        }
        
        viewModel.animationStarts = { [weak self] in
            self?.activityIndicatorView.startAnimating()
        }
    }
    
    func loadCurrentdata(){
        guard let model = viewModel.currentCellModel else {
            return
        }
        cityLabel.text = model.cityName
        currentTempLabel.text = model.temperature
        weatherConditionLabel.text = model.weatherCondition
        tempMaxLabel.text = model.maxTemp + " /"
        tempMinLabel.text = model.minTemp
        gpsIcon.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfDailyRecords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = viewModel.cellModel(for: indexPath.row) else {
            return UITableViewCell()
        }
        let cell: DailyForecastTableViewCell = tableView.dequeueOrCreateCell()
        cell.configure(with: cellModel)
        return cell
    }
    
    fileprivate func setupViews() {
        if let img = UIImage(named: "bg") {
            self.view.backgroundColor = UIColor(patternImage: img)
        }
        view.addSubview(cityLabel)
        view.addSubview(weatherConditionLabel)
        view.addSubview(currentTempLabel)
        view.addSubview(tempMinLabel)
        view.addSubview(tempMaxLabel)
        view.addSubview(tableView)
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerInSuperview()
    
        tableView.dataSource = self
        tableView.delegate = self
        
        cityLabel.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: nil,
            bottom: nil,
            right: nil,
            padding: .init(top: 16, left: 16, bottom: 0, right: 16),
            size: .init(width: 0, height: 32),
            enableInsets: false
        )
        
        cityLabel.centerXInSuperview()
        
        if viewModel.localModel {
            view.addSubview(gpsIcon)
            gpsIcon.anchor(
                top: view.safeAreaLayoutGuide.topAnchor,
                left: cityLabel.rightAnchor,
                bottom: nil,
                right: nil,
                padding: .init(top: 16, left: 4, bottom: 0, right: 16),
                size: .init(width: 20, height: 25),
                enableInsets: false
            )
            gpsIcon.isHidden = true
        }
        
        
        currentTempLabel.anchor(
            top: cityLabel.bottomAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            padding: .init(top: 16, left: 16, bottom: 0, right: 16),
            size: .init(width: 0, height: 64),
            enableInsets: false
        )
        
        tempMaxLabel.anchor(
            top: currentTempLabel.bottomAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.centerXAnchor,
            padding: .init(top: 16, left: 16, bottom: 0, right: 0),
            size: .init(width: 0, height: 16),
            enableInsets: false
        )
        
        tempMinLabel.anchor(
            top: currentTempLabel.bottomAnchor,
            left: view.centerXAnchor,
            bottom: nil,
            right: view.rightAnchor,
            padding: .init(top: 16, left: 6, bottom: 0, right: 16),
            size: .init(width: 0, height: 16),
            enableInsets: false
        )
        
        weatherConditionLabel.anchor(
            top: tempMinLabel.bottomAnchor,
            left: view.leftAnchor,
            bottom: nil,
            right: view.rightAnchor,
            padding: .init(top: 16, left: 16, bottom: 0, right: 16),
            size: .init(width: 0, height: 16),
            enableInsets: false
        )
        
        tableView.anchor(
            top: weatherConditionLabel.bottomAnchor,
            left: view.leftAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            right: view.rightAnchor,
            padding: .init(top: -80, left: 16, bottom: 0, right: 16),
            size: .init(width: 0, height: 0),
            enableInsets: false
        )
    }
    

    func setupHeaderView() {
        let options = StretchHeaderOptions()
        options.position = .underNavigationBar
        header = StretchHeaderLists()
        header.stretchHeaderSize(headerSize: CGSize(width: view.frame.size.width, height: 140),
                                 imageSize: CGSize(width: view.frame.size.width, height: 140),
                                 controller: self,
                                 options: options)
        header.backgroundColor = .clear
        tableView.tableHeaderView = header
    }

    fileprivate var isTop = false

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let alphaValue = (scrollView.contentOffset.y / (scrollView.bounds.size.height/4))
        currentTempLabel.alpha = 1 - (alphaValue + 0.3)
        tempMaxLabel.alpha = 1 - (alphaValue + 0.4)
        tempMinLabel.alpha = 1 - (alphaValue + 0.4)
        weatherConditionLabel.alpha = 1 - (alphaValue + 0.4)
        header.updateScrollViewOffset(scrollView)
    }
    
}
