//
//  WorkoutTableViewCell.swift
//  Final
//
//  Created by Crystal Liu on 4/29/18.
//  Copyright © 2018 Crystal Liu. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    var timeLabel: UILabel!
    var dateLabel: UILabel!
    var distanceLabel: UILabel!
    var intervalLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        timeLabel = UILabel()
        dateLabel = UILabel()
        distanceLabel = UILabel()
        intervalLabel = UILabel()
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        intervalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        distanceLabel.font = UIFont.systemFont(ofSize: 14.0)
        intervalLabel.font = UIFont.systemFont(ofSize: 14.0)
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(intervalLabel)
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 72),
            timeLabel.heightAnchor.constraint(equalToConstant: 72)
            ])
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
        NSLayoutConstraint.activate([
            distanceLabel.bottomAnchor.constraint(equalTo: intervalLabel.topAnchor),
            distanceLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 16),
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
        NSLayoutConstraint.activate([
            intervalLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            intervalLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 16),
            intervalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

