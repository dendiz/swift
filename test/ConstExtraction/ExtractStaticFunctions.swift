// RUN: %empty-directory(%t)
// RUN: echo "[MyProto]" > %t/protocols.json

// RUN: %target-swift-frontend -typecheck -emit-const-values-path %t/ExtractStaticFunctions.swiftconstvalues -const-gather-protocols-file %t/protocols.json -primary-file %s
// RUN: cat %t/ExtractStaticFunctions.swiftconstvalues 2>&1 | %FileCheck %s

protocol MyProto {}

enum Bar {
    case one
    case two(item: String)
}

class Doh {
    init(_ p: String) {}
}

class Baz {
    static var one: Baz {
        Baz()
    }

    static func two(item: String) -> Baz {
        return Baz()
    }

    static func three() -> Baz {
        return Baz()
    }
    var instanceProp: String = ""
    var instancePropSelf: Baz {
        self
    }
}

struct Statics: MyProto {
    var bar1 = Bar.one
    var bar2 = Bar.two(item: "bar")
    var baz1 = Baz.one
    var baz2 = Baz.two(item: "baz")
    var baz3 = Baz.three()
    var baz4 = Baz.one.instancePropSelf.instanceProp
    var baz5 = Doh(Baz.one.instancePropSelf.instanceProp)
}

// CHECK:       "label": "bar1",
// CHECK-NEXT:  "type": "ExtractStaticFunctions.Bar",
// CHECK:       "valueKind": "Enum",
// CHECK-NEXT:  "value": {
// CHECK-NEXT:    "name": "one"
// CHECK-NEXT:  }
// CHECK:       "label": "bar2",
// CHECK-NEXT:  "type": "ExtractStaticFunctions.Bar",
// CHECK:       "valueKind": "Enum",
// CHECK-NEXT:  "value": {
// CHECK-NEXT:    "name": "two",
// CHECK-NEXT:    "arguments": [
// CHECK-NEXT:      {
// CHECK-NEXT:        "label": "item",
// CHECK-NEXT:        "type": "Swift.String",
// CHECK-NEXT:        "valueKind": "RawLiteral",
// CHECK-NEXT:        "value": "bar"
// CHECK-NEXT:      }
// CHECK-NEXT:    ]
// CHECK-NEXT:  }
// CHECK:       "label": "baz1",
// CHECK-NEXT:  "type": "ExtractStaticFunctions.Baz",
// CHECK:       "valueKind": "MemberReference"
// CHECK-NEXT:  "value": {
// CHECK-NEXT:    "baseType": "ExtractStaticFunctions.Baz",
// CHECK-NEXT:    "memberLabel": "one"
// CHECK-NEXT:  }
// CHECK:       "label": "baz2",
// CHECK-NEXT:  "type": "ExtractStaticFunctions.Baz",
// CHECK:       "valueKind": "StaticFunctionCall",
// CHECK-NEXT:  "value": {
// CHECK-NEXT:    "type": "ExtractStaticFunctions.Baz",
// CHECK-NEXT:    "memberLabel": "two",
// CHECK-NEXT:    "arguments": [
// CHECK-NEXT:      {
// CHECK-NEXT:        "label": "item",
// CHECK-NEXT:        "type": "Swift.String",
// CHECK-NEXT:        "valueKind": "RawLiteral",
// CHECK-NEXT:        "value": "baz"
// CHECK-NEXT:      }
// CHECK-NEXT:    ]
// CHECK-NEXT:  }
// CHECK:       "label": "baz3",
// CHECK-NEXT:  "type": "ExtractStaticFunctions.Baz",
// CHECK:       "valueKind": "StaticFunctionCall",
// CHECK-NEXT:  "value": {
// CHECK-NEXT:    "type": "ExtractStaticFunctions.Baz",
// CHECK-NEXT:    "memberLabel": "three",
// CHECK-NEXT:    "arguments": []
// CHECK-NEXT:  }
// CHECK:       "label": "baz4",
// CHECK-NEXT:  "type": "Swift.String",
// CHECK:       "valueKind": "ChainedMemberReference",
// CHECK-NEXT:  "value": {
// CHECK-NEXT:    "chain": [
// CHECK-NEXT:      {
// CHECK-NEXT:        "valueKind": "MemberReference",
// CHECK-NEXT:        "value": {
// CHECK-NEXT:          "baseType": "ExtractStaticFunctions.Baz",
// CHECK-NEXT:          "memberLabel": "one"
// CHECK-NEXT:        }
// CHECK-NEXT:      },
// CHECK-NEXT:      {
// CHECK-NEXT:        "valueKind": "MemberReference",
// CHECK-NEXT:        "value": {
// CHECK-NEXT:          "baseType": "ExtractStaticFunctions.Baz",
// CHECK-NEXT:          "memberLabel": "instancePropSelf"
// CHECK-NEXT:        }
// CHECK-NEXT:      },
// CHECK-NEXT:      {
// CHECK-NEXT:        "valueKind": "MemberReference",
// CHECK-NEXT:        "value": {
// CHECK-NEXT:          "baseType": "ExtractStaticFunctions.Baz",
// CHECK-NEXT:          "memberLabel": "instanceProp"
// CHECK-NEXT:        }
// CHECK-NEXT:      }
// CHECK-NEXT:    ]
// CHECK-NEXT:  }
// CHECK:       "label": "baz5",
// CHECK-NEXT:  "type": "ExtractStaticFunctions.Doh",
// CHECK:       "valueKind": "InitCall",
// CHECK-NEXT:  "value": {
// CHECK-NEXT:    "type": "ExtractStaticFunctions.Doh",
// CHECK-NEXT:    "arguments": [
// CHECK-NEXT:      {
// CHECK-NEXT:        "label": "",
// CHECK-NEXT:        "type": "Swift.String",
// CHECK-NEXT:        "valueKind": "ChainedMemberReference",
// CHECK-NEXT:        "value": {
// CHECK-NEXT:          "chain": [
// CHECK-NEXT:            {
// CHECK-NEXT:              "valueKind": "MemberReference",
// CHECK-NEXT:              "value": {
// CHECK-NEXT:                "baseType": "ExtractStaticFunctions.Baz",
// CHECK-NEXT:                "memberLabel": "one"
// CHECK-NEXT:              }
// CHECK-NEXT:            },
// CHECK-NEXT:            {
// CHECK-NEXT:              "valueKind": "MemberReference",
// CHECK-NEXT:              "value": {
// CHECK-NEXT:                "baseType": "ExtractStaticFunctions.Baz",
// CHECK-NEXT:                "memberLabel": "instancePropSelf"
// CHECK-NEXT:              }
// CHECK-NEXT:            },
// CHECK-NEXT:            {
// CHECK-NEXT:              "valueKind": "MemberReference",
// CHECK-NEXT:              "value": {
// CHECK-NEXT:                "baseType": "ExtractStaticFunctions.Baz",
// CHECK-NEXT:                "memberLabel": "instanceProp"
// CHECK-NEXT:              }
// CHECK-NEXT:            }
// CHECK-NEXT:          ]
// CHECK-NEXT:        }
// CHECK-NEXT:      }
// CHECK-NEXT:    ]
// CHECK-NEXT:  }
