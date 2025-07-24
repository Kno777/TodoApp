//
//  TaskTableViewCell.swift
//  ToDoApp
//
//  Created by Kno Harutyunyan on 24.07.25.
//


import UIKit

final class TaskTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    private let creationDateLabel = UILabel()
    private let statusImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = AppColors.primaryBackgroundColor
        selectionStyle = .none
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        detailsLabel.font = .systemFont(ofSize: 12, weight: .regular)
        creationDateLabel.font = .systemFont(ofSize: 12, weight: .regular)

        titleLabel.textColor = AppColors.primaryTextColor
        detailsLabel.textColor = AppColors.primaryTextColor
        creationDateLabel.textColor = AppColors.secondaryTextColor

        titleLabel.numberOfLines = 0
        detailsLabel.numberOfLines = 0
        creationDateLabel.numberOfLines = 1

        statusImageView.clipsToBounds = true
        statusImageView.contentMode = .scaleAspectFit
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        statusImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true

        let stackVertical = UIStackView(arrangedSubviews: [titleLabel, detailsLabel, creationDateLabel])
        stackVertical.axis = .vertical
        stackVertical.spacing = 6
        stackVertical.alignment = .leading
        stackVertical.distribution = .fill

        let stackHorizontal = UIStackView(arrangedSubviews: [statusImageView, stackVertical])
        stackHorizontal.axis = .horizontal
        stackHorizontal.spacing = 8
        stackHorizontal.alignment = .top

        let mainStackView = UIStackView(arrangedSubviews: [stackHorizontal])
        mainStackView.axis = .vertical

        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }


    func configure(with task: TaskModel) {
        if !task.details.isEmpty {
            detailsLabel.text = task.details
        }
        
        creationDateLabel.text = DateFormatter.taskDateFormatter.string(from: task.createdAt)
        
        if task.isCompleted {
            
            let attributedText = NSAttributedString(
                string: task.title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: AppColors.secondaryTextColor
                ]
            )
            
            titleLabel.attributedText = attributedText
            titleLabel.textColor = AppColors.secondaryTextColor
            detailsLabel.textColor = AppColors.secondaryTextColor
            statusImageView.image = AppImage.taskCompletedIcon
        } else {
            titleLabel.text = task.title
            titleLabel.textColor = AppColors.primaryTextColor
            detailsLabel.textColor = AppColors.primaryTextColor
            statusImageView.image = AppImage.taskNotCompletedIcon
        }
    }
}
