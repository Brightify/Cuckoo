//
//  MockTemplate.swift
//  CuckooGeneratorFramework
//
//  Created by Tadeas Kriz on 11/14/17.
//

import Foundation

extension Templates {
    static let staticGenericParameter = "_CUCKOO$$GENERIC"
    static let typeErasureClassName = "DefaultImplCaller"
    static let mock = """
{% for container in containers %}
{% for attribute in container.attributes %}
{{ attribute.text }}
{% endfor %}
{{ container.accessibility }} class {{ classPrefix }}{{ container.mockName }}{{ container.genericParameters }}: {{ container.name }}{% if container.isImplementation %}{{ container.genericArguments }}{% endif %}, {% if container.isImplementation %}Cuckoo.ClassMock{% else %}Cuckoo.ProtocolMock{% endif %} {
    {% if container.isGeneric and not container.isImplementation %}
    {{ container.accessibility }} typealias MocksType = \(typeErasureClassName){{ container.genericArguments }}
    {% else %}
    {{ container.accessibility }} typealias MocksType = {{ container.name }}{{ container.genericArguments }}
    {% endif %}
    {{ container.accessibility }} typealias Stubbing = __StubbingProxy_{{ container.name }}
    {{ container.accessibility }} typealias Verification = __VerificationProxy_{{ container.name }}

    {{ container.accessibility }} let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: {{ container.isImplementation }})

    {% if container.isGeneric and not container.isImplementation %}
\(Templates.typeErasure.indented())

    private var __defaultImplStub: \(typeErasureClassName){{ container.genericArguments }}?

    {{ container.accessibility }} func enableDefaultImplementation<\(staticGenericParameter): {{ container.name }}>(_ stub: \(staticGenericParameter)) where {{ container.genericProtocolIdentity }} {
        var mutableStub = stub
        __defaultImplStub = \(typeErasureClassName)(from: &mutableStub, keeping: mutableStub)
        cuckoo_manager.enableDefaultStubImplementation()
    }

    {{ container.accessibility }} func enableDefaultImplementation<\(staticGenericParameter): {{ container.name }}>(mutating stub: UnsafeMutablePointer<\(staticGenericParameter)>) where {{ container.genericProtocolIdentity }} {
        __defaultImplStub = \(typeErasureClassName)(from: stub, keeping: nil)
        cuckoo_manager.enableDefaultStubImplementation()
    }
    {% else %}
    private var __defaultImplStub: {{ container.name }}{{ container.genericArguments }}?

    {{ container.accessibility }} func enableDefaultImplementation(_ stub: {{ container.name }}{{ container.genericArguments }}) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    {% endif %}

    {% for property in container.properties %}
    {% if debug %}
    // {{property}}
    {% endif %}
    {% for attribute in property.attributes %}
    {{ attribute.text }}
    {% endfor %}
    {{ property.accessibility }}{% if container.isImplementation %} override{% endif %} var {{ property.name }}: {{ property.type }} {
        get {
            return cuckoo_manager.getter("{{ property.name }}",
                superclassCall:
                    {% if container.isImplementation %}
                    super.{{ property.name }}
                    {% else %}
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    {% endif %},
                defaultCall: __defaultImplStub!.{{property.name}})
        }
        {% ifnot property.isReadOnly %}
        set {
            cuckoo_manager.setter("{{ property.name }}",
                value: newValue,
                superclassCall:
                    {% if container.isImplementation %}
                    super.{{ property.name }} = newValue
                    {% else %}
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    {% endif %},
                defaultCall: __defaultImplStub!.{{property.name}} = newValue)
        }
        {% endif %}
    }
    {% endfor %}

    {% for initializer in container.initializers %}
    {% if debug %}
    // {{initializer}}
    {% endif %}
    {{ initializer.accessibility }}{% if container.isImplementation %} override{% endif %}{% if initializer.@type == "ProtocolMethod" %} required{% endif %} init({{initializer.parameterSignature}}) {
        {% if container.isImplementation %}
        super.init({{initializer.call}})
        {% endif %}
    }
    {% endfor %}

    {% for method in container.methods %}
    {% if debug %}
    // {{method}}
    {% endif %}
    {% for attribute in method.attributes %}
    {{ attribute.text }}
    {% endfor %}
    {{ method.accessibility }}{% if container.isImplementation and method.isOverriding %} override{% endif %} func {{ method.name }}{{ method.genericParameters }}({{ method.parameterSignature }}) {{ method.returnSignature }} {
        {{ method.self|openNestedClosure }}
    return{% if method.isThrowing %} try{% endif %} cuckoo_manager.call{% if method.isThrowing %}{{ method.throwType|capitalize }}{% endif %}("{{method.fullyQualifiedName}}",
            parameters: ({{method.parameterNames}}),
            escapingParameters: ({{method.escapingParameterNames}}),
            superclassCall:
                {% if container.isImplementation %}
                super.{{method.name}}({{method.call}})
                {% else %}
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                {% endif %},
            defaultCall: __defaultImplStub!.{{method.name}}{%if method.isOptional %}!{%endif%}({{method.call}}))
        {{ method.parameters|closeNestedClosure }}
    }
    {% endfor %}

\(Templates.stubbingProxy.indented())

\(Templates.verificationProxy.indented())
}

\(Templates.noImplStub)

{% endfor %}
"""
}
