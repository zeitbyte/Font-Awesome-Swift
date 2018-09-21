import Foundation
import UIKit

public extension UITextField {

    public func setRightViewFAIcon(icon: FAType, rightViewMode: UITextFieldViewMode = .always, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = .black, backgroundColor: UIColor = .clear, size: CGSize? = nil) {
        FontLoader.loadFontIfNeeded()

        let image = UIImage(icon: icon, size: size ?? CGSize(width: 30, height: 30), orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
        let imageView = UIImageView.init(image: image)

        self.rightView = imageView
        self.rightViewMode = rightViewMode
    }

    public func setLeftViewFAIcon(icon: FAType, leftViewMode: UITextFieldViewMode = .always, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = .black, backgroundColor: UIColor = .clear, size: CGSize? = nil) {
        FontLoader.loadFontIfNeeded()

        let image = UIImage(icon: icon, size: size ?? CGSize(width: 30, height: 30), orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
        let imageView = UIImageView.init(image: image)

        self.leftView = imageView
        self.leftViewMode = leftViewMode
    }
}

public extension UIBarButtonItem {

    /**
     To set an icon, use i.e. `barName.FAIcon = FAType.FAGithub`
     */
    func setFAIcon(icon: FAType, iconSize: CGFloat) {
        FontLoader.loadFontIfNeeded()
        let font = UIFont(name: FAStruct.FontName, size: iconSize)
        assert(font != nil, FAStruct.ErrorAnnounce)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .selected)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .highlighted)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .disabled)
        title = icon.text
    }

    /**
     To set an icon, use i.e. `barName.setFAIcon(FAType.FAGithub, iconSize: 35)`
     */
    var FAIcon: FAType? {
        set {
            FontLoader.loadFontIfNeeded()
            let font = UIFont(name: FAStruct.FontName, size: 23)
            assert(font != nil,FAStruct.ErrorAnnounce)
            setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
            setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .selected)
            setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .highlighted)
            setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .disabled)
            title = newValue?.text
        }
        get {
            guard let title = title, let index = FAIcons.index(of: title) else { return nil }
            return FAType(rawValue: index)
        }
    }

    func setFAText(prefixText: String, icon: FAType?, postfixText: String, size: CGFloat) {
        FontLoader.loadFontIfNeeded()
        let font = UIFont(name: FAStruct.FontName, size: size)
        assert(font != nil, FAStruct.ErrorAnnounce)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .selected)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .highlighted)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .disabled)

        var text = prefixText
        if let iconText = icon?.text {
            text += iconText
        }
        text += postfixText
        title = text
    }
}


public extension UIButton {

    /**
     To set an icon, use i.e. `buttonName.setFAIcon(FAType.FAGithub, forState: .Normal)`
     */
    func setFAIcon(icon: FAType, forState state: UIControlState) {
        FontLoader.loadFontIfNeeded()
        guard let titleLabel = titleLabel else { return }
        setAttributedTitle(nil, for: state)
        let font = UIFont(name: FAStruct.FontName, size: titleLabel.font.pointSize)
        assert(font != nil, FAStruct.ErrorAnnounce)
        titleLabel.font = font!
        setTitle(icon.text, for: state)
    }

    /**
     To set an icon, use i.e. `buttonName.setFAIcon(FAType.FAGithub, iconSize: 35, forState: .Normal)`
     */
    func setFAIcon(icon: FAType, iconSize: CGFloat, forState state: UIControlState) {
        setFAIcon(icon: icon, forState: state)
        guard let fontName = titleLabel?.font.fontName else { return }
        titleLabel?.font = UIFont(name: fontName, size: iconSize)
    }

    func setFAText(prefixText: String, icon: FAType?, postfixText: String, size: CGFloat?, forState state: UIControlState, iconSize: CGFloat? = nil) {
        setTitle(nil, for: state)
        FontLoader.loadFontIfNeeded()
        guard let titleLabel = titleLabel else { return }
        let attributedText = attributedTitle(for: .normal) ?? NSAttributedString()
        let  startFont =  attributedText.length == 0 ? nil : attributedText.attribute(NSAttributedStringKey.font, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attributedText.length == 0 ? nil : attributedText.attribute(NSAttributedStringKey.font, at: attributedText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = titleLabel.font
        if let f = startFont , f.fontName != FAStruct.FontName  {
            textFont = f
        } else if let f = endFont , f.fontName != FAStruct.FontName  {
            textFont = f
        }
        if let fontSize = size {
            textFont = textFont?.withSize(fontSize)
        }
        var textColor: UIColor = .black
        attributedText.enumerateAttribute(NSAttributedStringKey.foregroundColor, in:NSMakeRange(0,attributedText.length), options:.longestEffectiveRangeNotRequired) {
            value, range, stop in
            if value != nil {
                textColor = value as! UIColor
            }
        }

        let textAttributes = [NSAttributedStringKey.font: textFont!, NSAttributedStringKey.foregroundColor: textColor] as [NSAttributedStringKey : Any]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttributes)

        if let iconText = icon?.text {
            let iconFont = UIFont(name: FAStruct.FontName, size: iconSize ?? size ?? titleLabel.font.pointSize)!
            let iconAttributes = [NSAttributedStringKey.font: iconFont, NSAttributedStringKey.foregroundColor: textColor] as [NSAttributedStringKey : Any]

            let iconString = NSAttributedString(string: iconText, attributes: iconAttributes)
            prefixTextAttribured.append(iconString)
        }
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttributes)
        prefixTextAttribured.append(postfixTextAttributed)

        setAttributedTitle(prefixTextAttribured, for: state)
    }

    func setFATitleColor(color: UIColor, forState state: UIControlState = .normal) {
        FontLoader.loadFontIfNeeded()

        let attributedString = NSMutableAttributedString(attributedString: attributedTitle(for: state) ?? NSAttributedString())
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSMakeRange(0, attributedString.length))

        setAttributedTitle(attributedString, for: state)
        setTitleColor(color, for: state)
    }
}


public extension UILabel {

    /**
     To set an icon, use i.e. `labelName.FAIcon = FAType.FAGithub`
     */
    var FAIcon: FAType? {
        set {
            guard let newValue = newValue else { return }
            FontLoader.loadFontIfNeeded()
            let fontAwesome = UIFont(name: FAStruct.FontName, size: self.font.pointSize)
            assert(font != nil, FAStruct.ErrorAnnounce)
            font = fontAwesome!
            text = newValue.text
        }
        get {
            guard let text = text, let index = FAIcons.index(of: text) else { return nil }
            return FAType(rawValue: index)
        }
    }

    /**
     To set an icon, use i.e. `labelName.setFAIcon(FAType.FAGithub, iconSize: 35)`
     */
    func setFAIcon(icon: FAType, iconSize: CGFloat) {
        FAIcon = icon
        font = UIFont(name: font.fontName, size: iconSize)
    }

    func setFAColor(color: UIColor) {
        FontLoader.loadFontIfNeeded()
        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString())
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSMakeRange(0, attributedText!.length))
        textColor = color
    }

    func setFAText(prefixText: String, icon: FAType?, postfixText: String, size: CGFloat?, iconSize: CGFloat? = nil) {
        text = nil
        FontLoader.loadFontIfNeeded()

        let attrText = attributedText ?? NSAttributedString()
        let startFont = attrText.length == 0 ? nil : attrText.attribute(NSAttributedStringKey.font, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attrText.length == 0 ? nil : attrText.attribute(NSAttributedStringKey.font, at: attrText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = font
        if let f = startFont , f.fontName != FAStruct.FontName  {
            textFont = f
        } else if let f = endFont , f.fontName != FAStruct.FontName  {
            textFont = f
        }
        let textAttribute = [NSAttributedStringKey.font : textFont!]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttribute)

        if let iconText = icon?.text {
            let iconFont = UIFont(name: FAStruct.FontName, size: iconSize ?? size ?? font.pointSize)!
            let iconAttribute = [NSAttributedStringKey.font : iconFont]

            let iconString = NSAttributedString(string: iconText, attributes: iconAttribute)
            prefixTextAttribured.append(iconString)
        }
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttribute)
        prefixTextAttribured.append(postfixTextAttributed)

        attributedText = prefixTextAttribured
    }
}


// Original idea from https://github.com/thii/FontAwesome.swift/blob/master/FontAwesome/FontAwesome.swift
public extension UIImageView {

    /**
     Create UIImage from FAType
     */
    public func setFAIconWithName(icon: FAType, textColor: UIColor, orientation: UIImageOrientation = UIImageOrientation.down, backgroundColor: UIColor = UIColor.clear, size: CGSize? = nil) {
        FontLoader.loadFontIfNeeded()
        self.image = UIImage(icon: icon, size: size ?? frame.size, orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
    }
}


public extension UITabBarItem {

    public func setFAIcon(icon: FAType, size: CGSize? = nil, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear, selectedTextColor: UIColor = UIColor.black, selectedBackgroundColor: UIColor = UIColor.clear) {
        FontLoader.loadFontIfNeeded()
        let tabBarItemImageSize = size ?? CGSize(width: 30, height: 30)

        image = UIImage(icon: icon, size: tabBarItemImageSize, orientation: orientation, textColor: textColor, backgroundColor: backgroundColor).withRenderingMode(UIImageRenderingMode.alwaysOriginal)

        selectedImage = UIImage(icon: icon, size: tabBarItemImageSize, orientation: orientation, textColor: selectedTextColor, backgroundColor: selectedBackgroundColor).withRenderingMode(UIImageRenderingMode.alwaysOriginal)

        setTitleTextAttributes([NSAttributedStringKey.foregroundColor: textColor], for: .normal)
        setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedTextColor], for: .selected)
    }
}


public extension UISegmentedControl {

    public func setFAIcon(icon: FAType, forSegmentAtIndex segment: Int) {
        FontLoader.loadFontIfNeeded()
        let font = UIFont(name: FAStruct.FontName, size: 23)
        assert(font != nil, FAStruct.ErrorAnnounce)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        setTitle(icon.text, forSegmentAt: segment)
    }
}


public extension UIStepper {

    public func setFABackgroundImage(icon: FAType, forState state: UIControlState) {
        FontLoader.loadFontIfNeeded()
        let backgroundSize = CGSize(width: 47, height: 29)
        let image = UIImage(icon: icon, size: backgroundSize)
        setBackgroundImage(image, for: state)
    }

    public func setFAIncrementImage(icon: FAType, forState state: UIControlState) {
        FontLoader.loadFontIfNeeded()
        let incrementSize = CGSize(width: 16, height: 16)
        let image = UIImage(icon: icon, size: incrementSize)
        setIncrementImage(image, for: state)
    }

    public func setFADecrementImage(icon: FAType, forState state: UIControlState) {
        FontLoader.loadFontIfNeeded()
        let decrementSize = CGSize(width: 16, height: 16)
        let image = UIImage(icon: icon, size: decrementSize)
        setDecrementImage(image, for: state)
    }
}


public extension UIImage {

    public convenience init(icon: FAType, size: CGSize, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) {
        FontLoader.loadFontIfNeeded()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center

        let fontAspectRatio: CGFloat = 1.28571429
        let fontSize = min(size.width / fontAspectRatio, size.height)
        let font = UIFont(name: FAStruct.FontName, size: fontSize)
        assert(font != nil, FAStruct.ErrorAnnounce)
        let attributes = [NSAttributedStringKey.font: font!, NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.backgroundColor: backgroundColor, NSAttributedStringKey.paragraphStyle: paragraph]

        let attributedString = NSAttributedString(string: icon.text!, attributes: attributes)
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) * 0.5, width: size.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        if let image = image {
            var imageOrientation = image.imageOrientation

            if(orientation != UIImageOrientation.down){
                imageOrientation = orientation
            }

            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: imageOrientation)
        } else {
            self.init()
        }
    }

    public convenience init(bgIcon: FAType, orientation: UIImageOrientation = UIImageOrientation.down, bgTextColor: UIColor = .black, bgBackgroundColor: UIColor = .clear, topIcon: FAType, topTextColor: UIColor = .black, bgLarge: Bool? = true, size: CGSize? = nil) {

        let bgSize: CGSize!
        let topSize: CGSize!
        let bgRect: CGRect!
        let topRect: CGRect!

        if bgLarge! {
            topSize = size ?? CGSize(width: 30, height: 30)
            bgSize = CGSize(width: 2 * topSize.width, height: 2 * topSize.height)
        } else {
            bgSize = size ?? CGSize(width: 30, height: 30)
            topSize = CGSize(width: 2 * bgSize.width, height: 2 * bgSize.height)
        }

        let bgImage = UIImage.init(icon: bgIcon, size: bgSize, orientation: orientation, textColor: bgTextColor)
        let topImage = UIImage.init(icon: topIcon, size: topSize, orientation: orientation, textColor: topTextColor)

        if bgLarge! {
            bgRect = CGRect(x: 0, y: 0, width: bgSize.width, height: bgSize.height)
            topRect = CGRect(x: topSize.width/2, y: topSize.height/2, width: topSize.width, height: topSize.height)
            UIGraphicsBeginImageContextWithOptions(bgImage.size, false, 0.0)
        } else {
            topRect = CGRect(x: 0, y: 0, width: topSize.width, height: topSize.height)
            bgRect = CGRect(x: bgSize.width/2, y: bgSize.height/2, width: bgSize.width, height: bgSize.height)
            UIGraphicsBeginImageContextWithOptions(topImage.size, false, 0.0)

        }

        bgImage.draw(in: bgRect)
        topImage.draw(in: topRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let image = image {
            var imageOrientation = image.imageOrientation

            if(orientation != UIImageOrientation.down){
                imageOrientation = orientation
            }

            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: imageOrientation)
        } else {
            self.init()
        }
    }
}


public extension UISlider {

    func setFAMaximumValueImage(icon: FAType, orientation: UIImageOrientation = UIImageOrientation.down, customSize: CGSize? = nil) {
        maximumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25,height: 25), orientation: orientation)
    }

    func setFAMinimumValueImage(icon: FAType, orientation: UIImageOrientation = UIImageOrientation.down, customSize: CGSize? = nil) {
        minimumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25,height: 25), orientation: orientation)
    }
}

public extension UIViewController {
    var FATitle: FAType? {
        set {
            FontLoader.loadFontIfNeeded()
            let font = UIFont(name: FAStruct.FontName, size: 23)
            assert(font != nil,FAStruct.ErrorAnnounce)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: font!]
            title = newValue?.text
        }
        get {
            guard let title = title, let index = FAIcons.index(of: title) else { return nil }
            return FAType(rawValue: index)
        }
    }
}

private struct FAStruct {
    static let FontName = "FontAwesome5FreeSolid"
    static let FontFile = "fa-solid-900"
    static let ErrorAnnounce = "****** FONT AWESOME SWIFT - FontAwesome font not found in the bundle or not associated with Info.plist when manual installation was performed. ******"
}

private class FontLoader {

    static func loadFontIfNeeded() {
        if (UIFont.fontNames(forFamilyName: FAStruct.FontName).count == 0) {

            let bundle = Bundle(for: FontLoader.self)
            var fontURL: URL!
            let identifier = bundle.bundleIdentifier

            if identifier?.hasPrefix("org.cocoapods") == true {
                fontURL = bundle.url(forResource: FAStruct.FontFile, withExtension: "ttf", subdirectory: "Font-Awesome-Swift.bundle")
            } else {
                fontURL = bundle.url(forResource: FAStruct.FontFile, withExtension: "ttf")
            }
            let data = try! Data(contentsOf: fontURL as URL)
            let provider = CGDataProvider(data: data as CFData)
            let font = CGFont(provider!)

            var error: Unmanaged<CFError>?

            if CTFontManagerRegisterGraphicsFont(font!, &error) == false {
                //https://github.com/dzenbot/Iconic/issues/35#issuecomment-241209203
                if CFErrorGetCode(error!.takeUnretainedValue()) != 105 { //kCTFontManagerErrorAlreadyRegistered
                    let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
                    let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
                    NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
                }
            }
        }
    }
}

/**
 List of all icons in Font Awesome
 */
public enum FAType: Int {

    static var count: Int {
        return FAIcons.count
    }

    public var text: String? {
        return FAIcons[rawValue]
    }

    case FANotesMedical, FACode, FAChevronCircleRight, FACrosshairs, FABroadcastTower, FAExternalLinkSquareAlt, FASmoking, FADumbbell, FAPencilAlt, FAChessBishop, FAQuidditch, FAAngleDoubleLeft, FAMosque, FAPen, FACropAlt, FAList, FAFilePrescription, FATh, FAAngleLeft, FAAtlas, FASmile, FAPiggyBank, FATeethOpen, FAStarHalfAlt, FAFax, FAPenAlt, FATimesCircle, FADraftingCompass, FAPrayingHands, FAScrewdriver, FASyringe, FADharmachakra, FAUniversalAccess, FAClipboardList, FAGopuram, FACaretUp, FASchool, FASortNumericUp, FAGrinStars, FAFolderMinus, FATruckLoading, FABalanceScale, FAMagnet, FAAdjust, FAGrimace, FAHeading, FACheckCircle, FAArrowDown, FABicycle, FACrow, FAAirFreshener, FASync, FACrop, FASign, FAArrowCircleDown, FAPaperPlane, FARecycle, FADownload, FATrash, FARibbon, FACaretDown, FAChevronLeft, FAHashtag, FAFont, FAGlobeAfrica, FAClock, FASun, FACartPlus, FAClipboard, FATachometerAlt, FAShoePrints, FAPhoneSlash, FAReply, FAHourglassHalf, FALongArrowAltUp, FAGraduationCap, FAUserCircle, FAParagraph, FAChessKnight, FABarcode, FADrawPolygon, FAFileAlt, FAEquals, FAPlaceOfWorship, FAOutdent, FAPause, FADirections, FABox, FADiagnoses, FABible, FAFileImage, FAVenusMars, FAFlask, FACalendarTimes, FAHistory, FATint, FATasks, FADivide, FAVectorSquare, FAGreaterThanEqual, FAQuoteLeft, FAMobileAlt, FAWifi, FAPaperclip, FAEyeSlash, FALockOpen, FAUserShield, FAMarker, FAFeatherAlt, FACloud, FAHockeyPuck, FAHandHoldingUsd, FADna, FAStream, FACertificate, FABaseballBall, FAAngry, FACoins, FAFrog, FACamera, FADiceThree, FAFontAwesomeLogoFull, FAPassport, FAMemory, FAPenSquare, FASort, FATrophy, FAShoppingCart, FAShare, FAEnvelope, FAAward, FAWindowRestore, FAPhone, FAFlag, FATrain, FABullhorn, FAPrescription, FAConciergeBell, FAFolder, FADollyFlatbed, FALongArrowAltRight, FAKhanda, FAThermometer, FAAddressCard, FAICursor, FACar, FALuggageCart, FAHourglassEnd, FAWallet, FAMale, FAAlignJustify, FAHSquare, FAHeart, FAUserTie, FASearchPlus, FALifeRing, FALock, FAMousePointer, FAMoon, FAParachuteBox, FATag, FACarSide, FASmileBeam, FASpa, FAMicrophoneAlt, FAChevronCircleDown, FAStarOfLife, FAFolderPlus, FAFilter, FAArchive, FABookOpen, FATrafficLight, FABatteryThreeQuarters, FAObjectUngroup, FABriefcase, FACocktail, FAStop, FAClone, FAWeightHanging, FAOilCan, FAUpload, FAThermometerFull, FAIdCardAlt, FACheckSquare, FAChartLine, FAUnlink, FADove, FAEnvelopeOpen, FAStepBackward, FAWheelchair, FAMarsStrokeH, FAHandLizard, FATicketAlt, FAUserPlus, FATruck, FAThumbtack, FAAmbulance, FAUndoAlt, FAWonSign, FASubway, FAHands, FATty, FAGlobe, FADiceOne, FAAlignLeft, FAMeh, FATablets, FAMotorcycle, FAKeyboard, FACheckDouble, FAHeadphonesAlt, FABatteryHalf, FAProjectDiagram, FAAngleUp, FAPray, FABroom, FAListAlt, FALevelDownAlt, FADolly, FAWalking, FAThList, FAGrinTears, FASortAmountUp, FACoffee, FAVihara, FATabletAlt, FAUserClock, FAGrinBeamSweat, FAWineGlass, FAShip, FAFileDownload, FAAngleDoubleRight, FAKiss, FAFingerprint, FAMagic, FAChargingStation, FAEdit, FAUniversity, FASadTear, FAReplyAll, FAMicrochip, FAUserAltSlash, FABong, FABone, FAGlasses, FASquare, FAEllipsisV, FAMap, FAGrinSquint, FACaretSquareRight, FAClosedCaptioning, FAReceipt, FAStrikethrough, FAShoppingBasket, FAUnlock, FAQuoteRight, FADiceSix, FASpinner, FAEllipsisH, FAGripVertical, FAUserNinja, FAPills, FAExclamation, FAHaykal, FAYinYang, FAAssistiveListeningSystems, FAPoundSign, FAHandPointDown, FABatteryQuarter, FACalendarPlus, FAHandPeace, FASurprise, FAFilePdf, FAVideoSlash, FALocationArrow, FAUsersCog, FAUmbrella, FAUserAstronaut, FAQuran, FAUndo, FAUserMinus, FABookReader, FAPlaneArrival, FACookie, FAMoneyBill, FAChevronDown, FAFunnelDollar, FAIndent, FALanguage, FAArrowAltCircleUp, FARoute, FAHeadphones, FATimes, FAPlane, FAToriiGate, FAFolderOpen, FASignature, FAHeartbeat, FAUserCheck, FALevelUpAlt, FAUser, FABlind, FALaughWink, FAPhoneSquare, FATextHeight, FASearchDollar, FAGrinTongue, FAQrcode, FALongArrowAltLeft, FAMercury, FACity, FASortAmountDown, FATextWidth, FASquareRootAlt, FARssSquare, FABookmark, FAWindowMaximize, FATired, FASortDown, FAMapMarked, FACloudUploadAlt, FASortUp, FAPercentage, FAVolumeUp, FASmileWink, FAHotel, FASignInAlt, FAShareAlt, FACopy, FASignOutAlt, FACalendarCheck, FAGlobeAsia, FASynagogue, FAVial, FAStroopwafel, FACalendarMinus, FATree, FABed, FAShower, FADrumSteelpan, FAFileUpload, FAStore, FAMedkit, FAVideo, FAToggleOff, FAMapMarkerAlt, FAShekelSign, FACommentDots, FAKaaba, FAUserMd, FABellSlash, FARobot, FARulerHorizontal, FAPaintRoller, FAWineGlassAlt, FAMapSigns, FAMailBulk, FAMicrophoneSlash, FAGripHorizontal, FAAllergies, FAVials, FAIdCard, FARedoAlt, FACouch, FAPlayCircle, FAUserTag, FAChess, FAFileExport, FASignLanguage, FASnowflake, FARegistered, FAWrench, FAPlay, FADollarSign, FAHeadset, FACompress, FASearchLocation, FAAngleRight, FAPlus, FASwatchbook, FAPuzzlePiece, FAChessQueen, FAChartArea, FARulerCombined, FAEuroSign, FAMehBlank, FAEject, FAUtensils, FAMobile, FAHamsa, FABoxOpen, FAFutbol, FATooth, FABusinessTime, FAQuestionCircle, FABullseye, FASuperscript, FAFileExcel, FAMehRollingEyes, FATaxi, FABomb, FAUserFriends, FATruckMonster, FAArrowsAltH, FAChessRook, FAFireExtinguisher, FAArrowsAltV, FAEyeDropper, FACaretLeft, FACameraRetro, FABlender, FADice, FACopyright, FARubleSign, FAJedi, FARulerVertical, FAFilePowerpoint, FATape, FAShoppingBag, FAStopCircle, FABezierCurve, FACircle, FARss, FAColumns, FAPowerOff, FAInfo, FACube, FACapsules, FAGrinWink, FAKiwiBird, FAMarsStrokeV, FAFileArchive, FAJoint, FAMoneyCheckAlt, FACompass, FAAddressBook, FAListOl, FAProcedures, FAGem, FAStamp, FAAudioDescription, FABrain, FAStarAndCrescent, FAMicroscope, FABan, FAFighterJet, FASpaceShuttle, FABars, FACarCrash, FAArrowAltCircleDown, FAMapPin, FAPenFancy, FAGrinAlt, FAMoneyBillAlt, FAAlignCenter, FASortAlphaDown, FAJournalWhills, FAParking, FAChalkboardTeacher, FAPortrait, FACalendar, FAStoreAlt, FARetweet, FAHourglass, FAPaintBrush, FAPalette, FATags, FAHandPaper, FAGlassMartini, FASubscript, FADonate, FAGlassMartiniAlt, FACheck, FACodeBranch, FASuitcase, FANotEqual, FAGrinBeam, FAKey, FAPencilRuler, FAFirstAid, FAShareAltSquare, FACubes, FADrum, FAStreetView, FAFileContract, FACreditCard, FAArchway, FAMinus, FAUnlockAlt, FAMicrophoneAltSlash, FAUserSecret, FACog, FAArrowRight, FAFileVideo, FAShuttleVan, FAArrowAltCircleRight, FAComment, FAMoneyCheck, FABell, FAUserGraduate, FATablet, FAPoo, FAPlaneDeparture, FALaptopCode, FAGreaterThan, FALaugh, FAChurch, FATable, FAPoll, FACarAlt, FAPallet, FAHandsHelping, FAMoneyBillWave, FAAlignRight, FABeer, FAChalkboard, FAEraser, FAHelicopter, FAFeather, FASquareFull, FAFileInvoice, FAHourglassStart, FAFastBackward, FAGrinHearts, FAFire, FASearch, FAFastForward, FAMapMarkedAlt, FAStopwatch, FAUserCog, FAVenus, FAChild, FAKissBeam, FASeedling, FAExpandArrowsAlt, FACaretSquareDown, FATrashAlt, FALaughSquint, FAHdd, FAObjectGroup, FANewspaper, FAHospitalAlt, FAAnchor, FAHandPointLeft, FAUserTimes, FACalculator, FAFileWord, FADizzy, FAKissWinkHeart, FAChessKing, FAEnvelopeSquare, FAFileMedical, FADiceFive, FAHighlighter, FAPaw, FAVenusDouble, FAHandHoldingHeart, FACross, FASolarPanel, FACompactDisc, FASortAlphaUp, FACaretRight, FAAnkh, FAMapMarker, FACalendarAlt, FAMicrophone, FAAmericanSignLanguageInterpreting, FABinoculars, FAStickyNote, FASwimmingPool, FAPenNib, FAExpand, FAMinusCircle, FAChessPawn, FATruckPickup, FADatabase, FARandom, FASlidersH, FAInfinity, FAPrescriptionBottle, FABirthdayCake, FAVolleyballBall, FAGolfBall, FALandmark, FAChartBar, FAUserEdit, FALightbulb, FARocket, FALaptop, FAHandPointRight, FATorah, FAArrowsAlt, FAFrownOpen, FAUserLock, FAUserAlt, FAEnvelopeOpenText, FAQuestion, FAUnderline, FAHandshake, FACut, FAGamepad, FAArrowCircleUp, FABasketballBall, FADesktop, FAPastafarianism, FAToggleOn, FAMinusSquare, FAArrowAltCircleLeft, FASave, FACommentDollar, FAGasPump, FAExternalLinkAlt, FAMenorah, FAFrown, FARuler, FATheaterMasks, FAFileMedicalAlt, FABoxes, FAThermometerEmpty, FAGrin, FAHandPointer, FAPlusSquare, FAExclamationTriangle, FAGift, FATintSlash, FACogs, FAPollH, FASignal, FAServer, FAShapes, FABatteryEmpty, FASprayCan, FALessThanEqual, FAChevronCircleLeft, FAMortarPestle, FASitemap, FABusAlt, FAIdBadge, FAFileCode, FABowlingBall, FATerminal, FAVolumeOff, FABatteryFull, FACrown, FAPoop, FAWindowMinimize, FAMarsDouble, FAExchangeAlt, FAImages, FAHome, FAThLarge, FASearchMinus, FAUtensilSpoon, FADeaf, FALeaf, FAAppleAlt, FARedo, FAExclamationCircle, FAShareSquare, FAUmbrellaBeach, FAComments, FABriefcaseMedical, FACannabis, FACommentsDollar, FALaughBeam, FABackspace, FAInfoCircle, FAHotTub, FASuitcaseRolling, FAChartPie, FABold, FAFish, FAChevronCircleUp, FABurn, FAThumbsUp, FAArrowCircleRight, FABolt, FAThermometerQuarter, FAEye, FAPaste, FAPlug, FAOm, FASadCry, FABraille, FAToolbox, FAIndustry, FASwimmer, FAPhoneVolume, FACloudDownloadAlt, FAInbox, FAListUl, FASmokingBan, FATshirt, FAMarsStroke, FAHospital, FARoad, FAVolumeDown, FATrademark, FAImage, FAUserSlash, FAAngleDoubleUp, FABath, FADoorOpen, FAGrinTongueWink, FABrush, FAFemale, FAGavel, FACircleNotch, FACaretSquareLeft, FAWeight, FATableTennis, FAMedal, FAThermometerHalf, FAPrint, FACarBattery, FALowVision, FADoorClosed, FAFileImport, FAItalic, FAForward, FAMusic, FAFileSignature, FAThumbsDown, FAChevronRight, FAFootballBall, FADiceFour, FABus, FAMars, FAAngleDown, FAHandRock, FAWindowClose, FALink, FAYenSign, FAAtom, FALessThan, FAPodcast, FATruckMoving, FABug, FAShieldAlt, FADiceTwo, FAClipboardCheck, FASkull, FAStethoscope, FAPeopleCarry, FAFillDrip, FACommentSlash, FAMonument, FAHospitalSymbol, FAXRay, FAArrowLeft, FATv, FAArrowUp, FAAd, FAHandHolding, FADotCircle, FAPauseCircle, FASortNumericDown, FACaretSquareUp, FASyncAlt, FAAt, FAFile, FAStarHalf, FASplotch, FAFlagCheckered, FAGenderless, FACommentAlt, FAFilm, FAFill, FAGrinSquintTears, FALemon, FAGlobeAmericas, FAPeace, FAPercent, FAShippingFast, FABook, FAThermometerThreeQuarters, FAWarehouse, FATransgender, FAArrowCircleLeft, FAFileAudio, FALiraSign, FACookieBite, FAStar, FAUsers, FARupeeSign, FATransgenderAlt, FATeeth, FAAsterisk, FAStarOfDavid, FAPlusCircle, FACartArrowDown, FAHandSpock, FAFlushed, FABuilding, FAPrescriptionBottleAlt, FAMoneyBillWaveAlt, FANeuter, FABandAid, FASocks, FAChessBoard, FALayerGroup, FALongArrowAltDown, FADigitalTachograph, FAAngleDoubleDown, FAGrinTongueSquint, FAChevronUp, FAHandScissors, FAFileInvoiceDollar, FAStepForward, FABackward, FAHandPointUp
}

private let FAIcons = ["\u{f481}", "\u{f121}", "\u{f138}", "\u{f05b}", "\u{f519}", "\u{f360}", "\u{f48d}", "\u{f44b}", "\u{f303}", "\u{f43a}", "\u{f458}", "\u{f100}", "\u{f678}", "\u{f304}", "\u{f565}", "\u{f03a}", "\u{f572}", "\u{f00a}", "\u{f104}", "\u{f558}", "\u{f118}", "\u{f4d3}", "\u{f62f}", "\u{f5c0}", "\u{f1ac}", "\u{f305}", "\u{f057}", "\u{f568}", "\u{f684}", "\u{f54a}", "\u{f48e}", "\u{f655}", "\u{f29a}", "\u{f46d}", "\u{f664}", "\u{f0d8}", "\u{f549}", "\u{f163}", "\u{f587}", "\u{f65d}", "\u{f4de}", "\u{f24e}", "\u{f076}", "\u{f042}", "\u{f57f}", "\u{f1dc}", "\u{f058}", "\u{f063}", "\u{f206}", "\u{f520}", "\u{f5d0}", "\u{f021}", "\u{f125}", "\u{f4d9}", "\u{f0ab}", "\u{f1d8}", "\u{f1b8}", "\u{f019}", "\u{f1f8}", "\u{f4d6}", "\u{f0d7}", "\u{f053}", "\u{f292}", "\u{f031}", "\u{f57c}", "\u{f017}", "\u{f185}", "\u{f217}", "\u{f328}", "\u{f3fd}", "\u{f54b}", "\u{f3dd}", "\u{f3e5}", "\u{f252}", "\u{f30c}", "\u{f19d}", "\u{f2bd}", "\u{f1dd}", "\u{f441}", "\u{f02a}", "\u{f5ee}", "\u{f15c}", "\u{f52c}", "\u{f67f}", "\u{f03b}", "\u{f04c}", "\u{f5eb}", "\u{f466}", "\u{f470}", "\u{f647}", "\u{f1c5}", "\u{f228}", "\u{f0c3}", "\u{f273}", "\u{f1da}", "\u{f043}", "\u{f0ae}", "\u{f529}", "\u{f5cb}", "\u{f532}", "\u{f10d}", "\u{f3cd}", "\u{f1eb}", "\u{f0c6}", "\u{f070}", "\u{f3c1}", "\u{f505}", "\u{f5a1}", "\u{f56b}", "\u{f0c2}", "\u{f453}", "\u{f4c0}", "\u{f471}", "\u{f550}", "\u{f0a3}", "\u{f433}", "\u{f556}", "\u{f51e}", "\u{f52e}", "\u{f030}", "\u{f527}", "\u{f4e6}", "\u{f5ab}", "\u{f538}", "\u{f14b}", "\u{f0dc}", "\u{f091}", "\u{f07a}", "\u{f064}", "\u{f0e0}", "\u{f559}", "\u{f2d2}", "\u{f095}", "\u{f024}", "\u{f238}", "\u{f0a1}", "\u{f5b1}", "\u{f562}", "\u{f07b}", "\u{f474}", "\u{f30b}", "\u{f66d}", "\u{f491}", "\u{f2bb}", "\u{f246}", "\u{f1b9}", "\u{f59d}", "\u{f253}", "\u{f555}", "\u{f183}", "\u{f039}", "\u{f0fd}", "\u{f004}", "\u{f508}", "\u{f00e}", "\u{f1cd}", "\u{f023}", "\u{f245}", "\u{f186}", "\u{f4cd}", "\u{f02b}", "\u{f5e4}", "\u{f5b8}", "\u{f5bb}", "\u{f3c9}", "\u{f13a}", "\u{f621}", "\u{f65e}", "\u{f0b0}", "\u{f187}", "\u{f518}", "\u{f637}", "\u{f241}", "\u{f248}", "\u{f0b1}", "\u{f561}", "\u{f04d}", "\u{f24d}", "\u{f5cd}", "\u{f613}", "\u{f093}", "\u{f2c7}", "\u{f47f}", "\u{f14a}", "\u{f201}", "\u{f127}", "\u{f4ba}", "\u{f2b6}", "\u{f048}", "\u{f193}", "\u{f22b}", "\u{f258}", "\u{f3ff}", "\u{f234}", "\u{f0d1}", "\u{f08d}", "\u{f0f9}", "\u{f2ea}", "\u{f159}", "\u{f239}", "\u{f4c2}", "\u{f1e4}", "\u{f0ac}", "\u{f525}", "\u{f036}", "\u{f11a}", "\u{f490}", "\u{f21c}", "\u{f11c}", "\u{f560}", "\u{f58f}", "\u{f242}", "\u{f542}", "\u{f106}", "\u{f683}", "\u{f51a}", "\u{f022}", "\u{f3be}", "\u{f472}", "\u{f554}", "\u{f00b}", "\u{f588}", "\u{f161}", "\u{f0f4}", "\u{f6a7}", "\u{f3fa}", "\u{f4fd}", "\u{f583}", "\u{f4e3}", "\u{f21a}", "\u{f56d}", "\u{f101}", "\u{f596}", "\u{f577}", "\u{f0d0}", "\u{f5e7}", "\u{f044}", "\u{f19c}", "\u{f5b4}", "\u{f122}", "\u{f2db}", "\u{f4fa}", "\u{f55c}", "\u{f5d7}", "\u{f530}", "\u{f0c8}", "\u{f142}", "\u{f279}", "\u{f585}", "\u{f152}", "\u{f20a}", "\u{f543}", "\u{f0cc}", "\u{f291}", "\u{f09c}", "\u{f10e}", "\u{f526}", "\u{f110}", "\u{f141}", "\u{f58e}", "\u{f504}", "\u{f484}", "\u{f12a}", "\u{f666}", "\u{f6ad}", "\u{f2a2}", "\u{f154}", "\u{f0a7}", "\u{f243}", "\u{f271}", "\u{f25b}", "\u{f5c2}", "\u{f1c1}", "\u{f4e2}", "\u{f124}", "\u{f509}", "\u{f0e9}", "\u{f4fb}", "\u{f687}", "\u{f0e2}", "\u{f503}", "\u{f5da}", "\u{f5af}", "\u{f563}", "\u{f0d6}", "\u{f078}", "\u{f662}", "\u{f03c}", "\u{f1ab}", "\u{f35b}", "\u{f4d7}", "\u{f025}", "\u{f00d}", "\u{f072}", "\u{f6a1}", "\u{f07c}", "\u{f5b7}", "\u{f21e}", "\u{f4fc}", "\u{f3bf}", "\u{f007}", "\u{f29d}", "\u{f59c}", "\u{f098}", "\u{f034}", "\u{f688}", "\u{f589}", "\u{f029}", "\u{f30a}", "\u{f223}", "\u{f64f}", "\u{f160}", "\u{f035}", "\u{f698}", "\u{f143}", "\u{f02e}", "\u{f2d0}", "\u{f5c8}", "\u{f0dd}", "\u{f59f}", "\u{f382}", "\u{f0de}", "\u{f541}", "\u{f028}", "\u{f4da}", "\u{f594}", "\u{f2f6}", "\u{f1e0}", "\u{f0c5}", "\u{f2f5}", "\u{f274}", "\u{f57e}", "\u{f69b}", "\u{f492}", "\u{f551}", "\u{f272}", "\u{f1bb}", "\u{f236}", "\u{f2cc}", "\u{f56a}", "\u{f574}", "\u{f54e}", "\u{f0fa}", "\u{f03d}", "\u{f204}", "\u{f3c5}", "\u{f20b}", "\u{f4ad}", "\u{f66b}", "\u{f0f0}", "\u{f1f6}", "\u{f544}", "\u{f547}", "\u{f5aa}", "\u{f5ce}", "\u{f277}", "\u{f674}", "\u{f131}", "\u{f58d}", "\u{f461}", "\u{f493}", "\u{f2c2}", "\u{f2f9}", "\u{f4b8}", "\u{f144}", "\u{f507}", "\u{f439}", "\u{f56e}", "\u{f2a7}", "\u{f2dc}", "\u{f25d}", "\u{f0ad}", "\u{f04b}", "\u{f155}", "\u{f590}", "\u{f066}", "\u{f689}", "\u{f105}", "\u{f067}", "\u{f5c3}", "\u{f12e}", "\u{f445}", "\u{f1fe}", "\u{f546}", "\u{f153}", "\u{f5a4}", "\u{f052}", "\u{f2e7}", "\u{f10b}", "\u{f665}", "\u{f49e}", "\u{f1e3}", "\u{f5c9}", "\u{f64a}", "\u{f059}", "\u{f140}", "\u{f12b}", "\u{f1c3}", "\u{f5a5}", "\u{f1ba}", "\u{f1e2}", "\u{f500}", "\u{f63b}", "\u{f337}", "\u{f447}", "\u{f134}", "\u{f338}", "\u{f1fb}", "\u{f0d9}", "\u{f083}", "\u{f517}", "\u{f522}", "\u{f1f9}", "\u{f158}", "\u{f669}", "\u{f548}", "\u{f1c4}", "\u{f4db}", "\u{f290}", "\u{f28d}", "\u{f55b}", "\u{f111}", "\u{f09e}", "\u{f0db}", "\u{f011}", "\u{f129}", "\u{f1b2}", "\u{f46b}", "\u{f58c}", "\u{f535}", "\u{f22a}", "\u{f1c6}", "\u{f595}", "\u{f53d}", "\u{f14e}", "\u{f2b9}", "\u{f0cb}", "\u{f487}", "\u{f3a5}", "\u{f5bf}", "\u{f29e}", "\u{f5dc}", "\u{f699}", "\u{f610}", "\u{f05e}", "\u{f0fb}", "\u{f197}", "\u{f0c9}", "\u{f5e1}", "\u{f358}", "\u{f276}", "\u{f5ac}", "\u{f581}", "\u{f3d1}", "\u{f037}", "\u{f15d}", "\u{f66a}", "\u{f540}", "\u{f51c}", "\u{f3e0}", "\u{f133}", "\u{f54f}", "\u{f079}", "\u{f254}", "\u{f1fc}", "\u{f53f}", "\u{f02c}", "\u{f256}", "\u{f000}", "\u{f12c}", "\u{f4b9}", "\u{f57b}", "\u{f00c}", "\u{f126}", "\u{f0f2}", "\u{f53e}", "\u{f582}", "\u{f084}", "\u{f5ae}", "\u{f479}", "\u{f1e1}", "\u{f1b3}", "\u{f569}", "\u{f21d}", "\u{f56c}", "\u{f09d}", "\u{f557}", "\u{f068}", "\u{f13e}", "\u{f539}", "\u{f21b}", "\u{f013}", "\u{f061}", "\u{f1c8}", "\u{f5b6}", "\u{f35a}", "\u{f075}", "\u{f53c}", "\u{f0f3}", "\u{f501}", "\u{f10a}", "\u{f2fe}", "\u{f5b0}", "\u{f5fc}", "\u{f531}", "\u{f599}", "\u{f51d}", "\u{f0ce}", "\u{f681}", "\u{f5de}", "\u{f482}", "\u{f4c4}", "\u{f53a}", "\u{f038}", "\u{f0fc}", "\u{f51b}", "\u{f12d}", "\u{f533}", "\u{f52d}", "\u{f45c}", "\u{f570}", "\u{f251}", "\u{f049}", "\u{f584}", "\u{f06d}", "\u{f002}", "\u{f050}", "\u{f5a0}", "\u{f2f2}", "\u{f4fe}", "\u{f221}", "\u{f1ae}", "\u{f597}", "\u{f4d8}", "\u{f31e}", "\u{f150}", "\u{f2ed}", "\u{f59b}", "\u{f0a0}", "\u{f247}", "\u{f1ea}", "\u{f47d}", "\u{f13d}", "\u{f0a5}", "\u{f235}", "\u{f1ec}", "\u{f1c2}", "\u{f567}", "\u{f598}", "\u{f43f}", "\u{f199}", "\u{f477}", "\u{f523}", "\u{f591}", "\u{f1b0}", "\u{f226}", "\u{f4be}", "\u{f654}", "\u{f5ba}", "\u{f51f}", "\u{f15e}", "\u{f0da}", "\u{f644}", "\u{f041}", "\u{f073}", "\u{f130}", "\u{f2a3}", "\u{f1e5}", "\u{f249}", "\u{f5c5}", "\u{f5ad}", "\u{f065}", "\u{f056}", "\u{f443}", "\u{f63c}", "\u{f1c0}", "\u{f074}", "\u{f1de}", "\u{f534}", "\u{f485}", "\u{f1fd}", "\u{f45f}", "\u{f450}", "\u{f66f}", "\u{f080}", "\u{f4ff}", "\u{f0eb}", "\u{f135}", "\u{f109}", "\u{f0a4}", "\u{f6a0}", "\u{f0b2}", "\u{f57a}", "\u{f502}", "\u{f406}", "\u{f658}", "\u{f128}", "\u{f0cd}", "\u{f2b5}", "\u{f0c4}", "\u{f11b}", "\u{f0aa}", "\u{f434}", "\u{f108}", "\u{f67b}", "\u{f205}", "\u{f146}", "\u{f359}", "\u{f0c7}", "\u{f651}", "\u{f52f}", "\u{f35d}", "\u{f676}", "\u{f119}", "\u{f545}", "\u{f630}", "\u{f478}", "\u{f468}", "\u{f2cb}", "\u{f580}", "\u{f25a}", "\u{f0fe}", "\u{f071}", "\u{f06b}", "\u{f5c7}", "\u{f085}", "\u{f682}", "\u{f012}", "\u{f233}", "\u{f61f}", "\u{f244}", "\u{f5bd}", "\u{f537}", "\u{f137}", "\u{f5a7}", "\u{f0e8}", "\u{f55e}", "\u{f2c1}", "\u{f1c9}", "\u{f436}", "\u{f120}", "\u{f026}", "\u{f240}", "\u{f521}", "\u{f619}", "\u{f2d1}", "\u{f227}", "\u{f362}", "\u{f302}", "\u{f015}", "\u{f009}", "\u{f010}", "\u{f2e5}", "\u{f2a4}", "\u{f06c}", "\u{f5d1}", "\u{f01e}", "\u{f06a}", "\u{f14d}", "\u{f5ca}", "\u{f086}", "\u{f469}", "\u{f55f}", "\u{f653}", "\u{f59a}", "\u{f55a}", "\u{f05a}", "\u{f593}", "\u{f5c1}", "\u{f200}", "\u{f032}", "\u{f578}", "\u{f139}", "\u{f46a}", "\u{f164}", "\u{f0a9}", "\u{f0e7}", "\u{f2ca}", "\u{f06e}", "\u{f0ea}", "\u{f1e6}", "\u{f679}", "\u{f5b3}", "\u{f2a1}", "\u{f552}", "\u{f275}", "\u{f5c4}", "\u{f2a0}", "\u{f381}", "\u{f01c}", "\u{f0ca}", "\u{f54d}", "\u{f553}", "\u{f229}", "\u{f0f8}", "\u{f018}", "\u{f027}", "\u{f25c}", "\u{f03e}", "\u{f506}", "\u{f102}", "\u{f2cd}", "\u{f52b}", "\u{f58b}", "\u{f55d}", "\u{f182}", "\u{f0e3}", "\u{f1ce}", "\u{f191}", "\u{f496}", "\u{f45d}", "\u{f5a2}", "\u{f2c9}", "\u{f02f}", "\u{f5df}", "\u{f2a8}", "\u{f52a}", "\u{f56f}", "\u{f033}", "\u{f04e}", "\u{f001}", "\u{f573}", "\u{f165}", "\u{f054}", "\u{f44e}", "\u{f524}", "\u{f207}", "\u{f222}", "\u{f107}", "\u{f255}", "\u{f410}", "\u{f0c1}", "\u{f157}", "\u{f5d2}", "\u{f536}", "\u{f2ce}", "\u{f4df}", "\u{f188}", "\u{f3ed}", "\u{f528}", "\u{f46c}", "\u{f54c}", "\u{f0f1}", "\u{f4ce}", "\u{f576}", "\u{f4b3}", "\u{f5a6}", "\u{f47e}", "\u{f497}", "\u{f060}", "\u{f26c}", "\u{f062}", "\u{f641}", "\u{f4bd}", "\u{f192}", "\u{f28b}", "\u{f162}", "\u{f151}", "\u{f2f1}", "\u{f1fa}", "\u{f15b}", "\u{f089}", "\u{f5bc}", "\u{f11e}", "\u{f22d}", "\u{f27a}", "\u{f008}", "\u{f575}", "\u{f586}", "\u{f094}", "\u{f57d}", "\u{f67c}", "\u{f295}", "\u{f48b}", "\u{f02d}", "\u{f2c8}", "\u{f494}", "\u{f224}", "\u{f0a8}", "\u{f1c7}", "\u{f195}", "\u{f564}", "\u{f005}", "\u{f0c0}", "\u{f156}", "\u{f225}", "\u{f62e}", "\u{f069}", "\u{f69a}", "\u{f055}", "\u{f218}", "\u{f259}", "\u{f579}", "\u{f1ad}", "\u{f486}", "\u{f53b}", "\u{f22c}", "\u{f462}", "\u{f696}", "\u{f43c}", "\u{f5fd}", "\u{f309}", "\u{f566}", "\u{f103}", "\u{f58a}", "\u{f077}", "\u{f257}", "\u{f571}", "\u{f051}", "\u{f04a}", "\u{f0a6}"]
