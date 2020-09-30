struct EndPoint {
    static var login: String { return "frontdesk/login"}
    static var requestpassword: String {return "reset-password/request"}
    static var attributes: String { return "organizations/%@/attributes"}
    
    static var platforms: String { return "platforms"}
    static var centers: String { return "centers"}
    static var centerwelcome: String { return "centers/self/welcome"}
    static var centerlegal: String { return "centers/self/legal"}
    static var centermenu: String {return "centers/self/menu"}

    static var refreshToken: String { return "auth/refresh-token"}
    
    static var legalaccepted: String { return "patients/self/legal-accepted"}
    static var welcomeaccepted: String { return "patients/self/welcome-accepted"}
    static var meta: String {return "patients/self/meta"}
}

struct ServerURL {
    static var baseURL: String { return "https://auth-apidev.genomcore.net/api/v1/"}
    static var recordURL: String {"https://records-apidev.genomcore.net/api/v1/"}
}
