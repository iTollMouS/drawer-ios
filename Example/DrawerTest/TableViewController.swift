//  Copyright (c) 2020 Shortcut AS
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

class DummyTableViewCell: UITableViewCell {
  static let identifier = "DummyTableViewCell"

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup() {
  }
}

class TableViewController: UIViewController {
  let segmentedControl = SquareSegmentedControl()
  let tableView = UITableView(frame: .zero, style: .plain)

  let grayColor = UIColor(white: 0.9, alpha: 1)

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .clear

    let closeBarButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                         target: self, action: #selector(dismissMe))
    navigationItem.rightBarButtonItem = closeBarButton

    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(segmentedControl)
    NSLayoutConstraint.activate([
      segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      segmentedControl.heightAnchor.constraint(equalToConstant: 40),
    ])

    segmentedControl.insertSegment(withTitle: "First", at: 0, animated: false)
    segmentedControl.insertSegment(withTitle: "Second", at: 1, animated: false)

    let grayImage: UIImage = {
      let size = CGSize(width: 5, height: 5)
      let renderer = UIGraphicsImageRenderer(size: size)
      return renderer.image { context in
        grayColor.setFill()
        context.fill(CGRect(origin: .zero, size: size))
      }
    }()
    segmentedControl.setBackgroundImage(grayImage, for: .normal, barMetrics: .default)
    segmentedControl.setDividerImage(grayImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

    tableView.translatesAutoresizingMaskIntoConstraints = false
    let bottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    bottomConstraint.priority = .defaultHigh
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
      bottomConstraint,
    ])
    tableView.backgroundColor = .white
    tableView.register(DummyTableViewCell.self, forCellReuseIdentifier: DummyTableViewCell.identifier)
    tableView.dataSource = self
  }

  @objc func dismissMe() {
    dismiss(animated: true)
  }
}

extension TableViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: DummyTableViewCell.identifier, for: indexPath)
    let titles = [
      "Custom",
      "System",
      "Detail Disclosure",
      "Info Light",
      "Info Dark",
      "Contact Add",
      "Plain",
      "Rounded Rect",
    ]
    cell.textLabel?.text = titles[indexPath.row % titles.count]
    if indexPath.row < 5 {
      cell.backgroundColor = grayColor
    } else {
      cell.backgroundColor = .white
    }
    return cell
  }
}
