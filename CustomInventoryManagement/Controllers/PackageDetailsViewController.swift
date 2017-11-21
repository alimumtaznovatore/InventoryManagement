//
//  PackageDetailsViewController.swift
//  CustomInnovativeMap
//
//  Created by Imran Jameel on 11/20/17.
//  Copyright © 2017 NovatoreSolutions. All rights reserved.
//

import UIKit

class PackageDetailsViewController: UIViewController {
    
    
    
    static func getInvoiceList(invoiceProductList: [Product]) {
        print(invoiceProductList[0].productName!)
    }
    
    //Variables
    var package: Package?
    static var packageReturnFromInvoiceScreen: Package?
    private var didComeFromSenderDetailController = false
    private var isSelfRecipient = false
    private var isInstructionTextViewTapped = false
    
    var packagesCount = 0
    var smallLabelValue:Int = 0
    var mediumLabelValue:Int = 0
    var largeLabelValue:Int = 0
    
    //Buttons
    @IBOutlet weak var scrollDownBtn: UIButton!
    @IBOutlet weak var invoiceBtn: UIButton!
    private let menuButton = UIButton()
    @IBOutlet var saveButton: UIButton!
    
    //Views
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var senderDetailView: UIView!
    @IBOutlet weak var recipientDetailView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var amountSuperView: UIView!
    @IBOutlet var instructionsTextField: UITextView!
    @IBOutlet weak var chooseOptionView: UIView!
    @IBOutlet var titleMenu: UIView!
    private let progressView = UIView()
    private let recipientView = UIView()
    private let detailView = UIView()
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    
    //Text Fields
    @IBOutlet weak var senderMobileNumberTxtField: B68UIFloatLabelTextField!
    @IBOutlet weak var senderNameTxtField: B68UIFloatLabelTextField!
    @IBOutlet weak var senderEmailTxtField: B68UIFloatLabelTextField!
    @IBOutlet weak var recipientMobileNumberTxtField: B68UIFloatLabelTextField!
    @IBOutlet weak var recipientNameTxtField: B68UIFloatLabelTextField!
    @IBOutlet weak var recipientEmailTxtField: B68UIFloatLabelTextField!
    @IBOutlet var amountTextField: UITextField!
    
    //Labels
    private var instructionLabel = UILabel()
    @IBOutlet weak var selfLabel: UILabel!
    @IBOutlet var smallLabel: UILabel!
    @IBOutlet var mediumLabel: UILabel!
    @IBOutlet var largeLabel: UILabel!
    @IBOutlet var totalAmountLabel: UILabel!
    @IBOutlet var instructionsPlaceHolderLabel: UILabel!
    @IBOutlet weak var billingOptionLbl: UILabel!
    @IBOutlet weak var billingLbl: UILabel!
    private let headingLabel = UILabel()
    
    //Constraint
    @IBOutlet weak var widthconstraintTopBar: NSLayoutConstraint!
    @IBOutlet weak var heightconstraintFirstView: NSLayoutConstraint!
    @IBOutlet weak var heightconstraintSecondView: NSLayoutConstraint!
    @IBOutlet weak var topconstraintSecondView: NSLayoutConstraint!
    @IBOutlet weak var topconstraintThirdLineView: NSLayoutConstraint!
    @IBOutlet weak var topconstraintForthView: NSLayoutConstraint!
    @IBOutlet weak var heightconstraintContentView: NSLayoutConstraint!
    @IBOutlet weak var heightconstraintGuestView: NSLayoutConstraint!
    
    
    
    @IBAction func scrollDownBtnAction(_ sender: Any) {
        
        scrollView.setContentOffset(CGPoint(x:0 , y: 100), animated: true)
        
    }
    @IBAction func changeSelectedSegmentControl(_ sender: Any) {
        
        if(Global.isSignedIn){
            
            switch segmentControl.selectedSegmentIndex{
            case 0:
                print("First selected")
                self.recipientDetailView.isHidden = false
                self.senderDetailView.isHidden = true
                self.selfLabel.isHidden = true
                
            case 1:
                print("Second Segment selected")
                self.recipientDetailView.isHidden = true
                self.senderDetailView.isHidden = false
                self.selfLabel.isHidden = true
                
            case 2:
                print("Third Segment Selected")
                self.recipientDetailView.isHidden = true
                self.senderDetailView.isHidden = true
                self.selfLabel.isHidden = false
            default:
                
                break;
            }
            
        }
    }
    
    override func viewDidLoad() {
        
        print("viewDidLoad start")
        super.viewDidLoad()
        setUI()
        loadTopImagesView()
        Global.turnOffOnSliderPanGesture(panGestureOff: false)
        fillFieldsIfPackageIsUpdating()
        setTapGesture()
        
    }
    
    func setUI() {
        print("setUI start")
        
        giveBorderToViews()
        
        self.instructionsTextField.delegate = self
        self.amountTextField.delegate = self
        self.recipientMobileNumberTxtField.delegate = self
        self.recipientEmailTxtField.delegate = self
        self.recipientNameTxtField.delegate = self
        self.senderMobileNumberTxtField.delegate = self
        self.senderEmailTxtField.delegate = self
        self.senderNameTxtField.delegate = self
        
        if(packagesCount > 1){
            self.segmentControl.selectedSegmentIndex = UserDefaults.standard.value(forKey: "selectedSegmentedIndex") as! Int
            if(self.segmentControl.selectedSegmentIndex == 0){
                self.segmentControl.setEnabled(false, forSegmentAt: 1)
                self.segmentControl.setEnabled(false, forSegmentAt: 2)
                self.recipientDetailView.isHidden = false
                self.senderDetailView.isHidden = true
                self.selfLabel.isHidden = true
                
                
            }
            else if (self.segmentControl.selectedSegmentIndex == 1){
                
                self.segmentControl.setEnabled(false, forSegmentAt: 0)
                self.segmentControl.setEnabled(false, forSegmentAt: 2)
                self.recipientDetailView.isHidden = true
                self.senderDetailView.isHidden = false
                self.selfLabel.isHidden = true
                
            }
            else if (self.segmentControl.selectedSegmentIndex == 2){
                self.segmentControl.setEnabled(false, forSegmentAt: 0)
                self.segmentControl.setEnabled(false, forSegmentAt: 1)
                self.recipientDetailView.isHidden = true
                self.senderDetailView.isHidden = true
                self.selfLabel.isHidden = false
            }
            
        }
        
        
        if(Global.isSignedIn){
            if(self.segmentControl.selectedSegmentIndex == 0){
                self.recipientDetailView.isHidden = false
                self.selfLabel.isHidden = true
                self.senderDetailView.isHidden = true
                
            }
            if(self.segmentControl.selectedSegmentIndex == 1){
                self.recipientDetailView.isHidden = true
                self.selfLabel.isHidden = true
                self.senderDetailView.isHidden = false
                
            }
            if(self.segmentControl.selectedSegmentIndex == 2){
                self.recipientDetailView.isHidden = true
                self.selfLabel.isHidden = false
                self.senderDetailView.isHidden = true
                
            }
        }
        
    }
    
    
    
    func setTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBillingLbl))
        let tapBillingGesture = UITapGestureRecognizer(target: self, action: #selector(tapBillingLbl))
        
        billingLbl.isUserInteractionEnabled = true
        billingLbl.addGestureRecognizer(tapBillingGesture)
        billingOptionLbl.isUserInteractionEnabled = true
        billingOptionLbl.addGestureRecognizer(tapGesture)
        
    }
    
    func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tapBillingLbl(gesture: UITapGestureRecognizer) {
        
        let alert = Global.alertActionWithoutOK(title: "Info", message: "Use this option if you are selling or you need the driver to pay/collect cash.")
        self.present(alert, animated: true, completion: {
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        })
    }
    
    func loadTopImagesView() {
        //tv stands for Top View
        let tv = Bundle.main.loadNibNamed("TopViewImagesView", owner: self, options: nil)?.first as! TopViewImagesView
        tv.line2.backgroundColor = Constants().lineUnselectedColor
        tv.line3.backgroundColor = Constants().lineUnselectedColor
        tv.line1.backgroundColor = Constants().lineUnselectedColor
        tv.scheduleLbl.textColor = UIColor.gray
        tv.summaryLbl.textColor = UIColor.gray
        tv.checkoutLbl.textColor = UIColor.gray
        tv.scheduleImgView.image = UIImage (named:"scheduleUnselected")
        tv.delegate = self
        tv.isPackage = false
        tv.isSchedule = false
        tv.isSummary = false
        tv.isCheckout = false
        tv.backBtn.addTarget(self, action: #selector(btnTapped) , for: .touchUpInside)
        self.topView?.addSubview(tv)
    }
    
    func btnTapped()  {
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set("backfromloginpackagedetail", forKey: "back")
        UserDefaults.standard.synchronize()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing") //1
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing") //3
        return true
    }
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing") //2
        if(textField == self.recipientMobileNumberTxtField || textField == self.senderMobileNumberTxtField){
            if(textField.text?.characters.count == 0){
                self.recipientMobileNumberTxtField.text = Constants.countryCode
                self.senderMobileNumberTxtField.text = Constants.countryCode
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if(textField == self.recipientMobileNumberTxtField || textField == self.senderMobileNumberTxtField ){
            
            if let text = textField.text {
                print("curText: \(text) range: \(range.location)-\(range.length) string: \(string)" )
                
                if(range.length == 1) && (range.location == Constants.rangeOfNumbers){
                    return false
                }
                if (range.location < Constants.rangeOfNumbers){
                    return false
                }
                if(range.location == Constants.numberDigits){
                    return false
                }
            }
        }
        
        if(textField == self.amountTextField){
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        isInstructionTextViewTapped = true
        if textView.text.characters.count <= 0{
            instructionsPlaceHolderLabel.isHidden = false
        }
        else {
            instructionsPlaceHolderLabel.isHidden = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count <= 0{
            instructionsPlaceHolderLabel.isHidden = false
        }
        else {
            instructionsPlaceHolderLabel.isHidden = true
            if(textView.textContainer.maximumNumberOfLines == 3){
                return
            }
        }
    }
    
    
    func giveBorderToViews() {
        
        Constants().setFloatingLabel(textField: recipientNameTxtField, isCenterAlign: false)
        Constants().setFloatingLabel(textField: recipientEmailTxtField, isCenterAlign: false)
        Constants().setFloatingLabel(textField: recipientMobileNumberTxtField, isCenterAlign: false)
        Constants().setFloatingLabel(textField: senderNameTxtField, isCenterAlign: false)
        Constants().setFloatingLabel(textField: senderEmailTxtField, isCenterAlign: false)
        Constants().setFloatingLabel(textField: senderMobileNumberTxtField, isCenterAlign: false)
        
        
        amountSuperView.layer.borderColor = UIColor.gray.cgColor
        amountSuperView.layer.borderWidth = 1
        amountSuperView.layer.cornerRadius = 4.0
        instructionsTextField.layer.borderColor = UIColor.lightGray.cgColor
        instructionsTextField.layer.borderWidth = 1
        instructionsTextField.layer.cornerRadius = 4.0
        Constants().setBorderColor(button: invoiceBtn)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if PackageDetailViewController.packageReturnFromInvoiceScreen != nil {
            package?.InvoiceProductList = (PackageDetailViewController.packageReturnFromInvoiceScreen?.InvoiceProductList)!
            let totalAmountFromInvoice = package?.getProductsTotal()
            if(totalAmountFromInvoice == 0){
                self.amountTextField.text = ""
            }
            else{
                self.amountTextField.text = "\(totalAmountFromInvoice!)"
            }
            
        }
    }
    
    @IBAction func decreaseLargeValue(_ sender: Any) {
        decreaseLargeValue()
    }
    
    @IBAction func decreaseSmallValue(_ sender: Any) {
        decreaseSmallValue()
    }
    
    @IBAction func increaseSmallValue(_ sender: Any) {
        increaseSmallValue()
    }
    
    @IBAction func increaseMediumValue(_ sender: Any) {
        increaseMediumValue()
    }
    
    @IBAction func decreaseMediumValue(_ sender: Any) {
        decreaseMediumValue()
    }
    
    @IBAction func increaseLargeValue(_ sender: Any) {
        increaseLargeValue()
    }
    
    @IBAction func recepientCheckBoxTapped(_ sender: Any) {
        fillFieldsIfPackageIsUpdating()
    }
    
    func fillFieldsIfPackageIsUpdating() {
        print("fillFieldsIfPackageIsUpdating start")
        
        if(package?.isSender == true){
            
            self.recipientDetailView.isHidden = false
            self.selfLabel.isHidden = true
            self.senderDetailView.isHidden = true
            
            self.recipientNameTxtField.text = package?.recipient?.name
            self.recipientMobileNumberTxtField.text = package?.recipient?.cellNo
            self.recipientEmailTxtField.text = package?.recipient?.email
            self.segmentControl.selectedSegmentIndex = 0
            self.segmentControl.setEnabled(false, forSegmentAt: 1)
            self.segmentControl.setEnabled(false, forSegmentAt: 2)
        }
        else if (package?.isReceiver == true){
            self.recipientDetailView.isHidden = true
            self.selfLabel.isHidden = true
            self.senderDetailView.isHidden = false
            self.senderNameTxtField.text = package?.senderDetail?.senderName
            self.senderMobileNumberTxtField.text = package?.senderDetail?.senderCell
            self.senderEmailTxtField.text = package?.senderDetail?.senderEmail
            self.segmentControl.selectedSegmentIndex = 1
            self.segmentControl.setEnabled(false, forSegmentAt: 0)
            self.segmentControl.setEnabled(false, forSegmentAt: 2)
        }
        else if (package?.isSelfRecipient == true){
            
            self.segmentControl.selectedSegmentIndex = 2
            self.segmentControl.setEnabled(false, forSegmentAt: 0)
            self.segmentControl.setEnabled(false, forSegmentAt: 1)
            self.recipientDetailView.isHidden = true
            self.senderDetailView.isHidden = true
            self.selfLabel.isHidden = false
            
        }
        
        if package?.packageQuantity != nil {
            self.smallLabelValue = (package?.packageQuantity?.smallQuantity)!
            self.mediumLabelValue = (package?.packageQuantity?.mediumQuantity)!
            self.largeLabelValue = (package?.packageQuantity?.largeQuantity)!
            self.smallLabel.text = "\((package?.packageQuantity?.smallQuantity)!)"
            self.mediumLabel.text = "\((package?.packageQuantity?.mediumQuantity)!)"
            self.largeLabel.text = "\((package?.packageQuantity?.largeQuantity)!)"
        }
        
        if package?.getProductsTotal() != nil {
            if((package?.getProductsTotal())! == 0){
                
            }
            else{
                self.amountTextField.text = "\((package?.getProductsTotal())!)"
            }
            
        }
        if(package?.packageInstructions != nil){
            if(package?.packageInstructions == ""){
                self.instructionsPlaceHolderLabel.isHidden = false
            }
            else{
                self.instructionsPlaceHolderLabel.isHidden = true
                self.instructionsTextField.text = package?.packageInstructions
            }
        }
        else{
            self.instructionsPlaceHolderLabel.isHidden = false
        }
        changeSaveButtonColor()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        saveDetailAction()
    }
    
    func saveDetailAction() {
        
        if(segmentControl.selectedSegmentIndex == 0){
            if(self.recipientNameTxtField.text == "") {
                let alertController = Global.alertAction(title: "Action failed", message: "Enter recipient name")
                self.present(alertController, animated: true, completion: nil)
                return
            }
            else if(self.recipientMobileNumberTxtField.text == "") {
                let alertController = Global.alertAction(title: "Action failed", message: "Recipient phone number is required")
                self.present(alertController, animated: true, completion: nil)
                return
            }
            else if (self.recipientMobileNumberTxtField.text?.characters.count != Constants.numberDigits){
                
                let alertController = Global.alertAction(title: "Action failed", message: "Invalid Mobile Number")
                self.present(alertController, animated: true, completion: nil)
                return
                
            }
            else if(self.recipientEmailTxtField.text != ""){
                if(Global.isValidEmail(self.recipientEmailTxtField.text!) == false) {
                    let alertController = Global.alertAction(title: "Action failed", message: "Please Enter a Valid Email Address")
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
            if (self.recipientMobileNumberTxtField.text == UserDefaults.standard.value(forKey: "cellNumber") as? String){
                
                let alertController = Global.alertAction(title: "Action failed", message: "You cannot be sender and receiver at the same time using this category please select self category")
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
        }
        else if (segmentControl.selectedSegmentIndex == 1){
            if(self.senderNameTxtField.text == "") {
                let alertController = Global.alertAction(title: "Action failed", message: "Enter sender name")
                self.present(alertController, animated: true, completion: nil)
                return
            }
            else if(self.senderMobileNumberTxtField.text == "") {
                let alertController = Global.alertAction(title: "Action failed", message: "Sender phone number is required")
                self.present(alertController, animated: true, completion: nil)
                return
            }
            else if(self.senderMobileNumberTxtField.text?.characters.count != Constants.numberDigits) {
                let alertController = Global.alertAction(title: "Action failed", message: "Invalid Mobile Number")
                self.present(alertController, animated: true, completion: nil)
                return
            }
            else if(self.senderEmailTxtField.text != ""){
                if(Global.isValidEmail(self.senderEmailTxtField.text!) == false) {
                    let alertController = Global.alertAction(title: "Action failed", message: "Please Enter a Valid Email Address")
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
            }
            
            if (self.senderMobileNumberTxtField.text == UserDefaults.standard.value(forKey: "cellNumber") as? String){
                
                let alertController = Global.alertAction(title: "Action failed", message: "You cannot be sender and receiver at the same time using this category please select self category")
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
        }
        
        var isNumberOfPackageMentioned = false
        if smallLabelValue > 0 {
            isNumberOfPackageMentioned = true
        }
        else if mediumLabelValue > 0 {
            isNumberOfPackageMentioned = true
        }
        else if largeLabelValue > 0 {
            isNumberOfPackageMentioned = true
        }
        if !isNumberOfPackageMentioned {
            let alertController = Global.alertAction(title: "Action failed", message: "Enter package quantity or invoice items")
            self.present(alertController, animated: true, completion: nil)
        }
        else if (smallLabelValue+mediumLabelValue+largeLabelValue) > 10 {
            let alertController = Global.alertAction(title: "Action failed", message: "Package quantity cannot be greater than 10")
            
            self.present(alertController, animated: true, completion: nil)
        }
            
        else {
            saveDataInModel()
            
            if Global.isSignedIn || Global.isGuest { // if user is logged in
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
    func presentSenderDetailViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "SenderDetailViewController") as! SenderDetailViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController")
        let slideMenuController = SlideMenuController(mainViewController: mainViewController, leftMenuViewController: leftViewController)
        present(slideMenuController, animated: true, completion: nil)
    }
    
    func saveDataInModel() {
        
        var recipient: Receipient
        let sender: SenderDetail
        let packageQuantity: PackageQuantity = PackageQuantity(smallQuantity: smallLabelValue, mediumQuantity: mediumLabelValue, largeQuantity: largeLabelValue)
        package?.packageQuantity = packageQuantity
        if(segmentControl.selectedSegmentIndex == 2){
            package?.isSelfRecipient = true
            package?.isSender = false
            package?.isReceiver = false
            recipient = Receipient(name: UserDefaults.standard.value(forKey: "name") as! String , email: UserDefaults.standard.value(forKey: "email") as! String , cellNo: UserDefaults.standard.value(forKey: "cellNumber") as! String)!
            sender = SenderDetail(name: UserDefaults.standard.value(forKey: "name") as! String , email: UserDefaults.standard.value(forKey: "email") as! String , cellNo: UserDefaults.standard.value(forKey: "cellNumber") as! String)!
            package?.recipient = recipient
            package?.senderDetail = sender
            
        }
        else if(segmentControl.selectedSegmentIndex == 1){
            package?.isReceiver = true
            package?.isSender = false
            package?.isSelfRecipient = false
            sender = SenderDetail(name: self.senderNameTxtField.text! , email: self.senderEmailTxtField.text!, cellNo: self.senderMobileNumberTxtField.text!)!
            recipient = Receipient(name: UserDefaults.standard.value(forKey: "name") as! String , email: UserDefaults.standard.value(forKey: "email") as! String , cellNo: UserDefaults.standard.value(forKey: "cellNumber") as! String)!
            package?.recipient = recipient
            package?.senderDetail = sender
            
        }
        else if (segmentControl.selectedSegmentIndex == 0){
            package?.isSender = true
            package?.isReceiver = false
            package?.isSelfRecipient = false
            recipient = Receipient(name: self.recipientNameTxtField.text!, email: self.recipientEmailTxtField.text!, cellNo: self.recipientMobileNumberTxtField.text!)!
            sender = SenderDetail(name: UserDefaults.standard.value(forKey: "name") as! String , email: UserDefaults.standard.value(forKey: "email") as! String , cellNo: UserDefaults.standard.value(forKey: "cellNumber") as! String)!
            package?.recipient = recipient
            package?.senderDetail = sender
            
        }
        
        UserDefaults.standard.set(segmentControl.selectedSegmentIndex, forKey: "selectedSegmentedIndex")
        UserDefaults.standard.synchronize()
        
        package?.packageTotal = smallLabelValue + mediumLabelValue + largeLabelValue
        package?.packageInstructions = instructionsTextField.text!
        if(package?.packageInstructions == nil){
            package?.packageInstructions = instructionsPlaceHolderLabel.text
        }
        if (amountTextField.text) == ""{
            package?.packageTotal = Int(0)
        }
        else{
            package?.packageTotal = Int(amountTextField.text!)!
        }
        
        ViewController.packageReturnedFromPackageViewController = package
        
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        menuAction()
    }
    
    func menuAction() {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func openInvoiceScreen(_ sender: Any) {
        goToInvoiceScreen()
    }
    
    func goToInvoiceScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "InvoiceViewController") as! InvoiceViewController
        mainViewController.package = self.package
        present(mainViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func increaseSmallValue() {
        if(self.smallLabelValue < 10){
            self.smallLabelValue = self.smallLabelValue + 1
            self.smallLabel.text = String(self.smallLabelValue)
        }
        changeSaveButtonColor()
    }
    
    func decreaseSmallValue() {
        if(self.smallLabelValue > 0) {
            self.smallLabelValue = self.smallLabelValue - 1
            self.smallLabel.text = String(self.smallLabelValue)
        }
        changeSaveButtonColor()
    }
    
    func increaseMediumValue() {
        if(self.mediumLabelValue < 10){
            self.mediumLabelValue = self.mediumLabelValue + 1
            self.mediumLabel.text = String(self.mediumLabelValue)
        }
        changeSaveButtonColor()
    }
    
    func decreaseMediumValue() {
        if(self.mediumLabelValue > 0) {
            self.mediumLabelValue = self.mediumLabelValue - 1
            self.mediumLabel.text = String(self.mediumLabelValue)
        }
        changeSaveButtonColor()
    }
    
    func increaseLargeValue() {
        if(self.largeLabelValue < 10){
            self.largeLabelValue = self.largeLabelValue + 1
            self.largeLabel.text = String(self.largeLabelValue)
        }
        changeSaveButtonColor()
    }
    
    func decreaseLargeValue() {
        if(self.largeLabelValue > 0) {
            self.largeLabelValue = self.largeLabelValue - 1
            self.largeLabel.text = String(self.largeLabelValue)
        }
        changeSaveButtonColor()
    }
    
    
}
