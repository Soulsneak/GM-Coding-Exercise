//
//  ViewController.swift
//  GM Coding Exercise
//
//  Created by Derek on 2/19/21.
//

import UIKit


class ViewController: UIViewController,UITableViewDelegate {
    //MARK: - IBOutlets
    @IBOutlet weak var artistButton: UIButton!{
        didSet{
            artistButton.accessibilityIdentifier = "Test"
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBAction func searchButtonTapped(_ sender: Any) {
        loadArtist()
    }
    //MARK: - Properties
    var viewModel:ArtistViewModel?
    var artistInformation = [MusicItem]()
    var artistInfoz:[MusicItem] = []
    var isSearching:Bool = true
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        configureDelegates()
        configureUI()
    }
    //MARK: - Helper Functions
    func configureDelegates(){
        let nib = UINib(nibName: Constants.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.nibName)
        tableView.dataSource = self
        tableView.allowsSelection = false
        searchTextField.delegate = self
        searchTextField.autocorrectionType = .no
        searchTextField.returnKeyType = .done
        searchTextField.autocapitalizationType = .words
        tableView.delegate = self
    }
    func configureUI(){
        guard let tf = searchTextField.text else { return }
        NetworkManager.shared.fetchArtist(artistName: tf) {[weak self] (res) in
            guard let self = self else { return }
            switch res {
            case .failure(let error):
                print(error)
            case .success(let art):
                for x in art.results{
                    self.artistInfoz.append(x)
                }
            }
        }
    }
    func loadArtist(){
        if isSearching == true{
            spinner.startAnimating()
            spinner.isHidden = false
            guard let tf = searchTextField.text else { return }
            NetworkManager.shared.fetchArtist(artistName: tf) {[weak self] (res) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch res {
                    case .failure(let error):
                        print(error)
                    case .success(let art):
                        for x in art.results{
                            self.artistInfoz.append(x)
                        }
                        self.tableView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                }
            }
            artistInfoz.removeAll()
        }else{ }
    }
}
//MARK: - TableViewDataSource
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistInfoz.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseId,for: indexPath) as! TableViewCell
        let cellData = artistInfoz[indexPath.row]
        cell.configure(with: ArtistViewModel(with: cellData))
        return cell
    }
}
//MARK: - TextField Delegate
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
            textField.placeholder = "Enter Artist Name"
            return false
        }
    }
}
