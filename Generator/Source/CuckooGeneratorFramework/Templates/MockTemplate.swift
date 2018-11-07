//
//  MockTemplate.swift
//  CuckooGeneratorFramework
//
//  Created by Tadeas Kriz on 11/14/17.
//

import Foundation

extension Templates {
    static let mock = """
{% for container in containers %}
{{ container.accessibility }} class {{ container.mockName }}: {{ container.name }}, {% if container.isImplementation %}Cuckoo.ClassMock{% else %}Cuckoo.ProtocolMock{% endif %} {
    typealias MocksType = {{ container.name }}
    typealias Stubbing = __StubbingProxy_{{ container.name }}
    typealias Verification = __VerificationProxy_{{ container.name }}

    private var __defaultImplStub: {{ container.name }}?

    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: {{ container.isImplementation }})

    func enableDefaultImplementation(_ stub: {{ container.name }}) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }

    {% for property in container.properties %}
    {% if debug %}
    // {{property}}
    {% endif %}
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
    {{ method.accessibility }}{% if container.isImplementation and method.isOverriding %} override{% endif %} func {{ method.name }}({{ method.parameterSignature }}) {{ method.returnSignature }} {
        {{ method.parameters|openNestedClosure:method.isThrowing }}
            return{% if method.isThrowing %} try{% endif %} cuckoo_manager.call{% if method.isThrowing %}Throws{% endif %}("{{method.fullyQualifiedName}}",
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
