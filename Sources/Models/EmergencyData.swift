import Foundation

struct CountryEmergency: Identifiable {
    let id = UUID()
    let name: String
    let flag: String
    let police: String
    let fire: String
    let ambulance: String
    
    // Helper to get a single number if all are the same
    var unifiedNumber: String? {
        if police == fire && fire == ambulance {
            return police
        }
        return nil
    }
}

struct EmergencyData {
    static let allCountries: [CountryEmergency] = [
        // A
        CountryEmergency(name: "Afghanistan", flag: "🇦🇫", police: "119", fire: "119", ambulance: "112"),
        CountryEmergency(name: "Albania", flag: "🇦🇱", police: "129", fire: "128", ambulance: "127"),
        CountryEmergency(name: "Algeria", flag: "🇩🇿", police: "17", fire: "14", ambulance: "14"),
        CountryEmergency(name: "American Samoa", flag: "🇦🇸", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Andorra", flag: "🇦🇩", police: "110", fire: "118", ambulance: "118"),
        CountryEmergency(name: "Angola", flag: "🇦🇴", police: "113", fire: "118", ambulance: "112"),
        CountryEmergency(name: "Anguilla", flag: "🇦🇮", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Antigua & Barbuda", flag: "🇦🇬", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Argentina", flag: "🇦🇷", police: "911", fire: "100", ambulance: "107"),
        CountryEmergency(name: "Armenia", flag: "🇦🇲", police: "102", fire: "101", ambulance: "103"),
        CountryEmergency(name: "Aruba", flag: "🇦🇼", police: "100", fire: "115", ambulance: "911"),
        CountryEmergency(name: "Australia", flag: "🇦🇺", police: "000", fire: "000", ambulance: "000"),
        CountryEmergency(name: "Austria", flag: "🇦🇹", police: "133", fire: "122", ambulance: "144"),
        CountryEmergency(name: "Azerbaijan", flag: "🇦🇿", police: "102", fire: "101", ambulance: "103"),
        
        // B
        CountryEmergency(name: "Bahamas", flag: "🇧🇸", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Bahrain", flag: "🇧🇭", police: "999", fire: "999", ambulance: "999"),
        CountryEmergency(name: "Bangladesh", flag: "🇧🇩", police: "999", fire: "999", ambulance: "999"),
        CountryEmergency(name: "Barbados", flag: "🇧🇧", police: "211", fire: "311", ambulance: "511"),
        CountryEmergency(name: "Belarus", flag: "🇧🇾", police: "102", fire: "101", ambulance: "103"),
        CountryEmergency(name: "Belgium", flag: "🇧🇪", police: "101", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Belize", flag: "🇧🇿", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Benin", flag: "🇧🇯", police: "117", fire: "118", ambulance: "112"),
        CountryEmergency(name: "Bermuda", flag: "🇧🇲", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Bhutan", flag: "🇧🇹", police: "113", fire: "110", ambulance: "112"),
        CountryEmergency(name: "Bolivia", flag: "🇧🇴", police: "110", fire: "119", ambulance: "118"),
        CountryEmergency(name: "Bosnia & Herzegovina", flag: "🇧🇦", police: "122", fire: "123", ambulance: "124"),
        CountryEmergency(name: "Botswana", flag: "🇧🇼", police: "999", fire: "998", ambulance: "997"),
        CountryEmergency(name: "Brazil", flag: "🇧🇷", police: "190", fire: "193", ambulance: "192"),
        CountryEmergency(name: "Brunei", flag: "🇧🇳", police: "993", fire: "995", ambulance: "991"),
        CountryEmergency(name: "Bulgaria", flag: "🇧🇬", police: "166", fire: "160", ambulance: "150"),
        CountryEmergency(name: "Burkina Faso", flag: "🇧🇫", police: "17", fire: "18", ambulance: "112"),
        CountryEmergency(name: "Burundi", flag: "🇧🇮", police: "117", fire: "118", ambulance: "112"),
        
        // C
        CountryEmergency(name: "Cambodia", flag: "🇰🇭", police: "117", fire: "118", ambulance: "119"),
        CountryEmergency(name: "Cameroon", flag: "🇨🇲", police: "117", fire: "118", ambulance: "112"),
        CountryEmergency(name: "Canada", flag: "🇨🇦", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Cape Verde", flag: "🇨🇻", police: "132", fire: "131", ambulance: "130"),
        CountryEmergency(name: "Cayman Islands", flag: "🇰🇾", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Central African Republic", flag: "🇨🇫", police: "117", fire: "118", ambulance: "1220"),
        CountryEmergency(name: "Chad", flag: "🇹🇩", police: "17", fire: "18", ambulance: "2251-4242"),
        CountryEmergency(name: "Chile", flag: "🇨🇱", police: "133", fire: "132", ambulance: "131"),
        CountryEmergency(name: "China", flag: "🇨🇳", police: "110", fire: "119", ambulance: "120"),
        CountryEmergency(name: "Colombia", flag: "🇨🇴", police: "123", fire: "119", ambulance: "125"),
        CountryEmergency(name: "Comoros", flag: "🇰🇲", police: "17", fire: "18", ambulance: "772-03-73"),
        CountryEmergency(name: "Congo (Democratic Republic)", flag: "🇨🇩", police: "112", fire: "118", ambulance: "118"),
        CountryEmergency(name: "Congo (Republic)", flag: "🇨🇬", police: "117", fire: "118", ambulance: "118"),
        CountryEmergency(name: "Costa Rica", flag: "🇨🇷", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Croatia", flag: "🇭🇷", police: "192", fire: "193", ambulance: "194"),
        CountryEmergency(name: "Cuba", flag: "🇨🇺", police: "106", fire: "105", ambulance: "104"),
        CountryEmergency(name: "Cyprus", flag: "🇨🇾", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Czech Republic", flag: "🇨🇿", police: "158", fire: "150", ambulance: "155"),
        
        // D
        CountryEmergency(name: "Denmark", flag: "🇩🇰", police: "114", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Djibouti", flag: "🇩🇯", police: "17", fire: "18", ambulance: "19"),
        CountryEmergency(name: "Dominica", flag: "🇩🇲", police: "999", fire: "999", ambulance: "999"),
        CountryEmergency(name: "Dominican Republic", flag: "🇩🇴", police: "911", fire: "911", ambulance: "911"),
        
        // E
        CountryEmergency(name: "East Timor", flag: "🇹🇱", police: "112", fire: "115", ambulance: "110"),
        CountryEmergency(name: "Ecuador", flag: "🇪🇨", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Egypt", flag: "🇪🇬", police: "122", fire: "180", ambulance: "123"),
        CountryEmergency(name: "El Salvador", flag: "🇸🇻", police: "911", fire: "913", ambulance: "132"),
        CountryEmergency(name: "Equatorial Guinea", flag: "🇬🇶", police: "114", fire: "115", ambulance: "112"),
        CountryEmergency(name: "Eritrea", flag: "🇪🇷", police: "113", fire: "116", ambulance: "114"),
        CountryEmergency(name: "Estonia", flag: "🇪🇪", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Eswatini", flag: "🇸🇿", police: "999", fire: "933", ambulance: "977"),
        CountryEmergency(name: "Ethiopia", flag: "🇪🇹", police: "911", fire: "939", ambulance: "907"),
        
        // F
        CountryEmergency(name: "Fiji", flag: "🇫🇯", police: "911", fire: "910", ambulance: "911"),
        CountryEmergency(name: "Finland", flag: "🇫🇮", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "France", flag: "🇫🇷", police: "17", fire: "18", ambulance: "15"),
        
        // G
        CountryEmergency(name: "Gabon", flag: "🇬🇦", police: "1730", fire: "18", ambulance: "1300"),
        CountryEmergency(name: "Gambia", flag: "🇬🇲", police: "117", fire: "118", ambulance: "116"),
        CountryEmergency(name: "Georgia", flag: "🇬🇪", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Germany", flag: "🇩🇪", police: "110", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Ghana", flag: "🇬🇭", police: "191", fire: "192", ambulance: "193"),
        CountryEmergency(name: "Greece", flag: "🇬🇷", police: "100", fire: "199", ambulance: "166"),
        CountryEmergency(name: "Greenland", flag: "🇬🇱", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Grenada", flag: "🇬🇩", police: "911", fire: "911", ambulance: "434"),
        CountryEmergency(name: "Guam", flag: "🇬🇺", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Guatemala", flag: "🇬🇹", police: "110", fire: "123", ambulance: "123"),
        CountryEmergency(name: "Guinea", flag: "🇬🇳", police: "117", fire: "18", ambulance: "18"),
        CountryEmergency(name: "Guyana", flag: "🇬🇾", police: "911", fire: "912", ambulance: "913"),
        
        // H
        CountryEmergency(name: "Haiti", flag: "🇭🇹", police: "114", fire: "115", ambulance: "116"),
        CountryEmergency(name: "Honduras", flag: "🇭🇳", police: "911", fire: "198", ambulance: "195"),
        CountryEmergency(name: "Hong Kong", flag: "🇭🇰", police: "999", fire: "999", ambulance: "999"),
        CountryEmergency(name: "Hungary", flag: "🇭🇺", police: "107", fire: "105", ambulance: "104"),
        
        // I
        CountryEmergency(name: "Iceland", flag: "🇮🇸", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "India", flag: "🇮🇳", police: "100", fire: "101", ambulance: "102"), // 112 is pan-India, but 100/101/102 are legacy
        CountryEmergency(name: "Indonesia", flag: "🇮🇩", police: "110", fire: "113", ambulance: "118"),
        CountryEmergency(name: "Iran", flag: "🇮🇷", police: "110", fire: "125", ambulance: "115"),
        CountryEmergency(name: "Iraq", flag: "🇮🇶", police: "104", fire: "115", ambulance: "122"),
        CountryEmergency(name: "Ireland", flag: "🇮🇪", police: "999", fire: "999", ambulance: "999"),
        CountryEmergency(name: "Israel", flag: "🇮🇱", police: "100", fire: "102", ambulance: "101"),
        CountryEmergency(name: "Italy", flag: "🇮🇹", police: "113", fire: "115", ambulance: "118"),
        CountryEmergency(name: "Ivory Coast", flag: "🇨🇮", police: "111", fire: "180", ambulance: "185"),
        
        // J
        CountryEmergency(name: "Jamaica", flag: "🇯🇲", police: "119", fire: "110", ambulance: "110"),
        CountryEmergency(name: "Japan", flag: "🇯🇵", police: "110", fire: "119", ambulance: "119"),
        CountryEmergency(name: "Jordan", flag: "🇯🇴", police: "911", fire: "911", ambulance: "911"),
        
        // K
        CountryEmergency(name: "Kazakhstan", flag: "🇰🇿", police: "102", fire: "101", ambulance: "103"),
        CountryEmergency(name: "Kenya", flag: "🇰🇪", police: "999", fire: "999", ambulance: "999"),
        CountryEmergency(name: "Kiribati", flag: "🇰🇮", police: "992", fire: "993", ambulance: "994"),
        CountryEmergency(name: "Kuwait", flag: "🇰🇼", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Kyrgyzstan", flag: "🇰🇬", police: "102", fire: "101", ambulance: "103"),
        
        // L
        CountryEmergency(name: "Laos", flag: "🇱🇦", police: "191", fire: "190", ambulance: "195"),
        CountryEmergency(name: "Latvia", flag: "🇱🇻", police: "110", fire: "112", ambulance: "113"),
        CountryEmergency(name: "Lebanon", flag: "🇱🇧", police: "112", fire: "175", ambulance: "140"),
        CountryEmergency(name: "Lesotho", flag: "🇱🇸", police: "123", fire: "122", ambulance: "121"),
        CountryEmergency(name: "Liberia", flag: "🇱🇷", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Libya", flag: "🇱🇾", police: "1515", fire: "1515", ambulance: "1515"),
        CountryEmergency(name: "Liechtenstein", flag: "🇱🇮", police: "117", fire: "118", ambulance: "144"),
        CountryEmergency(name: "Lithuania", flag: "🇱🇹", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Luxembourg", flag: "🇱🇺", police: "113", fire: "112", ambulance: "112"),
        
        // M
        CountryEmergency(name: "Macau", flag: "🇲🇴", police: "999", fire: "999", ambulance: "999"),
        CountryEmergency(name: "Madagascar", flag: "🇲🇬", police: "117", fire: "118", ambulance: "124"),
        CountryEmergency(name: "Malawi", flag: "🇲🇼", police: "997", fire: "999", ambulance: "998"),
        CountryEmergency(name: "Malaysia", flag: "🇲🇾", police: "999", fire: "994", ambulance: "999"),
        CountryEmergency(name: "Maldives", flag: "🇲🇻", police: "119", fire: "118", ambulance: "102"),
        CountryEmergency(name: "Mali", flag: "🇲🇱", police: "17", fire: "18", ambulance: "15"),
        CountryEmergency(name: "Malta", flag: "🇲🇹", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Marshall Islands", flag: "🇲🇭", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Mauritania", flag: "🇲🇷", police: "117", fire: "118", ambulance: "118"),
        CountryEmergency(name: "Mauritius", flag: "🇲🇺", police: "999", fire: "115", ambulance: "114"),
        CountryEmergency(name: "Mexico", flag: "🇲🇽", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Micronesia", flag: "🇫🇲", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Moldova", flag: "🇲🇩", police: "902", fire: "901", ambulance: "903"),
        CountryEmergency(name: "Monaco", flag: "🇲🇨", police: "17", fire: "18", ambulance: "18"),
        CountryEmergency(name: "Mongolia", flag: "🇲🇳", police: "102", fire: "101", ambulance: "103"),
        CountryEmergency(name: "Montenegro", flag: "🇲🇪", police: "122", fire: "123", ambulance: "124"),
        CountryEmergency(name: "Morocco", flag: "🇲🇦", police: "19", fire: "15", ambulance: "15"),
        CountryEmergency(name: "Mozambique", flag: "🇲🇿", police: "119", fire: "198", ambulance: "117"),
        CountryEmergency(name: "Myanmar", flag: "🇲🇲", police: "199", fire: "191", ambulance: "192"),
        
        // N
        CountryEmergency(name: "Namibia", flag: "🇳🇦", police: "10111", fire: "2032276", ambulance: "2032276"),
        CountryEmergency(name: "Nepal", flag: "🇳🇵", police: "100", fire: "101", ambulance: "102"),
        CountryEmergency(name: "Netherlands", flag: "🇳🇱", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "New Zealand", flag: "🇳🇿", police: "111", fire: "111", ambulance: "111"),
        CountryEmergency(name: "Nicaragua", flag: "🇳🇮", police: "118", fire: "115", ambulance: "128"),
        CountryEmergency(name: "Niger", flag: "🇳🇪", police: "17", fire: "18", ambulance: "18"),
        CountryEmergency(name: "Nigeria", flag: "🇳🇬", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "North Macedonia", flag: "🇲🇰", police: "192", fire: "193", ambulance: "194"),
        CountryEmergency(name: "Norway", flag: "🇳🇴", police: "112", fire: "110", ambulance: "113"),
        
        // O
        CountryEmergency(name: "Oman", flag: "🇴🇲", police: "9999", fire: "9999", ambulance: "9999"),
        
        // P
        CountryEmergency(name: "Pakistan", flag: "🇵🇰", police: "15", fire: "16", ambulance: "1122"),
        CountryEmergency(name: "Palau", flag: "🇵🇼", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Palestine", flag: "🇵🇸", police: "100", fire: "102", ambulance: "101"),
        CountryEmergency(name: "Panama", flag: "🇵🇦", police: "104", fire: "103", ambulance: "911"),
        CountryEmergency(name: "Papua New Guinea", flag: "🇵🇬", police: "112", fire: "110", ambulance: "111"),
        CountryEmergency(name: "Paraguay", flag: "🇵🇾", police: "911", fire: "123", ambulance: "141"),
        CountryEmergency(name: "Peru", flag: "🇵🇪", police: "105", fire: "116", ambulance: "106"),
        CountryEmergency(name: "Philippines", flag: "🇵🇭", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Poland", flag: "🇵🇱", police: "997", fire: "998", ambulance: "999"),
        CountryEmergency(name: "Portugal", flag: "🇵🇹", police: "112", fire: "112", ambulance: "112"),
        
        // Q
        CountryEmergency(name: "Qatar", flag: "🇶🇦", police: "999", fire: "999", ambulance: "999"),
        
        // R
        CountryEmergency(name: "Romania", flag: "🇷🇴", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Russia", flag: "🇷🇺", police: "102", fire: "101", ambulance: "103"),
        CountryEmergency(name: "Rwanda", flag: "🇷🇼", police: "112", fire: "112", ambulance: "112"),
        
        // S
        CountryEmergency(name: "Samoa", flag: "🇼🇸", police: "995", fire: "994", ambulance: "996"),
        CountryEmergency(name: "San Marino", flag: "🇸🇲", police: "113", fire: "115", ambulance: "118"),
        CountryEmergency(name: "Saudi Arabia", flag: "🇸🇦", police: "999", fire: "998", ambulance: "997"),
        CountryEmergency(name: "Senegal", flag: "🇸🇳", police: "17", fire: "18", ambulance: "15"),
        CountryEmergency(name: "Serbia", flag: "🇷🇸", police: "192", fire: "193", ambulance: "194"),
        CountryEmergency(name: "Seychelles", flag: "🇸🇨", police: "112", fire: "112", ambulance: "151"),
        CountryEmergency(name: "Sierra Leone", flag: "🇸🇱", police: "019", fire: "999", ambulance: "999"),
        CountryEmergency(name: "Singapore", flag: "🇸🇬", police: "999", fire: "995", ambulance: "995"),
        CountryEmergency(name: "Slovakia", flag: "🇸🇰", police: "158", fire: "150", ambulance: "155"),
        CountryEmergency(name: "Slovenia", flag: "🇸🇮", police: "113", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Solomon Islands", flag: "🇸🇧", police: "999", fire: "999", ambulance: "999"),
        CountryEmergency(name: "Somalia", flag: "🇸🇴", police: "888", fire: "555", ambulance: "999"),
        CountryEmergency(name: "South Africa", flag: "🇿🇦", police: "10111", fire: "10177", ambulance: "10177"),
        CountryEmergency(name: "South Korea", flag: "🇰🇷", police: "112", fire: "119", ambulance: "119"),
        CountryEmergency(name: "South Sudan", flag: "🇸🇸", police: "777", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Spain", flag: "🇪🇸", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Sri Lanka", flag: "🇱🇰", police: "119", fire: "110", ambulance: "1990"),
        CountryEmergency(name: "Sudan", flag: "🇸🇩", police: "999", fire: "998", ambulance: "999"),
        CountryEmergency(name: "Suriname", flag: "🇸🇷", police: "115", fire: "110", ambulance: "112"),
        CountryEmergency(name: "Sweden", flag: "🇸🇪", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Switzerland", flag: "🇨🇭", police: "117", fire: "118", ambulance: "144"),
        CountryEmergency(name: "Syria", flag: "🇸🇾", police: "112", fire: "113", ambulance: "110"),
        
        // T
        CountryEmergency(name: "Taiwan", flag: "🇹🇼", police: "110", fire: "119", ambulance: "119"),
        CountryEmergency(name: "Tajikistan", flag: "🇹🇯", police: "02", fire: "01", ambulance: "03"),
        CountryEmergency(name: "Tanzania", flag: "🇹🇿", police: "112", fire: "114", ambulance: "115"),
        CountryEmergency(name: "Thailand", flag: "🇹🇭", police: "191", fire: "199", ambulance: "1669"),
        CountryEmergency(name: "Togo", flag: "🇹🇬", police: "117", fire: "118", ambulance: "112"),
        CountryEmergency(name: "Tonga", flag: "🇹🇴", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Trinidad & Tobago", flag: "🇹🇹", police: "999", fire: "990", ambulance: "811"),
        CountryEmergency(name: "Tunisia", flag: "🇹🇳", police: "197", fire: "198", ambulance: "190"),
        CountryEmergency(name: "Turkey", flag: "🇹🇷", police: "155", fire: "110", ambulance: "112"),
        CountryEmergency(name: "Turkmenistan", flag: "🇹🇲", police: "02", fire: "01", ambulance: "03"),
        
        // U
        CountryEmergency(name: "Uganda", flag: "🇺🇬", police: "999", fire: "999", ambulance: "999"),
        CountryEmergency(name: "Ukraine", flag: "🇺🇦", police: "102", fire: "101", ambulance: "103"),
        CountryEmergency(name: "UAE", flag: "🇦🇪", police: "999", fire: "997", ambulance: "998"),
        CountryEmergency(name: "United Kingdom", flag: "🇬🇧", police: "999", fire: "999", ambulance: "999"),
        CountryEmergency(name: "United States", flag: "🇺🇸", police: "911", fire: "911", ambulance: "911"),
        CountryEmergency(name: "Uruguay", flag: "🇺🇾", police: "911", fire: "104", ambulance: "105"),
        CountryEmergency(name: "Uzbekistan", flag: "🇺🇿", police: "102", fire: "101", ambulance: "103"),
        
        // V
        CountryEmergency(name: "Vanuatu", flag: "🇻🇺", police: "112", fire: "112", ambulance: "112"),
        CountryEmergency(name: "Vatican City", flag: "🇻🇦", police: "113", fire: "115", ambulance: "118"),
        CountryEmergency(name: "Venezuela", flag: "🇻🇪", police: "911", fire: "171", ambulance: "171"),
        CountryEmergency(name: "Vietnam", flag: "🇻🇳", police: "113", fire: "114", ambulance: "115"),
        
        // Y
        CountryEmergency(name: "Yemen", flag: "🇾🇪", police: "199", fire: "191", ambulance: "191"),
        
        // Z
        CountryEmergency(name: "Zambia", flag: "🇿🇲", police: "991", fire: "993", ambulance: "992"),
        CountryEmergency(name: "Zimbabwe", flag: "🇿🇼", police: "995", fire: "993", ambulance: "994")
    ]
}
