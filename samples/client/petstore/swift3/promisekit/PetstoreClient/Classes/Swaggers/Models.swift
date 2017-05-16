// Models.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

protocol JSONEncodable {
    func encodeToJSON() -> Any
}

public enum ErrorResponse : Error {
    case Error(Int, Data?, Error)
}

open class Response<T> {
    open let statusCode: Int
    open let header: [String: String]
    open let body: T?

    public init(statusCode: Int, header: [String: String], body: T?) {
        self.statusCode = statusCode
        self.header = header
        self.body = body
    }

    public convenience init(response: HTTPURLResponse, body: T?) {
        let rawHeader = response.allHeaderFields
        var header = [String:String]()
        for (key, value) in rawHeader {
            header[key as! String] = value as? String
        }
        self.init(statusCode: response.statusCode, header: header, body: body)
    }
}

private var once = Int()
class Decoders {
    static fileprivate var decoders = Dictionary<String, ((AnyObject, AnyObject?) -> AnyObject)>()

    static func addDecoder<T>(clazz: T.Type, decoder: @escaping ((AnyObject, AnyObject?) -> T)) {
        let key = "\(T.self)"
        decoders[key] = { decoder($0, $1) as AnyObject }
    }

    static func decode<T>(clazz: T.Type, discriminator: String, source: AnyObject) -> T {
        let key = discriminator;
        if let decoder = decoders[key] {
            return decoder(source, nil) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decode<T>(clazz: [T].Type, source: AnyObject) -> [T] {
        let array = source as! [AnyObject]
        return array.map { Decoders.decode(clazz: T.self, source: $0, instance: nil) }
    }

    static func decode<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject) -> [Key:T] {
        let sourceDictionary = source as! [Key: AnyObject]
        var dictionary = [Key:T]()
        for (key, value) in sourceDictionary {
            dictionary[key] = Decoders.decode(clazz: T.self, source: value, instance: nil)
        }
        return dictionary
    }

    static func decode<T>(clazz: T.Type, source: AnyObject, instance: AnyObject?) -> T {
        initialize()
        if T.self is Int32.Type && source is NSNumber {
            return (source as! NSNumber).int32Value as! T;
        }
        if T.self is Int64.Type && source is NSNumber {
            return source.int64Value as! T;
        }
        if T.self is UUID.Type && source is String {
            return UUID(uuidString: source as! String) as! T
        }
        if source is T {
            return source as! T
        }
        if T.self is Data.Type && source is String {
            return Data(base64Encoded: source as! String) as! T
        }

        let key = "\(T.self)"
        if let decoder = decoders[key] {
           return decoder(source, instance) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decodeOptional<T>(clazz: T.Type, source: AnyObject?) -> T? {
        if source is NSNull {
            return nil
        }
        return source.map { (source: AnyObject) -> T in
            Decoders.decode(clazz: clazz, source: source, instance: nil)
        }
    }

    static func decodeOptional<T>(clazz: [T].Type, source: AnyObject?) -> [T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    static func decodeOptional<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject?) -> [Key:T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [Key:T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    private static var __once: () = {
        let formatters = [
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd HH:mm:ss"
        ].map { (format: String) -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            return formatter
        }
        // Decoder for Date
        Decoders.addDecoder(clazz: Date.self) { (source: AnyObject, instance: AnyObject?) -> Date in
           if let sourceString = source as? String {
                for formatter in formatters {
                    if let date = formatter.date(from: sourceString) {
                        return date
                    }
                }
            }
            if let sourceInt = source as? Int64 {
                // treat as a java date
                return Date(timeIntervalSince1970: Double(sourceInt / 1000) )
            }
            fatalError("formatter failed to parse \(source)")
        } 

        // Decoder for [AdditionalPropertiesClass]
        Decoders.addDecoder(clazz: [AdditionalPropertiesClass].self) { (source: AnyObject, instance: AnyObject?) -> [AdditionalPropertiesClass] in
            return Decoders.decode(clazz: [AdditionalPropertiesClass].self, source: source)
        }
        // Decoder for AdditionalPropertiesClass
        Decoders.addDecoder(clazz: AdditionalPropertiesClass.self) { (source: AnyObject, instance: AnyObject?) -> AdditionalPropertiesClass in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? AdditionalPropertiesClass() : instance as! AdditionalPropertiesClass
            
            result.mapProperty = Decoders.decodeOptional(clazz: Dictionary.self, source: sourceDictionary["map_property"] as AnyObject?)
            result.mapOfMapProperty = Decoders.decodeOptional(clazz: Dictionary.self, source: sourceDictionary["map_of_map_property"] as AnyObject?)
            return result
        }


        // Decoder for [Animal]
        Decoders.addDecoder(clazz: [Animal].self) { (source: AnyObject, instance: AnyObject?) -> [Animal] in
            return Decoders.decode(clazz: [Animal].self, source: source)
        }
        // Decoder for Animal
        Decoders.addDecoder(clazz: Animal.self) { (source: AnyObject, instance: AnyObject?) -> Animal in
            let sourceDictionary = source as! [AnyHashable: Any]
            // Check discriminator to support inheritance
            if let discriminator = sourceDictionary["className"] as? String, instance == nil && discriminator != "Animal" {
                return Decoders.decode(clazz: Animal.self, discriminator: discriminator, source: source)
            }
            let result = instance == nil ? Animal() : instance as! Animal
            
            result.className = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["className"] as AnyObject?)
            result.color = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["color"] as AnyObject?)
            return result
        }


        // Decoder for [AnimalFarm]
        Decoders.addDecoder(clazz: [AnimalFarm].self) { (source: AnyObject, instance: AnyObject?) -> [AnimalFarm] in
            return Decoders.decode(clazz: [AnimalFarm].self, source: source)
        }
        // Decoder for AnimalFarm
        Decoders.addDecoder(clazz: AnimalFarm.self) { (source: AnyObject, instance: AnyObject?) -> AnimalFarm in
            let sourceArray = source as! [AnyObject]
            return sourceArray.map({ Decoders.decode(clazz: Animal.self, source: $0, instance: nil) })
        }


        // Decoder for [ApiResponse]
        Decoders.addDecoder(clazz: [ApiResponse].self) { (source: AnyObject, instance: AnyObject?) -> [ApiResponse] in
            return Decoders.decode(clazz: [ApiResponse].self, source: source)
        }
        // Decoder for ApiResponse
        Decoders.addDecoder(clazz: ApiResponse.self) { (source: AnyObject, instance: AnyObject?) -> ApiResponse in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? ApiResponse() : instance as! ApiResponse
            
            result.code = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["code"] as AnyObject?)
            result.type = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"] as AnyObject?)
            result.message = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["message"] as AnyObject?)
            return result
        }


        // Decoder for [ArrayOfArrayOfNumberOnly]
        Decoders.addDecoder(clazz: [ArrayOfArrayOfNumberOnly].self) { (source: AnyObject, instance: AnyObject?) -> [ArrayOfArrayOfNumberOnly] in
            return Decoders.decode(clazz: [ArrayOfArrayOfNumberOnly].self, source: source)
        }
        // Decoder for ArrayOfArrayOfNumberOnly
        Decoders.addDecoder(clazz: ArrayOfArrayOfNumberOnly.self) { (source: AnyObject, instance: AnyObject?) -> ArrayOfArrayOfNumberOnly in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? ArrayOfArrayOfNumberOnly() : instance as! ArrayOfArrayOfNumberOnly
            
            result.arrayArrayNumber = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["ArrayArrayNumber"] as AnyObject?)
            return result
        }


        // Decoder for [ArrayOfNumberOnly]
        Decoders.addDecoder(clazz: [ArrayOfNumberOnly].self) { (source: AnyObject, instance: AnyObject?) -> [ArrayOfNumberOnly] in
            return Decoders.decode(clazz: [ArrayOfNumberOnly].self, source: source)
        }
        // Decoder for ArrayOfNumberOnly
        Decoders.addDecoder(clazz: ArrayOfNumberOnly.self) { (source: AnyObject, instance: AnyObject?) -> ArrayOfNumberOnly in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? ArrayOfNumberOnly() : instance as! ArrayOfNumberOnly
            
            result.arrayNumber = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["ArrayNumber"] as AnyObject?)
            return result
        }


        // Decoder for [ArrayTest]
        Decoders.addDecoder(clazz: [ArrayTest].self) { (source: AnyObject, instance: AnyObject?) -> [ArrayTest] in
            return Decoders.decode(clazz: [ArrayTest].self, source: source)
        }
        // Decoder for ArrayTest
        Decoders.addDecoder(clazz: ArrayTest.self) { (source: AnyObject, instance: AnyObject?) -> ArrayTest in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? ArrayTest() : instance as! ArrayTest
            
            result.arrayOfString = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["array_of_string"] as AnyObject?)
            result.arrayArrayOfInteger = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["array_array_of_integer"] as AnyObject?)
            result.arrayArrayOfModel = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["array_array_of_model"] as AnyObject?)
            return result
        }


        // Decoder for [Capitalization]
        Decoders.addDecoder(clazz: [Capitalization].self) { (source: AnyObject, instance: AnyObject?) -> [Capitalization] in
            return Decoders.decode(clazz: [Capitalization].self, source: source)
        }
        // Decoder for Capitalization
        Decoders.addDecoder(clazz: Capitalization.self) { (source: AnyObject, instance: AnyObject?) -> Capitalization in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? Capitalization() : instance as! Capitalization
            
            result.smallCamel = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["smallCamel"] as AnyObject?)
            result.capitalCamel = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["CapitalCamel"] as AnyObject?)
            result.smallSnake = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["small_Snake"] as AnyObject?)
            result.capitalSnake = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["Capital_Snake"] as AnyObject?)
            result.sCAETHFlowPoints = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["SCA_ETH_Flow_Points"] as AnyObject?)
            result.ATT_NAME = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["ATT_NAME"] as AnyObject?)
            return result
        }


        // Decoder for [Cat]
        Decoders.addDecoder(clazz: [Cat].self) { (source: AnyObject, instance: AnyObject?) -> [Cat] in
            return Decoders.decode(clazz: [Cat].self, source: source)
        }
        // Decoder for Cat
        Decoders.addDecoder(clazz: Cat.self) { (source: AnyObject, instance: AnyObject?) -> Cat in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? Cat() : instance as! Cat
            if decoders["\(Animal.self)"] != nil {
              _ = Decoders.decode(clazz: Animal.self, source: source, instance: result)
            }
            
            result.className = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["className"] as AnyObject?)
            result.color = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["color"] as AnyObject?)
            result.declawed = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["declawed"] as AnyObject?)
            return result
        }


        // Decoder for [Category]
        Decoders.addDecoder(clazz: [Category].self) { (source: AnyObject, instance: AnyObject?) -> [Category] in
            return Decoders.decode(clazz: [Category].self, source: source)
        }
        // Decoder for Category
        Decoders.addDecoder(clazz: Category.self) { (source: AnyObject, instance: AnyObject?) -> Category in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? Category() : instance as! Category
            
            result.id = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"] as AnyObject?)
            result.name = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?)
            return result
        }


        // Decoder for [ClassModel]
        Decoders.addDecoder(clazz: [ClassModel].self) { (source: AnyObject, instance: AnyObject?) -> [ClassModel] in
            return Decoders.decode(clazz: [ClassModel].self, source: source)
        }
        // Decoder for ClassModel
        Decoders.addDecoder(clazz: ClassModel.self) { (source: AnyObject, instance: AnyObject?) -> ClassModel in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? ClassModel() : instance as! ClassModel
            
            result._class = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["_class"] as AnyObject?)
            return result
        }


        // Decoder for [Client]
        Decoders.addDecoder(clazz: [Client].self) { (source: AnyObject, instance: AnyObject?) -> [Client] in
            return Decoders.decode(clazz: [Client].self, source: source)
        }
        // Decoder for Client
        Decoders.addDecoder(clazz: Client.self) { (source: AnyObject, instance: AnyObject?) -> Client in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? Client() : instance as! Client
            
            result.client = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["client"] as AnyObject?)
            return result
        }


        // Decoder for [Dog]
        Decoders.addDecoder(clazz: [Dog].self) { (source: AnyObject, instance: AnyObject?) -> [Dog] in
            return Decoders.decode(clazz: [Dog].self, source: source)
        }
        // Decoder for Dog
        Decoders.addDecoder(clazz: Dog.self) { (source: AnyObject, instance: AnyObject?) -> Dog in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? Dog() : instance as! Dog
            if decoders["\(Animal.self)"] != nil {
              _ = Decoders.decode(clazz: Animal.self, source: source, instance: result)
            }
            
            result.className = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["className"] as AnyObject?)
            result.color = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["color"] as AnyObject?)
            result.breed = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["breed"] as AnyObject?)
            return result
        }


        // Decoder for [EnumArrays]
        Decoders.addDecoder(clazz: [EnumArrays].self) { (source: AnyObject, instance: AnyObject?) -> [EnumArrays] in
            return Decoders.decode(clazz: [EnumArrays].self, source: source)
        }
        // Decoder for EnumArrays
        Decoders.addDecoder(clazz: EnumArrays.self) { (source: AnyObject, instance: AnyObject?) -> EnumArrays in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? EnumArrays() : instance as! EnumArrays
            
            if let justSymbol = sourceDictionary["just_symbol"] as? String { 
                result.justSymbol = EnumArrays.JustSymbol(rawValue: (justSymbol))
            }
            
            if let arrayEnum = sourceDictionary["array_enum"] as? [String] { 
                result.arrayEnum  = arrayEnum.map ({ EnumArrays.ArrayEnum(rawValue: $0)! })
            }
            
            return result
        }


        // Decoder for [EnumClass]
        Decoders.addDecoder(clazz: [EnumClass].self) { (source: AnyObject, instance: AnyObject?) -> [EnumClass] in
            return Decoders.decode(clazz: [EnumClass].self, source: source)
        }
        // Decoder for EnumClass
        Decoders.addDecoder(clazz: EnumClass.self) { (source: AnyObject, instance: AnyObject?) -> EnumClass in
            if let source = source as? String {
                if let result = EnumClass(rawValue: source) {
                    return result
                }
            }
            fatalError("Source \(source) is not convertible to enum type EnumClass: Maybe swagger file is insufficient")
        }


        // Decoder for [EnumTest]
        Decoders.addDecoder(clazz: [EnumTest].self) { (source: AnyObject, instance: AnyObject?) -> [EnumTest] in
            return Decoders.decode(clazz: [EnumTest].self, source: source)
        }
        // Decoder for EnumTest
        Decoders.addDecoder(clazz: EnumTest.self) { (source: AnyObject, instance: AnyObject?) -> EnumTest in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? EnumTest() : instance as! EnumTest
            
            if let enumString = sourceDictionary["enum_string"] as? String { 
                result.enumString = EnumTest.EnumString(rawValue: (enumString))
            }
            
            if let enumInteger = sourceDictionary["enum_integer"] as? Int32 { 
                result.enumInteger = EnumTest.EnumInteger(rawValue: (enumInteger))
            }
            
            if let enumNumber = sourceDictionary["enum_number"] as? Double { 
                result.enumNumber = EnumTest.EnumNumber(rawValue: (enumNumber))
            }
            
            result.outerEnum = Decoders.decodeOptional(clazz: OuterEnum.self, source: sourceDictionary["outerEnum"] as AnyObject?)
            return result
        }


        // Decoder for [FormatTest]
        Decoders.addDecoder(clazz: [FormatTest].self) { (source: AnyObject, instance: AnyObject?) -> [FormatTest] in
            return Decoders.decode(clazz: [FormatTest].self, source: source)
        }
        // Decoder for FormatTest
        Decoders.addDecoder(clazz: FormatTest.self) { (source: AnyObject, instance: AnyObject?) -> FormatTest in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? FormatTest() : instance as! FormatTest
            
            result.integer = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["integer"] as AnyObject?)
            result.int32 = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["int32"] as AnyObject?)
            result.int64 = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["int64"] as AnyObject?)
            result.number = Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["number"] as AnyObject?)
            result.float = Decoders.decodeOptional(clazz: Float.self, source: sourceDictionary["float"] as AnyObject?)
            result.double = Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["double"] as AnyObject?)
            result.string = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["string"] as AnyObject?)
            result.byte = Decoders.decodeOptional(clazz: Data.self, source: sourceDictionary["byte"] as AnyObject?)
            result.binary = Decoders.decodeOptional(clazz: Data.self, source: sourceDictionary["binary"] as AnyObject?)
            result.date = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["date"] as AnyObject?)
            result.dateTime = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["dateTime"] as AnyObject?)
            result.uuid = Decoders.decodeOptional(clazz: UUID.self, source: sourceDictionary["uuid"] as AnyObject?)
            result.password = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"] as AnyObject?)
            return result
        }


        // Decoder for [HasOnlyReadOnly]
        Decoders.addDecoder(clazz: [HasOnlyReadOnly].self) { (source: AnyObject, instance: AnyObject?) -> [HasOnlyReadOnly] in
            return Decoders.decode(clazz: [HasOnlyReadOnly].self, source: source)
        }
        // Decoder for HasOnlyReadOnly
        Decoders.addDecoder(clazz: HasOnlyReadOnly.self) { (source: AnyObject, instance: AnyObject?) -> HasOnlyReadOnly in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? HasOnlyReadOnly() : instance as! HasOnlyReadOnly
            
            result.bar = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["bar"] as AnyObject?)
            result.foo = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["foo"] as AnyObject?)
            return result
        }


        // Decoder for [List]
        Decoders.addDecoder(clazz: [List].self) { (source: AnyObject, instance: AnyObject?) -> [List] in
            return Decoders.decode(clazz: [List].self, source: source)
        }
        // Decoder for List
        Decoders.addDecoder(clazz: List.self) { (source: AnyObject, instance: AnyObject?) -> List in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? List() : instance as! List
            
            result._123List = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["123-list"] as AnyObject?)
            return result
        }


        // Decoder for [MapTest]
        Decoders.addDecoder(clazz: [MapTest].self) { (source: AnyObject, instance: AnyObject?) -> [MapTest] in
            return Decoders.decode(clazz: [MapTest].self, source: source)
        }
        // Decoder for MapTest
        Decoders.addDecoder(clazz: MapTest.self) { (source: AnyObject, instance: AnyObject?) -> MapTest in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? MapTest() : instance as! MapTest
            
            result.mapMapOfString = Decoders.decodeOptional(clazz: Dictionary.self, source: sourceDictionary["map_map_of_string"] as AnyObject?)
            if let mapOfEnumString = sourceDictionary["map_of_enum_string"] as? [String:String] { //TODO: handle enum map scenario
            }
            
            return result
        }


        // Decoder for [MixedPropertiesAndAdditionalPropertiesClass]
        Decoders.addDecoder(clazz: [MixedPropertiesAndAdditionalPropertiesClass].self) { (source: AnyObject, instance: AnyObject?) -> [MixedPropertiesAndAdditionalPropertiesClass] in
            return Decoders.decode(clazz: [MixedPropertiesAndAdditionalPropertiesClass].self, source: source)
        }
        // Decoder for MixedPropertiesAndAdditionalPropertiesClass
        Decoders.addDecoder(clazz: MixedPropertiesAndAdditionalPropertiesClass.self) { (source: AnyObject, instance: AnyObject?) -> MixedPropertiesAndAdditionalPropertiesClass in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? MixedPropertiesAndAdditionalPropertiesClass() : instance as! MixedPropertiesAndAdditionalPropertiesClass
            
            result.uuid = Decoders.decodeOptional(clazz: UUID.self, source: sourceDictionary["uuid"] as AnyObject?)
            result.dateTime = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["dateTime"] as AnyObject?)
            result.map = Decoders.decodeOptional(clazz: Dictionary.self, source: sourceDictionary["map"] as AnyObject?)
            return result
        }


        // Decoder for [Model200Response]
        Decoders.addDecoder(clazz: [Model200Response].self) { (source: AnyObject, instance: AnyObject?) -> [Model200Response] in
            return Decoders.decode(clazz: [Model200Response].self, source: source)
        }
        // Decoder for Model200Response
        Decoders.addDecoder(clazz: Model200Response.self) { (source: AnyObject, instance: AnyObject?) -> Model200Response in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? Model200Response() : instance as! Model200Response
            
            result.name = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["name"] as AnyObject?)
            result._class = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["class"] as AnyObject?)
            return result
        }


        // Decoder for [Name]
        Decoders.addDecoder(clazz: [Name].self) { (source: AnyObject, instance: AnyObject?) -> [Name] in
            return Decoders.decode(clazz: [Name].self, source: source)
        }
        // Decoder for Name
        Decoders.addDecoder(clazz: Name.self) { (source: AnyObject, instance: AnyObject?) -> Name in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? Name() : instance as! Name
            
            result.name = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["name"] as AnyObject?)
            result.snakeCase = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["snake_case"] as AnyObject?)
            result.property = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["property"] as AnyObject?)
            result._123Number = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["123Number"] as AnyObject?)
            return result
        }


        // Decoder for [NumberOnly]
        Decoders.addDecoder(clazz: [NumberOnly].self) { (source: AnyObject, instance: AnyObject?) -> [NumberOnly] in
            return Decoders.decode(clazz: [NumberOnly].self, source: source)
        }
        // Decoder for NumberOnly
        Decoders.addDecoder(clazz: NumberOnly.self) { (source: AnyObject, instance: AnyObject?) -> NumberOnly in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? NumberOnly() : instance as! NumberOnly
            
            result.justNumber = Decoders.decodeOptional(clazz: Double.self, source: sourceDictionary["JustNumber"] as AnyObject?)
            return result
        }


        // Decoder for [Order]
        Decoders.addDecoder(clazz: [Order].self) { (source: AnyObject, instance: AnyObject?) -> [Order] in
            return Decoders.decode(clazz: [Order].self, source: source)
        }
        // Decoder for Order
        Decoders.addDecoder(clazz: Order.self) { (source: AnyObject, instance: AnyObject?) -> Order in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? Order() : instance as! Order
            
            result.id = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"] as AnyObject?)
            result.petId = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["petId"] as AnyObject?)
            result.quantity = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["quantity"] as AnyObject?)
            result.shipDate = Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["shipDate"] as AnyObject?)
            if let status = sourceDictionary["status"] as? String { 
                result.status = Order.Status(rawValue: (status))
            }
            
            result.complete = Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["complete"] as AnyObject?)
            return result
        }


        // Decoder for [OuterBoolean]
        Decoders.addDecoder(clazz: [OuterBoolean].self) { (source: AnyObject) -> [OuterBoolean] in
            return Decoders.decode(clazz: [OuterBoolean].self, source: source)
        }
        // Decoder for OuterBoolean
        Decoders.addDecoder(clazz: OuterBoolean.self) { (source: AnyObject) -> OuterBoolean in
            if let source = source as? Bool {
                return source
            }
            fatalError("Source \(source) is not convertible to typealias OuterBoolean: Maybe swagger file is insufficient")
        }


        // Decoder for [OuterComposite]
        Decoders.addDecoder(clazz: [OuterComposite].self) { (source: AnyObject) -> [OuterComposite] in
            return Decoders.decode(clazz: [OuterComposite].self, source: source)
        }
        // Decoder for OuterComposite
        Decoders.addDecoder(clazz: OuterComposite.self) { (source: AnyObject) -> OuterComposite in
            let sourceDictionary = source as! [AnyHashable: Any]

            let instance = OuterComposite()
            instance.myNumber = Decoders.decodeOptional(clazz: OuterNumber.self, source: sourceDictionary["my_number"] as AnyObject?)
            instance.myString = Decoders.decodeOptional(clazz: OuterString.self, source: sourceDictionary["my_string"] as AnyObject?)
            instance.myBoolean = Decoders.decodeOptional(clazz: OuterBoolean.self, source: sourceDictionary["my_boolean"] as AnyObject?)
            return instance
        }


        // Decoder for [OuterEnum]
        Decoders.addDecoder(clazz: [OuterEnum].self) { (source: AnyObject, instance: AnyObject?) -> [OuterEnum] in
            return Decoders.decode(clazz: [OuterEnum].self, source: source)
        }
        // Decoder for OuterEnum
        Decoders.addDecoder(clazz: OuterEnum.self) { (source: AnyObject, instance: AnyObject?) -> OuterEnum in
            if let source = source as? String {
                if let result = OuterEnum(rawValue: source) {
                    return result
                }
            }
            fatalError("Source \(source) is not convertible to enum type OuterEnum: Maybe swagger file is insufficient")
        }


        // Decoder for [OuterNumber]
        Decoders.addDecoder(clazz: [OuterNumber].self) { (source: AnyObject) -> [OuterNumber] in
            return Decoders.decode(clazz: [OuterNumber].self, source: source)
        }
        // Decoder for OuterNumber
        Decoders.addDecoder(clazz: OuterNumber.self) { (source: AnyObject) -> OuterNumber in
            if let source = source as? Double {
                return source
            }
            fatalError("Source \(source) is not convertible to typealias OuterNumber: Maybe swagger file is insufficient")
        }


        // Decoder for [OuterString]
        Decoders.addDecoder(clazz: [OuterString].self) { (source: AnyObject) -> [OuterString] in
            return Decoders.decode(clazz: [OuterString].self, source: source)
        }
        // Decoder for OuterString
        Decoders.addDecoder(clazz: OuterString.self) { (source: AnyObject) -> OuterString in
            if let source = source as? String {
                return source
            }
            fatalError("Source \(source) is not convertible to typealias OuterString: Maybe swagger file is insufficient")
        }


        // Decoder for [Pet]
        Decoders.addDecoder(clazz: [Pet].self) { (source: AnyObject, instance: AnyObject?) -> [Pet] in
            return Decoders.decode(clazz: [Pet].self, source: source)
        }
        // Decoder for Pet
        Decoders.addDecoder(clazz: Pet.self) { (source: AnyObject, instance: AnyObject?) -> Pet in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? Pet() : instance as! Pet
            
            result.id = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"] as AnyObject?)
            result.category = Decoders.decodeOptional(clazz: Category.self, source: sourceDictionary["category"] as AnyObject?)
            result.name = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?)
            result.photoUrls = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["photoUrls"] as AnyObject?)
            result.tags = Decoders.decodeOptional(clazz: Array.self, source: sourceDictionary["tags"] as AnyObject?)
            if let status = sourceDictionary["status"] as? String { 
                result.status = Pet.Status(rawValue: (status))
            }
            
            return result
        }


        // Decoder for [ReadOnlyFirst]
        Decoders.addDecoder(clazz: [ReadOnlyFirst].self) { (source: AnyObject, instance: AnyObject?) -> [ReadOnlyFirst] in
            return Decoders.decode(clazz: [ReadOnlyFirst].self, source: source)
        }
        // Decoder for ReadOnlyFirst
        Decoders.addDecoder(clazz: ReadOnlyFirst.self) { (source: AnyObject, instance: AnyObject?) -> ReadOnlyFirst in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? ReadOnlyFirst() : instance as! ReadOnlyFirst
            
            result.bar = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["bar"] as AnyObject?)
            result.baz = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["baz"] as AnyObject?)
            return result
        }


        // Decoder for [Return]
        Decoders.addDecoder(clazz: [Return].self) { (source: AnyObject, instance: AnyObject?) -> [Return] in
            return Decoders.decode(clazz: [Return].self, source: source)
        }
        // Decoder for Return
        Decoders.addDecoder(clazz: Return.self) { (source: AnyObject, instance: AnyObject?) -> Return in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? Return() : instance as! Return
            
            result._return = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["return"] as AnyObject?)
            return result
        }


        // Decoder for [SpecialModelName]
        Decoders.addDecoder(clazz: [SpecialModelName].self) { (source: AnyObject, instance: AnyObject?) -> [SpecialModelName] in
            return Decoders.decode(clazz: [SpecialModelName].self, source: source)
        }
        // Decoder for SpecialModelName
        Decoders.addDecoder(clazz: SpecialModelName.self) { (source: AnyObject, instance: AnyObject?) -> SpecialModelName in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? SpecialModelName() : instance as! SpecialModelName
            
            result.specialPropertyName = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["$special[property.name]"] as AnyObject?)
            return result
        }


        // Decoder for [Tag]
        Decoders.addDecoder(clazz: [Tag].self) { (source: AnyObject, instance: AnyObject?) -> [Tag] in
            return Decoders.decode(clazz: [Tag].self, source: source)
        }
        // Decoder for Tag
        Decoders.addDecoder(clazz: Tag.self) { (source: AnyObject, instance: AnyObject?) -> Tag in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? Tag() : instance as! Tag
            
            result.id = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"] as AnyObject?)
            result.name = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"] as AnyObject?)
            return result
        }


        // Decoder for [User]
        Decoders.addDecoder(clazz: [User].self) { (source: AnyObject, instance: AnyObject?) -> [User] in
            return Decoders.decode(clazz: [User].self, source: source)
        }
        // Decoder for User
        Decoders.addDecoder(clazz: User.self) { (source: AnyObject, instance: AnyObject?) -> User in
            let sourceDictionary = source as! [AnyHashable: Any]
            let result = instance == nil ? User() : instance as! User
            
            result.id = Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"] as AnyObject?)
            result.username = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["username"] as AnyObject?)
            result.firstName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["firstName"] as AnyObject?)
            result.lastName = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastName"] as AnyObject?)
            result.email = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["email"] as AnyObject?)
            result.password = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"] as AnyObject?)
            result.phone = Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["phone"] as AnyObject?)
            result.userStatus = Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["userStatus"] as AnyObject?)
            return result
        }
    }()

    static fileprivate func initialize() {
        _ = Decoders.__once
    }
}