//
//  WeatherViewModel.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import UIKit

class DailyForecastTableViewCell: UITableViewCell {
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        lbl.textAlignment = .left
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()

    private let tempMinLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        lbl.textAlignment = .right
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()

    private let tempMaxLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        lbl.textAlignment = .right
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(dateLabel)
        addSubview(tempMinLabel)
        addSubview(tempMaxLabel)
        addSubview(weatherIconImageView)
        
        self.backgroundColor = .clear

        dateLabel.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: nil,
            padding: .init(top: 8, left: 8, bottom: 8, right: 0),
            size: .init(width: 0, height: 0),
            enableInsets: false
        )

        weatherIconImageView.anchor(
            top: topAnchor,
            left: nil,
            bottom: bottomAnchor,
            right: nil,
            padding: .init(top: 8, left: 0, bottom: 8, right: 0),
            size: .init(width: 32, height: 32),
            enableInsets: false
        )

        weatherIconImageView.centerInSuperview()
        
        tempMaxLabel.anchor(
            top: topAnchor,
            left: nil,
            bottom: bottomAnchor,
            right: tempMinLabel.leftAnchor,
            padding: .init(top: 8, left: 0, bottom: 8, right: 8),
            size: .init(width: 0, height: 0),
            enableInsets: false
        )

        tempMinLabel.anchor(
            top: topAnchor,
            left: nil,
            bottom: bottomAnchor,
            right: rightAnchor,
            padding: .init(top: 8, left: 0, bottom: 8, right: 8),
            size: .init(width: 0, height: 0),
            enableInsets: false
        )
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with cellModel: DailyForeCastCellModel) {
        dateLabel.text = cellModel.dateString
        weatherIconImageView.imageFrom(link: cellModel.iconURL)
        tempMinLabel.text = cellModel.minTemp
        tempMaxLabel.text = cellModel.maxTemp + " / "
    }
}
