//
//  ViewController.swift
//  ExStaticHeightLabel
//
//  Created by 김종권 on 2024/03/16.
//

import UIKit

class ViewController: UIViewController {
    private let tableView = {
        let view = UITableView()
        view.register(MyCell.self, forCellReuseIdentifier: "cell")
        view.contentInsetAdjustmentBehavior = .never // <-
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var dataSource = (0...100)
        .map {
            String($0) + " " +
            ["개행 문자가 있는 경우? 가나다라\n마", "긴 문구를 사용했을때? 과연 어떻게 표출될것인지 가나다라마바사아자차", ""]
                .randomElement()!
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(tableView.adjustedContentInset)
    }
    
    static func getLabelHeight(text: String) -> CGFloat {
        let label = UILabel(
            frame: .init(
                x: .zero,
                y: .zero,
                width: UIScreen.main.bounds.width - MyCell.Const.labelHorizontalMargin,
                height: .greatestFiniteMagnitude
            )
        )
        label.text = text
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 24)
        label.sizeToFit()
        let labelHeight = label.frame.height
        return labelHeight
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCell else { return UITableViewCell() }
        let text = dataSource[indexPath.row]
        cell.configure(text: text)
        
//        print(ViewController.getLabelHeight(text: text))
        
        return cell
    }
}

final class MyCell: UITableViewCell {
    enum Const {
        static let labelHorizontalMargin = 24.0
    }
    
    private let label = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textColor = .black
        l.font = .systemFont(ofSize: 24)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Const.labelHorizontalMargin / 2),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Const.labelHorizontalMargin / 2),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(text: String) {
        label.text = text
    }
}
