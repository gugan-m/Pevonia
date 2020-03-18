//
//  Functions.swift
//  HiDoctorApp
//
//  Created by Vignaya on 10/18/16.
//  Copyright © 2016 swaas. All rights reserved.
//

import UIKit
import CoreLocation

//MARK :- App Version

/*
 *This method return current app version
 */

func getDBPath() -> String
{
  //DB local and device change
  let databasePath = "/Users/swaas/Desktop/HiDoctor.sqlite"
  let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
  
   //let databasePath = documentsPath.appendingPathComponent("HiDoctor_DB.sqlite")
    return databasePath
}

func getCurrentAppVersion() -> String
{
    let dictionary = Bundle.main.infoDictionary!
    let version = dictionary["CFBundleShortVersionString"] as! String
    let build = dictionary["CFBundleVersion"] as! String
    
    return version + "(" + build + ")"
}

func getCurrentAppVersionOnly() -> String
{
    let dictionary = Bundle.main.infoDictionary!
    let version = dictionary["CFBundleShortVersionString"] as! String
    
    return version
}

func getUniqueNumber()-> String
{
    let uniqueId = UIDevice.current.identifierForVendor?.uuidString
    
    return uniqueId!
}
//MARK:- Check internet connection

func checkInternetConnectivity() -> Bool
{
    return networkStatus
}

// MARK:- Dynamic Text Size Caluclation
func getTextSize(text: String?, fontName: String, fontSize: CGFloat, constrainedWidth: CGFloat) -> CGSize
{
    if text == nil
    {
        return CGSize(width: 0, height: 0)
    }
    else if (text == "")
    {
        return CGSize(width: 0, height: 0)
    }
    
    let size = CGSize(width:constrainedWidth, height:9999)
    let font = UIFont(name: fontName, size: fontSize)
    
    let attributes = [NSAttributedStringKey.font : font!]
    let title = NSMutableAttributedString(string: text!, attributes: attributes)
    let rect = title.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
    
    return rect.size
}
// MARK:- Dynamic NSAttributedText Size Caluclation
func getAttributedTextSize(text: NSAttributedString!, fontName: String, fontSize: CGFloat, constrainedWidth: CGFloat) -> CGSize
{
    if text == nil
    {
        return CGSize(width: 0, height: 0)
    }
    
    let size = CGSize(width:constrainedWidth, height:9999)
    let font = UIFont(name: fontName, size: fontSize)
    
    let attributes = [NSAttributedStringKey.font : font!]
    let title = text
    let rect = title?.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
    
    return rect!.size
}

//MARK:- Color to Image converter
func imageWithColor(color: UIColor) -> UIImage {
    let rect = CGRect(x:0.0, y:0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}

//MARK:- Date Function

func getStringInFormatDate(dateString : String) -> Date
{
    let dateFormatter = getUtcDateFormatter(formartString: defaultServerDateFormat)
    return dateFormatter.date(from: dateString)!
}

func getCalendarMonthStringToDate(dateString: String) -> Date
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    return dateFormatter.date(from: dateString)!
}

func getServerFormattedDate(date : Date) -> Date
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = defaultServerDateFormat
    dateFormatter.timeZone = TimeZone.current
    let formatter = getUtcDateFormatter(formartString: defaultServerDateFormat)
    let dateString = dateFormatter.string(from: date)
    
    let date = formatter.date(from: dateString)
    
    return date!
}

func getcurrentdateforcalendar(date: Date) -> Date
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = defaultServerDateFormat
    dateFormatter.timeZone = TimeZone.current
    let dateString = dateFormatter.string(from: date)
    let dateFormatter1 = DateFormatter()
    dateFormatter1.timeZone = TimeZone.current
    dateFormatter1.dateFormat = defaultServerDateFormat
    let date = dateFormatter1.date(from: dateString)
    return date!
}


func getServerFormattedDateString(date : Date) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = defaultServerDateFormat
    dateFormatter.timeZone = TimeZone.current
    
    print(dateFormatter.string(from: date))
    
    return dateFormatter.string(from: date)
}


func convertServerDateStringToDate(dateString : String) -> Date{


        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = defaultServerDateFormat
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: dateString)
        return date!
}

func Doctor_Visit_Date_Time(dateString : String) -> Date{
    
    if dateString.count == 0 {
        return Date()
    } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateTimeWithoutMilliSec //"yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: dateString)
        return date!
    }
}


func convertDateToMonthStringFormat(dateString:Date) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd, yyyy"
    let dateString = dateFormatter.string(from: dateString)
    
    return dateString
}
//func convertServerDateStringToDate(dateString : String) -> Date{
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = defaultServerDateFormat
//    dateFormatter.timeZone = TimeZone.current
//    let date = dateFormatter.date(from: dateString)
//
//    return date!
//}

func getCurrentDateAndTimeInUTCFormat() -> Date
{
    return convertDateToUTCDate(date: Date(), dateFormat: dateTimeWithoutMilliSec)
}
func getUTCDateForPunch() -> String
{
    let date = NSDate()
    var formatter = DateFormatter()
    formatter.dateFormat = dateTimeWithoutMilliSec
    let defaultTimeZoneStr = formatter.string(from: date as Date)
    formatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
    let utcTimeZoneStr = formatter.string(from: date as Date)
    return utcTimeZoneStr
}

func convertDateIntoString(date: Date) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = defaultDateFomat
    dateFormatter.timeZone = utcTimeZone
    return dateFormatter.string(from: date)
}

func convertDateIntoLocalDateString(date: Date) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = defaultDateFomat
    dateFormatter.timeZone = localTimeZone
    return dateFormatter.string(from: date)
}

func convertDateIntoServerStringFormat(date: Date) -> String
{
    let dateFormatter = getUtcDateFormatter(formartString: defaultServerDateFormat)
    
    return dateFormatter.string(from: date)
}
//Error handling
func convertDateIntoServerStringFormat1(date: Date) -> String?
{
    let dateFormatter = getUtcDateFormatter(formartString: defaultServerDateFormat)
    
    return dateFormatter.string(from: date)
}

func convertDateAndTimeIntoString(date: Date) -> String
{
    let dateFormatter = getUtcDateFormatter(formartString: defaultDateAndTimeFormat)
    
    return dateFormatter.string(from: date)
}

func convertDateToDate(date: Date, dateFormat: String, timeZone: TimeZone) -> Date
{
    let dateFormatter = getLocalDateFormatter(formartString: dateFormat)
    let formatter = getLocalDateFormatter(formartString: dateFormat)
    let dateString = dateFormatter.string(from: date)
    
    let date = formatter.date(from: dateString)
    
    return date!
}

func convertDateToUTCDate(date: Date, dateFormat: String) -> Date
{
    let dateFormatter = getLocalDateFormatter(formartString: dateFormat)
    let dateString = dateFormatter.string(from: date)
    let date = dateFormatter.date(from: dateString)
    
    return date!
}

func convertDateAndTimeIntoServerString(date: Date) -> String
{
    let dateFormatter = getUtcDateFormatter(formartString: defaultDataAndTimeServerFormat)
    
    return dateFormatter.string(from: date)
}

func getDateAndTimeInFormat(dateString : String) -> Date
{
    let dateFormatter = getUtcDateFormatter(formartString: defaultDataAndTimeServerFormat)
    
    return dateFormatter.date(from: dateString.replacingOccurrences(of: "T", with: " "))!
}

func getDateAndTimeFormatWithoutMilliSecond(dateString: String) -> Date
{
    let dateFormatter = getUtcDateFormatter(formartString: dateTimeWithoutMilliSec)
    
    return dateFormatter.date(from: dateString.replacingOccurrences(of: "T", with: " "))!
}

func convertDateIntoString(dateString : String) -> Date
{
    let dateFormatter = getUtcDateFormatter(formartString: defaultServerDateFormat)
    return dateFormatter.date(from: dateString)!
}

func covertDateAndTimeIntoString(date:Date) -> String
{
    let dateFormatter = getUtcDateFormatter(formartString: defaultDataAndTimeServerFormat)
    return dateFormatter.string(from: date)
}

func getDateStringInFormatDate(dateString : String , dateFormat : String) -> Date
{
    let dateFormatter = getUtcDateFormatter(formartString: dateFormat)
    return dateFormatter.date(from: dateString)!
}

func convertDateIntoDisplayFormat(date : Date) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MMM-yyyy"
    return dateFormatter.string(from: date)
}

func convertPickerDateIntoDefault(date: Date , format : String) -> String
{
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.locale = usLocale
    formatter.timeZone = NSTimeZone.local
    return formatter.string(from: date)
}

private func getUtcDateFormatter(formartString: String) -> DateFormatter
{
    return getDateFormatter(formartString: formartString, timeZone: TimeZone.current)
}

private func getLocalDateFormatter(formartString: String) -> DateFormatter
{
    return getDateFormatter(formartString: formartString, timeZone: localTimeZone)
}

private func getDateFormatter(formartString: String, timeZone: TimeZone) -> DateFormatter
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formartString
    dateFormatter.timeZone = TimeZone.current
    return dateFormatter
}

func dateConvertFromServer(dateString : String) -> String
{
    return dateString.replacingOccurrences(of: "T", with: " ")
}

func getCurrentDateAndTime() -> Date
{
    return Date()
}

func convertDateInToDay(date : Date) -> String
{
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    return formatter.string(from: date)
}

func convertDateInRequiredFormat(date : Date , format : String) -> String
{
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}

func getCurrentDateAndTimeString() -> String{
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = dateTimeForAssets
    let dateObj = dateFormatter.string(from: Date())
    
    return dateObj
}

func getCurrentDate() -> String{
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateObj = dateFormatter.string(from: Date())
    return dateObj
}

func getDateFromString(dateString : String) -> Date {
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = localTimeZone
    dateFormatter.dateFormat = dateTimeForAssets
    let date = dateFormatter.date(from: dateString)
    if date != nil {
        return date!
        
    }
    return Date()
}

func getStringFromDate(date : Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = localTimeZone
    dateFormatter.dateFormat = dateTimeForAssets
    let dateStr = dateFormatter.string(from: date)
    return dateStr
}

func getStringFromDateforPunch(date : Date) -> String {
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = localTimeZone
    dateFormatter.dateFormat = dateTimeWithoutMilliSec
    let dateStr = dateFormatter.string(from: date)
    return dateStr
}

func getMonthNumberFromMonthString(monthString: String) -> Int
{
    switch monthString {
    case "Jan":
        return 1
    case "Feb":
        return 2
    case "Mar":
        return 3
    case "Apr":
        return 4
    case "May":
        return 5
    case "Jun":
        return 6
    case "Jul":
        return 7
    case "Aug":
        return 8
    case "Sep":
        return 9
    case "Oct":
        return 10
    case "Nov":
        return 11
    case "Dec":
        return 12
    default:
        return 0
    }
}

//MARK:- Text decoder
func decodeTextFromServer(text : String?) -> String
{
    if text == nil
    {
        return ""
    }
    else
    {
        let removedString = text!.replacingOccurrences(of: "+", with: " ")
        let decodedString = removedString.removingPercentEncoding
        
        if decodedString != nil
        {
            return decodedString!
        }
        else
        {
            return ""
        }
    }
}
func getUserTypeCode() -> String
{
    return BL_InitialSetup.sharedInstance.userTypeCode
}

func getUserTypeName() -> String
{
    return BL_InitialSetup.sharedInstance.userTypeName
}

func getRegionTypeCode() -> String
{
    return BL_InitialSetup.sharedInstance.regionTypeCode
}
func getCompanyCode() -> String
{
    return BL_InitialSetup.sharedInstance.companyCode
}

func getCompanyId() -> Int
{
    return BL_InitialSetup.sharedInstance.companyId
}

func getCompanyName() -> String
{
    return BL_InitialSetup.sharedInstance.companyName
}

func getUserName() -> String
{
    return BL_InitialSetup.sharedInstance.userName
}

func getUserPassword() -> String
{
    return BL_InitialSetup.sharedInstance.password
}

func getUserCode() -> String
{
    return BL_InitialSetup.sharedInstance.userCode
}

func getRegionCode() -> String
{
    return BL_InitialSetup.sharedInstance.regionCode
}

func getRegionName() -> String
{
    return BL_InitialSetup.sharedInstance.regionName
}

func getHDUserId() -> Int
{
    return BL_InitialSetup.sharedInstance.userId
}

func isManager() -> Bool
{
    return BL_InitialSetup.sharedInstance.isManager
}

func getUserStartDate() -> Date
{
    return BL_InitialSetup.sharedInstance.userStartDate
}

func getSessionId() -> Int
{
    return BL_InitialSetup.sharedInstance.sessionId
}

func checkNullAndNilValueForString(stringData: String?) -> String
{
    if (stringData == nil)
    {
        return ""
    }
    else if (stringData is NSNull)
    {
        return ""
    }
    
    return stringData!
}

func checkNullAndNilValueForFloat(floatData: Float?) -> Float
{
    if (floatData == nil)
    {
        return 0.0
    }
    else if (floatData is NSNull)
    {
        return 0.0
    }
    
    return floatData!
}
//MARK:- Delay in calling methods
func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

//MARK :- Search Bar Methods

func enableCancelButtonForSearchBar(searchBar:UISearchBar)
{
    let subViews = searchBar.subviews
    
    if subViews.count > 0
    {
        let subViewArray = subViews[0]
        for view : UIView in subViewArray.subviews
        {
            if view is UIButton
            {
                (view as! UIButton).isEnabled = true
            }
        }
    }
}

func getAppDelegate() -> AppDelegate
{
    return UIApplication.shared.delegate as! AppDelegate
}

//MARK :- OnBoard Methods
func checKOnBoardShown() -> Bool
{
    return DBHelper.sharedInstance.checkOnBoardShown()
}

//MARK :- Local File Manager
func getDocumentsURL() -> NSURL
{
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    return documentsURL as NSURL
}

func fileInDocumentsDirectory(filename: String) -> String
{
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL!.path
}

func saveImage (image: UIImage, path: String )
{
    let image = UIImagePNGRepresentation(image)
    do
    {
        try image?.write(to: URL(fileURLWithPath: path), options: .atomic)
    }
    catch
    {
        print(error)
    }
}

func loadImageFromPath(path: String) -> UIImage?
{
    let image = UIImage(contentsOfFile: path)
    
    if image == nil
    {
        print("missing image at: \(path)")
    }
    
    print("Loading image from path: \(path)")
    
    return image
}

func checkAppStatus() -> AppStatusEnum
{
    let appStatusObj = DBHelper.sharedInstance.getAppStatus()
    
    if (appStatusObj?.OverAll_Status == 1)
    {
        let versionUpgradeList = BL_Version_Upgrade.sharedInstance.getIncompleteVersionUpgrades()
        if versionUpgradeList.count > 0
        {
            return AppStatusEnum.PMD_PENDING
        }
        else
        {
            return AppStatusEnum.HOME
        }
    }
    else
    {
        if (appStatusObj?.Is_Login_Completed == 0)
        {
            return AppStatusEnum.Login
        }
        else if (appStatusObj?.Is_PMD_Completed == 0)
        {
            return AppStatusEnum.PMD
        }
        else if (appStatusObj?.Is_PMD_Accompanist_Completed == 0)
        {
            return AppStatusEnum.PMD_ACCOMPANIST
        }
        else
        {
            return AppStatusEnum.Login
        }
    }
}

//MARK: - TOAST VIEW
func showToastView(toastText : String)
{
    let toastView = getToastView(toastText: toastText)
    toastView.alpha = 0.0
    
    UIView.animate(withDuration: 0.3, animations: {
        toastView.alpha = 1.0
    })
    
    UIView.animate(withDuration: 0.5, delay: 3.0, options: UIViewAnimationOptions.beginFromCurrentState, animations:{
        toastView.alpha = 0.0
    }) { (value) in
        toastView.removeFromSuperview()
    }
}


//MARK: - short Time TOAST VIEW
func showToastViewWithShortTime(toastText : String)
{
    
    let toastView = getToastView(toastText: toastText)
    
    toastView.alpha = 0.0
    
    UIView.animate(withDuration: 0.3, animations: {
        toastView.alpha = 1.0
    })
    
    UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.beginFromCurrentState, animations:{
        toastView.alpha = 0.0
    }) { (value) in
        toastView.removeFromSuperview()
    }
}


func getToastView(toastText : String) -> UIView{
    removeToastView()
    SCREEN_HEIGHT = UIScreen.main.bounds.height
    SCREEN_WIDTH =  UIScreen.main.bounds.size.width
    let toastView : UIView = UIView()
    toastView.backgroundColor = UIColor.darkGray
    toastView.layer.cornerRadius = 20
    toastView.tag = 2000
    
    let toastOriginX : CGFloat = 20
    let toastWidth : CGFloat = SCREEN_WIDTH - (2 * toastOriginX)
    let fontSize : CGFloat = 14
    
    let toastLabel = UILabel()
    toastLabel.textAlignment = NSTextAlignment.center
    toastLabel.font = UIFont(name: fontRegular, size: fontSize)
    toastLabel.backgroundColor = UIColor.clear
    toastLabel.textColor = UIColor.white
    toastLabel.numberOfLines = 0
    toastLabel.text = toastText
    
    let labelPaddingX : CGFloat = 10
    let labelPaddingY : CGFloat = 12
    let bottomSpace : CGFloat = 50
    let toastLabelWidth : CGFloat = toastWidth - (2 * labelPaddingX)
    
    let textHeight = getTextSize(text: toastText, fontName: fontRegular, fontSize: fontSize, constrainedWidth: toastLabelWidth).height
    
    let toastViewHeight : CGFloat = textHeight + labelPaddingY * 2
    
    let toastLabelFrame : CGRect = CGRect(x: labelPaddingX, y: labelPaddingY, width: toastLabelWidth, height: textHeight)
    
    toastLabel.frame = toastLabelFrame
    
    let originY : CGFloat = SCREEN_HEIGHT - bottomSpace - toastViewHeight
    
    let toastViewFrame : CGRect = CGRect(x:toastOriginX, y: originY, width: toastWidth  , height: toastViewHeight)
    toastView.frame = toastViewFrame
    
    toastView.addSubview(toastLabel)
    
    let appDelegate = getAppDelegate()
    appDelegate.window?.addSubview(toastView)
    
    return toastView
}

func showVersionToastView(textColor : UIColor)
{
    removeVersionToastView()
    SCREEN_HEIGHT = UIScreen.main.bounds.height
    SCREEN_WIDTH =  UIScreen.main.bounds.size.width
    let toastView : UIView = UIView()
    toastView.backgroundColor = UIColor.clear
    toastView.tag = 8000
    
    
    let toastOriginX : CGFloat = 8
    let toastWidth : CGFloat =  158
    let toastHeight : CGFloat = 15
    let fontSize : CGFloat = 14
    
    let toastLabel = UILabel()
    toastLabel.textAlignment = NSTextAlignment.left
    toastLabel.font = UIFont(name: fontRegular, size: fontSize)
    toastLabel.backgroundColor = UIColor.clear
    toastLabel.textColor = textColor
    toastLabel.numberOfLines = 0
    toastLabel.text = getCurrentAppVersion()
    
    toastLabel.clipsToBounds = true
    
    let bottomSpace : CGFloat = 15
    let toastLabelWidth : CGFloat = toastWidth
    
    let toastViewHeight : CGFloat = toastHeight
    
    let toastLabelFrame : CGRect = CGRect(x: 0, y: 0, width: toastLabelWidth, height: toastHeight)
    
    toastLabel.frame = toastLabelFrame
    
    let originY : CGFloat = SCREEN_HEIGHT - bottomSpace - toastViewHeight
    
    let toastViewFrame : CGRect = CGRect(x:toastOriginX, y: originY, width: toastWidth  , height: toastViewHeight)
    toastView.frame = toastViewFrame
    toastView.addSubview(toastLabel)
    
    let appDelegate = getAppDelegate()
    appDelegate.window?.addSubview(toastView)
}

func removeToastView(){
    if let toastView = getAppDelegate().window?.viewWithTag(2000)
    {
        toastView.isHidden = true
        toastView.clipsToBounds = true
        toastView.removeFromSuperview()
    }
}

func removeVersionToastView()
{
    if let versionToastView = getAppDelegate().window?.viewWithTag(8000)
    {
        versionToastView.isHidden = true
        versionToastView.clipsToBounds = true
        versionToastView.removeFromSuperview()
    }
}

func showCustomActivityIndicatorView(loadingText : String)
{
    removeCustomActivityView()
    
    let backGroundView : UIView = UIView()
    backGroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    backGroundView.tag = 3000
    
    let originX : CGFloat = 20
    let customViewHeight : CGFloat = 70
    let customViewWidth : CGFloat = SCREEN_WIDTH - (2 * originX )
    let originY : CGFloat = (SCREEN_HEIGHT  - customViewHeight ) / 2
    
    let customView : UIView = UIView()
    customView.backgroundColor = UIColor.white
    customView.frame = CGRect(x: originX, y: originY, width: customViewWidth, height: customViewHeight)
    customView.layer.cornerRadius = 10
    
    
    let activitySize : CGFloat = 40
    let activityViewOriginX : CGFloat = 20
    let activityViewOriginY : CGFloat = (customViewHeight - activitySize) / 2
    
    let customActivityView = CustomActivityLoaderView()
    customActivityView.frame = CGRect(x: activityViewOriginX, y: activityViewOriginY, width: activitySize, height: activitySize)
    
    let toastLabel = UILabel()
    toastLabel.textAlignment = NSTextAlignment.left
    toastLabel.font = UIFont(name: fontRegular, size: 14)
    toastLabel.backgroundColor = UIColor.clear
    toastLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
    toastLabel.textColor = UIColor.darkGray
    toastLabel.numberOfLines = 0
    toastLabel.text = loadingText
    
    let labelOriginX : CGFloat =  (2 * activityViewOriginX) + activitySize
    let labelWidth = customViewWidth - labelOriginX
    
    toastLabel.frame = CGRect(x: labelOriginX, y: 0, width: labelWidth, height: customViewHeight)
    
    customView.addSubview(customActivityView)
    customView.addSubview(toastLabel)
    
    let appDelegate = getAppDelegate()
    backGroundView.addSubview(customView)
    backGroundView.frame = appDelegate.window!.bounds
    appDelegate.window?.addSubview(backGroundView)
    
}

func removeCustomActivityView()
{
    if let customActivityView = getAppDelegate().window?.viewWithTag(3000)
    {
        customActivityView.removeFromSuperview()
    }
}

func removeApprovalPopUp()
{
    if let popUpView = getAppDelegate().window?.viewWithTag(9000)
    {
        popUpView.removeFromSuperview()
    }
    
}

//MARK:- Picker View

func getTimePickerView() ->  UIDatePicker
{
    let timePicker = UIDatePicker()
    timePicker.locale = usLocale
    timePicker.datePickerMode = UIDatePickerMode.time
    timePicker.frame.size.height = timePickerHeight
    timePicker.minuteInterval = 5
    timePicker.backgroundColor = UIColor.lightGray
    return timePicker
}

func getDatePickerView() -> UIDatePicker
{
    let datePicker = UIDatePicker()
    let locale = usLocale
    datePicker.locale = locale as Locale
    datePicker.datePickerMode = UIDatePickerMode.date
    datePicker.frame.size.height = timePickerHeight
    datePicker.backgroundColor = UIColor.lightGray
    return datePicker
}

func getPicker() -> UIPickerView
{
    let picker: UIPickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 160))
    picker.backgroundColor = UIColor.lightGray
    
    return picker
}

func getToolBar() -> UIToolbar
{
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:SCREEN_WIDTH, height:50))
    doneToolbar.barStyle = UIBarStyle.default
    doneToolbar.isTranslucent = true
    return doneToolbar
}

func getTimeIn12HrFormat(date: Date, timeZone: TimeZone) -> String
{
    let formatter = getDateFormatter(formartString: timeFormat, timeZone: timeZone)
    formatter.locale = usLocale
    return formatter.string(from: date)
}

func convert12HrTo24Hr(timeString: String) -> String
{
    let dateAsString = timeString
    let dateFormatter = DateFormatter()
    
    dateFormatter.locale = usLocale
    dateFormatter.dateFormat = timeFormat
    
    let date = dateFormatter.date(from: dateAsString)
    dateFormatter.dateFormat = "HH:mm"
    if(date != nil)
    {
        let date24 = dateFormatter.string(from: date!)
        return date24
    }
    else
    {
    return timeString
    }
}

func convertStringToDate(stringDate: String) -> String
{
    let formatter = DateFormatter()
    formatter.dateFormat = dateTimeWithoutMilliSec
    let date = formatter.date(from: stringDate)!
    let worktime_Dateformat = DateFormatter()
    worktime_Dateformat.dateFormat = timeFormat
    return worktime_Dateformat.string(from: date)
}


func convertStringToDate(string: String, timeZone: TimeZone, format: String) -> Date
{
    let formatter = getDateFormatter(formartString: format, timeZone: timeZone)
    formatter.locale = usLocale
    return formatter.date(from: string)!
}


func convertDateToString(date: Date, timeZone: TimeZone, format: String) -> String
{
    let formatter = getDateFormatter(formartString: format, timeZone: timeZone)
    return formatter.string(from: date)
}

func stringFromDate(date1: Date) -> String
{
    return getTimeIn12HrFormat(date: date1, timeZone: NSTimeZone.local)
}

func getDateAndTimeInDisplayFormat(date: Date) -> String
{
    let formatter = getUtcDateFormatter(formartString: displayDateAndTimeFormat)
    formatter.locale = usLocale
    return formatter.string(from: date)
}

func getNextMonth(date: Date) -> String{
    
    let date =  NSCalendar.current.date(byAdding: .month, value: 1, to: date)
    return convertDateIntoServerDisplayformat(date: date!)
}

func getPreviousMonth(date: Date) -> String{
    
    let date = NSCalendar.current.date(byAdding: .month, value: -1, to: date)
    return convertDateIntoServerDisplayformat(date: date!)
    
}

func getUserModelObj() -> UserMasterModel?
{
    let userObj : UserMasterModel = UserMasterModel()
    userObj.User_Name = BL_InitialSetup.sharedInstance.userName
    userObj.User_Type_Name = BL_InitialSetup.sharedInstance.userTypeName
    userObj.Employee_name = BL_InitialSetup.sharedInstance.employeeName
    userObj.Region_Name = BL_InitialSetup.sharedInstance.regionName
    userObj.Region_Code = BL_InitialSetup.sharedInstance.regionCode
    userObj.User_Code = BL_InitialSetup.sharedInstance.userCode
    userObj.User_Start_Date = BL_InitialSetup.sharedInstance.userStartDate
    
    return userObj
}

//For exception handling
func getErrorLogDefaultExtProperty(functionName: String, className: String, lineNo: Int) -> NSMutableDictionary
{
    let userDetail: NSMutableDictionary = ["User_Name": getUserName(), "User_Code": getUserCode(), "Company_Code": getCompanyCode(), "Region_Code": getRegionCode(), "Function": functionName, "Class": className, "Line": String(lineNo)]
    
    return userDetail
}

func checkIfSpecialCharacterFound(restrictedCharacter : String ,remarkTxt : String) -> Bool
{
    let validString = NSCharacterSet(charactersIn:restrictedCharacter)
    
    if remarkTxt.rangeOfCharacter(from: validString as CharacterSet) != nil
    {
        return true
    }
    
    return false
}

func validateFromToTime(fromTime : String , toTime : String) -> Bool
{
    let fromDate = convertTimetoValidate(time: fromTime)
    
    let toDate = convertTimetoValidate(time: toTime)
    if fromDate.timeIntervalSince1970 < toDate.timeIntervalSince1970
    {
        return true
    }
    
    return false
}

func convertTimetoValidate(time : String) -> Date
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "hh:mm a"
    dateFormatter.locale = usLocale
    let date = dateFormatter.date(from: time)
    return date!
}

func checkToDateIsGreater(fromDate : Date , toDate : Date) -> Bool
{
    if fromDate.timeIntervalSince1970 <= toDate.timeIntervalSince1970
    {
        return true
    }
    
    return false
}
func checkToDateIsGreaterandEqual (fromDate : Date , toDate : Date) -> Bool
{
    if (fromDate.timeIntervalSince1970 <= toDate.timeIntervalSince1970) || (fromDate.timeIntervalSince1970 == toDate.timeIntervalSince1970)
    {
        return true
    }
    
    return false
}


func isValidFloatNumber(value: String) -> Bool
{
    var flag: Bool!
    
    if Double(value) != nil
    {
        flag = true
    }
    else
    {
        flag = false
    }
    
    return flag
}

func isValidIntegerNumber(value: String) -> Bool
{
    var flag: Bool!
    
    if Int(value) != nil
    {
        flag = true
    }
    else
    {
        flag = false
    }
    
    return flag
}

func maxNumberValidationCheck(value : String, maxVal : Float) -> Bool
{
    let floatVal = Float(value)
    var flag : Bool = false
    
    let startVal : Float = 0
    if floatVal! >= startVal && floatVal! <= maxVal
    {
        flag = true
    }
    
    return flag
}

func getLatitude() -> String
{
    return currentLat
}

func getLongitude() -> String
{
    return currentLong
}

func getLocationAuthorizationStatus() -> Bool
{
    var accessGiven: Bool = false
    
    if CLLocationManager.locationServicesEnabled()
    {
        let status = CLLocationManager.authorizationStatus()
        
        if (status == .authorizedWhenInUse || status == .authorizedAlways)
        {
            accessGiven = true
        }
    }
    
    return accessGiven
}

func isLocationMandatory() -> Bool
{
    if (PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.APP_GEO_LOCATION_MANDATORY) == PrivilegeValues.YES.rawValue)
    {
        return true
    }
    else
    {
        return false
    }
}

func getGeoFencingDeviationValue() -> Double
{
    let privValue = PrivilegesAndConfigSettings.sharedInstance.getPrivilegeValue(privilegeName: PrivilegeNames.GEO_FENCING_DEVIATION_LIMIT_IN_KM)
    
    return Double(privValue)!
}

func isGeoFencingEnabled() -> Bool
{
    if (getGeoFencingDeviationValue() > 0)
    {
        return true
    }
    else
    {
        return false
    }
}

func canShowLocationMandatoryAlert() -> Bool
{
    var showAlert: Bool = false
    
    if (isLocationMandatory())
    {
        if (!getLocationAuthorizationStatus())
        {
            showAlert = true
        }
    }
    
    return showAlert
}

func isSingleDeviceLoginEnabled() -> Bool
{
    var returnValue: Bool = false
    let privValue = PrivilegesAndConfigSettings.sharedInstance.getConfigSettingValue(configName: ConfigNames.IS_SINGLE_DEVICE_LOGIN_ENABLED).uppercased()
    
    if(privValue == ConfigValues.YES.rawValue.uppercased())
    {
        returnValue = true
    }
    
    return returnValue
}

func isValidNumberForPobAmt(string : String) -> Bool
{
    let inverseSet = NSCharacterSet(charactersIn:"0123456789.").inverted
    let components = string.components(separatedBy:inverseSet)
    let filtered = components.joined(separator: "")
    return string == filtered
}

func setStatusBarColor(color: UIColor)
{
    if let uiView = UIApplication.shared.value(forKey: "statusBar") as? UIView
    {
        uiView.backgroundColor = color
    }
}

func getMonthNumberFromDate(date: Date) -> Int
{
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    
    return components.month!
}

func getYearFromDate(date: Date) -> Int
{
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    
    return components.year!
}

func getMonthName(monthNumber: Int) -> String
{
    let formate = DateFormatter()
    let monthNames = formate.standaloneMonthSymbols
    let monthName = monthNames?[(monthNumber - 1)]
    return monthName!
}

func getPopUpMsg(Flag : Int , status : Int , type : String) -> String
{
    if Flag == DCRFlag.fieldRcpa.rawValue && status == DCRStatus.approved.rawValue
    {
        return "Your \(type) Field Approved Successfully"
    }
    else if Flag == DCRFlag.fieldRcpa.rawValue && status == DCRStatus.unApproved.rawValue
    {
        return "Your \(type) Field Rejected Successfully"
    }
    else if Flag == DCRFlag.fieldRcpa.rawValue && status == 4
    {
        return "Unable to Approve Field. Please Try Again"
    }
    else if Flag == DCRFlag.fieldRcpa.rawValue && status == 5
    {
        return "Unable to Reject Field. Please Try Again"
    }
    else if Flag == DCRFlag.attendance.rawValue && status == DCRStatus.approved.rawValue
    {
        return "Your \(type) Office Approved Successfully"
    }
    else if Flag == DCRFlag.attendance.rawValue && status == DCRStatus.unApproved.rawValue
    {
        return "Your \(type) Office Rejected Successfully"
    }
    else if Flag == DCRFlag.attendance.rawValue && status == 4
    {
        return "Unable to Approve Office.Please Try Again"
    }
    else if Flag == DCRFlag.attendance.rawValue && status == 5
    {
        return "Unable to Reject Office.Please Try Again"
    }
    else if Flag == DCRFlag.leave.rawValue && status == DCRStatus.approved.rawValue
    {
        return "Your \(type) Not Working Approved Successfully"
    }
    else if Flag == DCRFlag.leave.rawValue && status == DCRStatus.unApproved.rawValue
    {
        return "Your \(type) Not Working Rejected Successfully"
    }
    else if Flag == DCRFlag.leave.rawValue && status == 4
    {
        return "Unable to Approve Not Working Try Again"
    }
    else if Flag == DCRFlag.leave.rawValue && status == 5
    {
        return "Unable to Reject Not Working.Please Try Again"
    }
    
    return ""
    
}

func checkIsCapturingLocation() -> Bool
{
    var isCaptured : Bool = false
    
    if (isLocationMandatory())
    {
        if getLongitude() != EMPTY && getLatitude() != EMPTY
        {
            isCaptured = true
        }
    }
    else
    {
        isCaptured = true
    }
    
    return isCaptured
}

func isSplCharAvailable(charSet: String, stringValue: String) -> Bool
{
    var isSplCharAvail: Bool = false
    
    let characterset = CharacterSet(charactersIn: charSet)
    
    if stringValue.rangeOfCharacter(from: characterset.inverted) != nil
    {
        isSplCharAvail = true
    }
    
    return isSplCharAvail
}

func condenseWhitespace(stringValue: String) -> String
{
    return stringValue.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        .filter { !$0.isEmpty }
        .joined(separator: " ")
}

func RemoveUnwantedSpaceInString(value: String) -> String
{
    let newString = value.trimmingCharacters(in: NSCharacterSet.whitespaces)
    return newString
}

func getDCRActivityName(dcrFlag : Int) -> String
{
    var flag : String = ""
    
    if dcrFlag == DCRFlag.fieldRcpa.rawValue
    {
        flag = DCRActivityName.fieldRcpa.rawValue
    }
    else if dcrFlag == DCRFlag.attendance.rawValue
    {
        flag = DCRActivityName.attendance.rawValue
    }
    else if dcrFlag == DCRFlag.leave.rawValue
    {
        flag = DCRActivityName.leave.rawValue
    }
    
    return flag
}

func containSameElements(firstArray: [String], secondArray: [String]) -> Bool
{
    if firstArray.count != secondArray.count
    {
        return false
    }
    else
    {
        let sortedFirstArr = firstArray.sorted()
        let sortedSecondArr = secondArray.sorted()
        return sortedFirstArr == sortedSecondArr
    }
}

//MARK:- Character set method
func getCharacterSet() -> CharacterSet
{
    let mutableSet = NSMutableCharacterSet()
    
    mutableSet.formUnion(with: CharacterSet.alphanumerics)
    
    mutableSet.formUnion(with: CharacterSet.urlUserAllowed)
    
    mutableSet.formUnion(with: CharacterSet.urlPasswordAllowed)
    
    mutableSet.formUnion(with: CharacterSet.urlHostAllowed)
    
    mutableSet.formUnion(with: CharacterSet.urlQueryAllowed)
    
    mutableSet.formUnion(with: CharacterSet.urlFragmentAllowed)
    
    return mutableSet as CharacterSet
}

//MARK:- Show/Hide Toastview
func showAttachmentToastView(text: String)
{
    let view = getAppDelegate().window?.viewWithTag(110) as? ToastView
    if view == nil
    {
        showToastFlag = true
        let view = Bundle.main.loadNibNamed("ToastView", owner: nil, options: nil)?[0] as! ToastView
        view.errorLbl.text = text
        view.updateViewProperties()
        view.closeBtn.isUserInteractionEnabled = false
        let lblHeight = getTextSize(text: text, fontName: fontSemiBold, fontSize: 14.0, constrainedWidth: SCREEN_WIDTH - 40).height
        view.frame = CGRect(x: 10, y: 10, width: SCREEN_WIDTH - 20, height: 55 + lblHeight)
        getAppDelegate().window?.addSubview(view)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            view.frame.origin.y = 70.0
        }, completion: { (finished: Bool) in
            view.closeBtn.isUserInteractionEnabled = true
            delayWithSeconds(5)
            {
                if showToastFlag == true
                {
                    hideAttachmentToastView()
                }
            }
        })
    }
}

func hideAttachmentToastView()
{
    if let view = getAppDelegate().window?.viewWithTag(110) as? ToastView
    {
        showToastFlag = false
        view.closeBtn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
            view.frame.origin.y = 0.0
        }, completion: { (finished: Bool) in
            view.closeBtn.isUserInteractionEnabled = true
            view.removeFromSuperview()
        })
    }
}

//MARK:- Toast view - set corner radius
func setCornerRadius(view: UIView, corners: UIRectCorner)
{
    let path = UIBezierPath(roundedRect:view.bounds,
                            byRoundingCorners: corners,
                            cornerRadii: CGSize(width: 15, height:  15))
    
    let maskLayer = CAShapeLayer()
    
    maskLayer.path = path.cgPath
    view.layer.mask = maskLayer
}

//MARK:- Set Split view controller as a root
func setSplitViewRootController(backFromAsset: Bool, isCustomerMasterEdit: Bool, customerListPageSouce: Int)
{
    let root_sb = UIStoryboard(name: Constants.StoaryBoardNames.SplitViewSb, bundle: nil)
    let root_vc = root_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.SplitViewVCID) as! GlobalSplitViewController
    
    if backFromAsset == false
    {
        root_vc.delegate = root_vc
    }
    
    let master_vc = root_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.CustomerVCID) as! CustomerTableViewController
    master_vc.backFromAsset = backFromAsset
    master_vc.isCustomerMasterEdit = isCustomerMasterEdit
    master_vc.doctorListPageSource = customerListPageSouce
    
    let detail_sb = UIStoryboard(name: MoreViewMasterSb, bundle: nil)
    let detail_vc = detail_sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.DoctorDetailsVcID) as! DoctorDetailsViewController
    detail_vc.isCustomerMasterEdit = isCustomerMasterEdit
    detail_vc.doctorListPageSource = customerListPageSouce
    
    let userWrappedList = BL_DCR_Doctor_Visit.sharedInstance.getDoctorMasterList(regionCode: CustomerModel.sharedInstance.regionCode)!
    
    if backFromAsset == false
    {
        if userWrappedList.count > 0
        {
            let firstModel = userWrappedList.first
            BL_DoctorList.sharedInstance.regionCode = (firstModel?.Region_Code)!
            BL_DoctorList.sharedInstance.customerCode = (firstModel?.Customer_Code)!
            BL_DoctorList.sharedInstance.doctorTitle = (firstModel?.Customer_Name)!
        }
        else
        {
            detail_vc.isEmptyState = true
        }
    }
    
    master_vc.delegate = detail_vc
    
    detail_vc.navigationItem.leftItemsSupplementBackButton = true
    detail_vc.navigationItem.leftBarButtonItem = root_vc.displayModeButtonItem
    
    let master_vc_nc = UINavigationController(rootViewController: master_vc)
    let detail_vc_nc = UINavigationController(rootViewController: detail_vc)
    
    root_vc.viewControllers = [master_vc_nc, detail_vc_nc]
    
    getAppDelegate().window?.rootViewController = root_vc
    getAppDelegate().window?.makeKeyAndVisible()
}

func getUTCOffsetValue() -> Int
{
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    let UTCOffset = secondsFromGMT / 60
    return UTCOffset
}


func getOffset() -> String
{
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    let UTCOffset = secondsFromGMT / 60
    let hours = secondsFromGMT/3600
    let minutes = abs(secondsFromGMT/60) % 60
    let tz = String(format: "%+.2d:%.2d", hours, minutes)
    return tz
}


func getCurrentTimeZone() -> String
{
    let timeZone = TimeZone.current.abbreviation()
    
    if timeZone == "IST"
    {
        return "+5.30"
    }
    
    let newTimeZone = timeZone?.components(separatedBy: "T")
    
    if (newTimeZone?.count)! > 0
    {
        if (newTimeZone?.last?.count)! > 0
        {
            return (newTimeZone!.last)!
        }
        
        return "0"
    }
    
    return "0"
}

//MARK:- Doc type
func getDocTypeVal(docType: Int) -> String
{
    switch docType {
    case 1:
        return Constants.DocType.image
    case 2:
        return Constants.DocType.video
    case 3:
        return Constants.DocType.audio
    case 4:
        return Constants.DocType.document
    case 5:
        return Constants.DocType.zip
    default:
        return ""
    }
}

//MARK: - Get Thumbnail Icon
func getAssetThumbnailIcon(docType: Int) -> UIImage
{
    switch docType
    {
    case 1:
        return UIImage(named: "icon-image-thumbnail")!
    case 2:
        return UIImage(named: "icon-video-thumbnail")!
    case 3:
        return UIImage(named: "icon-audio-thumbnail")!
    case 4:
        return UIImage(named: "icon-pdf-thumbnail")!
    default:
        return UIImage(named: "icon-image-thumbnail")!
    }
}

//MARK: - Doctor visit - Show asset play time
func getPlayTime(timeVal: String) -> String
{
    var timeString: String = ""
    
    if let getTimeVal = Int(timeVal)
    {
        let MINUTES_IN_AN_HOUR: Int = 60
        let SECONDS_IN_A_MINUTE: Int = 60
        
        var seconds = getTimeVal % SECONDS_IN_A_MINUTE
        let totalMinutes = getTimeVal / SECONDS_IN_A_MINUTE
        var minutes = totalMinutes % MINUTES_IN_AN_HOUR
        let hours = totalMinutes / MINUTES_IN_AN_HOUR
        
        if hours > 0
        {
            if minutes > 0
            {
                if seconds == 0
                {
                    seconds = 00
                }
                if minutes == 0
                {
                    minutes = 00
                }
                timeString = "\(hours):\(minutes):\(seconds) (\(HOURS))"
            }
        }
        else
        {
            if minutes > 0
            {
                if seconds == 0
                {
                    seconds = 00
                }
                if minutes <= 9
                {
                    timeString = "0\(minutes):"
                }
                else
                {
                    timeString = "\(minutes):"
                }
                if seconds <= 9
                {
                    timeString = timeString + "0\(seconds) (\(MINUTES))"
                }
                else
                {
                    timeString = timeString + "\(seconds) (\(MINUTES))"
                }
            }
            else
            {
                if seconds <= 9
                {
                    timeString = "0\(seconds) (\(SECONDS))"
                }
                else
                {
                    timeString = "\(seconds) (\(SECONDS))"
                }
            }
        }
    }
    
    return timeString
}

func setRoundedCornersForImageVW(imageVw : UIImageView){
    imageVw.layer.cornerRadius = imageVw.frame.height/2
    imageVw.clipsToBounds = true
    
}

func convertDateIntoServerDisplayformat(date: Date) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM - dd - yyyy - EEEE" // "dd - MMM - yyyy - EEEE"
    dateFormatter.timeZone = utcTimeZone
    return dateFormatter.string(from: date)
}


// MARK : Pan gesture Direction
public enum Direction: Int
{
    case Up
    case Down
    case Left
    case Right
    
    public var isX: Bool { return self == .Left || self == .Right }
    public var isY: Bool { return !isX }
}

func panGestureDirection(velocity : CGPoint) -> Direction
{
    let vertical = fabs(velocity.y) > fabs(velocity.x)
    
    switch (vertical, velocity.x, velocity.y)
    {
    case (true, _, let y) where y < 0: return .Up
    case (true, _, let y) where y > 0: return .Down
    case (false, let x, _) where x > 0: return .Right
    case (false, let x, _) where x < 0: return .Left
    default: return .Up
    }
    
}
extension UIView
{
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

func imageResize(imageObj:UIImage, sizeChange:CGSize)-> UIImage
{
    let hasAlpha = false
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
    
    UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
    imageObj.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext() // !!!
    return scaledImage!
}
func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true,viewController: UIViewController) -> UIActivityIndicatorView {
    
    let originX : CGFloat = 20
    let customViewHeight : CGFloat = 70
    let _ : CGFloat = SCREEN_WIDTH - (2 * originX )
    let originY : CGFloat = (SCREEN_HEIGHT  - customViewHeight ) / 2
    
    
    let mainContainer: UIView = UIView()
    //  mainContainer.center = viewContainer.center
    mainContainer.backgroundColor = UIColor.white
    mainContainer.alpha = 0.5
    mainContainer.tag = 789456123
    mainContainer.isUserInteractionEnabled = false
    
    let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:originX,y: originY,width: 80,height: 80))
    viewBackgroundLoading.center = viewController.view.center
    viewBackgroundLoading.backgroundColor = UIColor.black
    viewBackgroundLoading.alpha = 0.8
    viewBackgroundLoading.clipsToBounds = true
    viewBackgroundLoading.layer.cornerRadius = 15
    
    let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
    activityIndicatorView.activityIndicatorViewStyle =
        UIActivityIndicatorViewStyle.whiteLarge
    activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
    if startAnimate!{
        viewController.view.isUserInteractionEnabled = false
        viewBackgroundLoading.addSubview(activityIndicatorView)
        mainContainer.addSubview(viewBackgroundLoading)
        viewContainer.addSubview(mainContainer)
        activityIndicatorView.startAnimating()
    }else{
        viewController.view.isUserInteractionEnabled = true
        for subview in viewContainer.subviews{
            if subview.tag == 789456123{
                subview.removeFromSuperview()
            }
        }
    }
    return activityIndicatorView
}

func isOnlyAlphabet(stringData: String) -> Bool
{
    let charSet = CharacterSet(charactersIn: Constants.CharSet.Alphabet)
    
    if (stringData.trimmingCharacters(in: charSet) != EMPTY)
    {
        return false
    }
    else
    {
        return true
    }
}

func isAlphabetAndSpace(stringData: String) -> Bool
{
    let charSet = CharacterSet(charactersIn: Constants.CharSet.Alphabet + " ")
    
    if (stringData.trimmingCharacters(in: charSet) != EMPTY)
    {
        return false
    }
    else
    {
        return true
    }
}

func isAlphaNumeric(stringData: String) -> Bool
{
    let charSet = CharacterSet.alphanumerics
    
    if (stringData.trimmingCharacters(in: charSet) != EMPTY)
    {
        return false
    }
    else
    {
        return true
    }
}

func isAlphaNumericAndSpace(stringData: String) -> Bool
{
    let charSet = CharacterSet(charactersIn: Constants.CharSet.Alphabet + Constants.CharSet.Numeric + " ")
    
    if (stringData.trimmingCharacters(in: charSet) != EMPTY)
    {
        return false
    }
    else
    {
        return true
    }
}

func isNumericOnly(stringData: String) -> Bool
{
    let charSet = CharacterSet(charactersIn: Constants.CharSet.Numeric)
    
    if (stringData.trimmingCharacters(in: charSet) != EMPTY)
    {
        return false
    }
    else
    {
        return true
    }
}

func isValidEmail(stringData: String) -> Bool
{
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: stringData)
}

func getNumberOfDaysBetweenTwoDates(firstDate: Date, secondDate: Date) -> Int
{
    let calendar = NSCalendar.current
    let components = calendar.dateComponents([.day], from: firstDate, to: secondDate)
    
    return components.day!
}

func getNumberOfMinutesBetweenTwoDates(firstDate: Date, secondDate: Date) -> Int
{
    let calendar = NSCalendar.current
    let components = calendar.dateComponents([.minute], from: firstDate, to: secondDate)
    
    return components.minute!
}

func getCurrentLocaiton() -> GeoLocationModel
{
    let latitude = getLatitude()
    let longitude = getLongitude()
    let currentLocation = GeoLocationModel()
    
    if (latitude != EMPTY && longitude != EMPTY)
    {
        currentLocation.Latitude = Double(latitude)
        currentLocation.Longitude = Double(longitude)
    }
    else
    {
        currentLocation.Latitude = 0
        currentLocation.Longitude = 0
    }
    
    currentLocation.Address_Id = nil
    
    return currentLocation
}

//func goToSettingsPage()
//{
//    guard let settingsUrl = URL(string: "App-Prefs:root=MOBILE_DATA_SETTINGS_ID") else {
//        return
//    }
//
//    if UIApplication.shared.canOpenURL(settingsUrl)
//    {
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                print("Settings opened: \(success)") // Prints true
//            })
//        }
//        else
//        {
//            // Fallback on earlier versions
//            if UIApplication.shared.canOpenURL(settingsUrl) {
//                UIApplication.shared.openURL(settingsUrl)
//            }
//        }
//    }
//}

func navigateToUploaAttachment()
{
    if (DBHelper.sharedInstance.getUploadableAttachments().count > 0 || DBHelper.sharedInstance.getChemistUploadableAttachments().count > 0)
    {
        if let navigationController = getAppDelegate().root_navigation
        {
            let sb = UIStoryboard(name: DCRCalenderSb, bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: Constants.ViewControllerNames.AttachmentUploadVCID)
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(vc, animated: false)
        }
    }
}

func uploadEDetailingAnalytics(attachmentUploadPending: Bool)
{
    showCustomActivityIndicatorView(loadingText: "Please wait...")
    BL_UploadAnalytics.sharedInstance.checkAnalyticsStatus()
}

func stringify(json: AnyObject, prettyPrinted: Bool = false) -> String {
    
    let json = json as! DCRParameterV59
    let postData = ["CompanyCode":json.CompanyCode,"UserCode":json.UserCode,"RegionCode":json.RegionCode,"StartDate":json.StartDate,"EndDate":json.EndDate,"DCRStatus":json.DCRStatus,"Flag":json.Flag]
    
    do {
        let data = try JSONSerialization.data(withJSONObject: postData, options: JSONSerialization.WritingOptions.prettyPrinted)
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
        }
    } catch
    {
        print(error)
    }
    
    return ""
}

func stringifyforPob(json: AnyObject, prettyPrinted: Bool = false) -> String {
    
    let json = json as! DCRParameterPOB
    let postData = ["Company_Code":json.Company_Code,"User_Code":json.User_Code,"Region_Code":json.Region_Code,"Flag":json.Flag,"Order_Status":json.Order_Status]
    
    do {
        let data = try JSONSerialization.data(withJSONObject: postData, options: JSONSerialization.WritingOptions.prettyPrinted)
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            return string
        }
    } catch
    {
        print(error)
    }
    
    return ""
}

func getcurrenttime() -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a "
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    
    let dateString = formatter.string(from: Date())
    return dateString
}

func lastDay(ofMonth m: Int, year y: Int) -> Int {
    let cal = Calendar.current
    var comps = DateComponents(calendar: cal, year: y, month: m)
    comps.setValue(m + 1, for: .month)
    comps.setValue(0, for: .day)
    let date = cal.date(from: comps)!
    return cal.component(.day, from: date)
}
func getcurrenttimezone() -> String {
    let timezone =   { return TimeZone.current.identifier }
    return timezone()
}
