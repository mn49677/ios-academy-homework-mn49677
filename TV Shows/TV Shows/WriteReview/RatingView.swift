//
//  RatingView.swift
//  TV Shows
//

import UIKit

protocol RatingViewDelegate: AnyObject {
    func didChangeRating(_ rating: Int)
}

class RatingView: UIView {

    enum Style {
        case large
        case small
    }
    
    //MARK: - Private properties
    
    private var ratingValue: Int = 0

    // MARK: - Public properties

    // Sets the rating - value from 0 to 5, inclusive
    // it will get clamped if out of bounds
    var rating: Int {
        get { currentSelectedRating() }
        set { setRating(newValue) }
    }

    // Should user be able to change the rating - useful if you
    // want to disable changing rating like on the list of reviews
    var isEnabled: Bool {
        get { isUserInteractionEnabled }
        set { isUserInteractionEnabled = newValue }
    }

    // Useful when you want to notify that rating has been selected/changed
    // for example, on new rating screen you should disable Submit button
    // until user selects rating for the first time
    weak var delegate: RatingViewDelegate?

    // MARK: - Private properties

    private let stackView = UIStackView()
    private let ratingButtons = [
        RatingView.createRatingButton(),
        RatingView.createRatingButton(),
        RatingView.createRatingButton(),
        RatingView.createRatingButton(),
        RatingView.createRatingButton()
    ]

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Public methods

    // Configures size of rating buttons - small ones are
    // used on review list, while large are used on new review screen
    func configure(withStyle style: RatingView.Style) {
        let selectedImage: UIImage?
        let normalImage: UIImage?
        switch style {
        case .large:
            selectedImage = UIImage(named: "ic-star-selected-large")
            normalImage = UIImage(named: "ic-star-deselected-large")
        case .small:
            selectedImage = UIImage(named: "ic-star-selected")
            normalImage = UIImage(named: "ic-star-deselected")
        }
        ratingButtons.forEach {
            $0.setImage(normalImage, for: .normal)
            $0.setImage(selectedImage, for: .selected)
        }
    }

    func setRoundedRating(_ rating: Double) {
        let rounded = Int(rating.rounded())
        self.rating = rounded
    }
}

private extension RatingView {

    func commonInit() {
        addSubview(stackView)
        ratingButtons.forEach { stackView.addArrangedSubview($0) }

        configureStackView()
        configureRatingButtons()
    }

    func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configureRatingButtons() {
        configure(withStyle: .large)

        ratingButtons.forEach {
            $0.addTarget(self, action: #selector(ratingButtonActionHandler(_:)), for: .touchUpInside)
        }
    }

    static func createRatingButton() -> UIButton {
        let button = UIButton()
        button.adjustsImageWhenHighlighted = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    func setRating(_ rating: Int) {
        // TODO: Your code goes here
        ratingValue = rating + 1
        ratingButtons
                    .enumerated()
                    .forEach { (index, button) in
                        button.isSelected = index < rating
                    }

    }

    func currentSelectedRating() -> Int {
        // TODO: Your code goes here
        return ratingValue
    }
}

// MARK: - Action handlers

private extension RatingView {

    @objc
    func ratingButtonActionHandler(_ button: UIButton) {
        guard let buttonIndex = ratingButtons.firstIndex(of: button)  else { return }
        // TODO: Enter the correct index for the rating
        setRating(buttonIndex + 1)
        delegate?.didChangeRating(rating)
    }
}


// MARK: - Review parameters
struct ReviewParameters: Codable {
    let rating: Int
    let comment: String
    let showID: Int

    enum CodingKeys: String, CodingKey {
        case rating, comment
        case showID = "show_id"
    }
}

// MARK: - Review return value

struct ReturnReviewResponse: Codable {
    let review: ReturnReview
}

struct ReturnReview: Codable {
    let id, comment: String
    let rating, showID: Int
    let user: ReturnUser

    enum CodingKeys: String, CodingKey {
        case id, comment, rating
        case showID = "show_id"
        case user
    }
}

struct ReturnUser: Codable {
    let id, email: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, email
        case imageURL = "image_url"
    }
}
