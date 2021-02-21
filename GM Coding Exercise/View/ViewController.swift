//
//  ViewController.swift
//  GM Coding Exercise
//
//  Created by Derek on 2/19/21.
//

import UIKit


class ViewController: UIViewController,UITableViewDelegate {
    //MARK: - IBOutlets
    @IBOutlet weak var artistButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBAction func searchButtonTapped(_ sender: Any) {
        if isSearching == true{
            spinner.startAnimating()
            spinner.isHidden = false
            guard let tf = searchTextField.text else { return }
            NetworkManager.shared.fetchArtist(artistName: tf) {[weak self] (res) in
                DispatchQueue.main.async {
                    switch res {
                    case .failure(let error):
                        print(error)
                    case .success(let art):
                        for x in art.results{
                            self?.artistInfoz.append(x)
                        }
                        self?.tableView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    self?.spinner.isHidden = true
                    self?.spinner.stopAnimating()
                }
            }
            artistInfoz.removeAll()
//            isSearching = false
        }else{
//            spinner.isHidden = true
//            spinner.stopAnimating()
//            isSearching = true
        }
//        guard let tf = searchTextField.text else { return }
//        NetworkManager.shared.fetchArtist(artistName: tf) {[weak self] (res) in
//            DispatchQueue.main.async {
//                switch res {
//                case .failure(let error):
//                    print(error)
//                case .success(let art):
//                    for x in art.results{
//                        self?.artistInfoz.append(x)
//                    }
//                    self?.tableView.reloadData()
//                }
//            }
//        }
//        artistInfoz.removeAll()
    }
    //MARK: - Properties
    var viewModel:ArtistViewModel?
    var artistInformation = [MusicItem]()
    var artistInfoz:[MusicItem] = []
    var isSearching:Bool = true
    let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
//        spinner.color = .gray
        
        configureDelegates()
        configureUI()
    }
    func configureDelegates(){
        let nib = UINib(nibName: Constants.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.nibName)
        tableView.dataSource = self
        searchTextField.delegate = self
        searchTextField.autocorrectionType = .no
        searchTextField.returnKeyType = .done
        searchTextField.autocapitalizationType = .words
        tableView.delegate = self
    }
    func activityIndicator() {
        spinner.style = UIActivityIndicatorView.Style.medium
        spinner.center = self.view.center
        self.view.addSubview(spinner)
    }
    func configureUI(){
        guard let tf = searchTextField.text else { return }
        NetworkManager.shared.fetchArtist(artistName: tf) {[weak self] (res) in
            switch res {
            case .failure(let error):
                print(error)
            case .success(let art):
                for x in art.results{
                    self?.artistInfoz.append(x)
                }
            }
        }
    }
}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistInfoz.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseId,for: indexPath) as! TableViewCell
        let cellData = artistInfoz[indexPath.row]
//        cell.artistName.text = cellData.artistName
//        cell.genre.text = cellData.primaryGenreName
//        cell.trackName.text = cellData.trackName
//        cell.releaseDate.text = cellData.releaseDate
//        cell.price.text = String(cellData.trackPrice ?? 0.00)
        cell.configure(with: ArtistViewModel(with: cellData))
        return cell
    }
}
extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Enter Artist"
            return false
        }
    }
}
