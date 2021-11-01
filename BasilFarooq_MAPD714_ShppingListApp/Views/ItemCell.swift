//
//  BasilFarooq_MAPD714_ShppingListApp
//
//  Created by Basil on 30/10/2021.
//

import UIKit

protocol ItemCellProtocol: AnyObject {
    func itemNameChanged(name: String, cell: ItemCell)
    func quantityChanged(quantity: Int, cell: ItemCell)
}

class ItemCell: UITableViewCell {

    // Components Outlets Text Field, Quantity label, Quantity Stepper
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    // Properties
    weak var delegate: ItemCellProtocol?
    
    // LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        itemNameTextField.addTarget(self, action: #selector(nameChanged(_:)), for: .editingChanged)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentView.endEditing(true)
    }
    
    // Actions
    @IBAction func quantityStepperValueChanged(_ sender: UIStepper) {
        quantityLabel.text = "\(Int(sender.value))"
        delegate?.quantityChanged(quantity: Int(sender.value), cell: self)
    }

    // Public Methods
    func configure(with item: Item) {
        itemNameTextField.text = item.name
        quantityLabel.text = "\(item.quantity)"
        quantityStepper.value = Double(item.quantity)
    }
}

// Private Methods for editing item name
extension ItemCell {
    @objc private func nameChanged(_ sender: UITextField) {
        delegate?.itemNameChanged(name: sender.text!, cell: self)
    }
}
