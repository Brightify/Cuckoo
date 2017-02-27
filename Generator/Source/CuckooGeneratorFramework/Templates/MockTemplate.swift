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
class {{ container.mockName }}: {{ container.name }}, {% if container.isImplementation %}Cuckoo.ClassMock{%else%}Cuckoo.ProtocolMock{% endif %} {
    typealias MocksType = {{ container.name }}
    typealias Stubbing = __StubbingProxy_{{ container.name }}
    typealias Verification = __VerificationProxy_{{ container.name }}
    let cuckoo_manager = Cuckoo.MockManager(hasParent: {{ container.isImplementation }})

    {% for property in container.properties %}
    // {{property}}
    {{ property.accessibility }}{% if container.isImplementation %} override{% endif %} var {{ property.name }}: {{ property.type }} {
        get {
            {% if container.isImplementation %}
            return cuckoo_manager.getter("{{ property.name }}", superclassCall: super.{{ property.name }})
            {% else %}
            return cuckoo_manager.getter("{{ property.name }}", superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            {% endif %}
        }
        {% ifnot property.isReadOnly %}
        set {
            {% if container.isImplementation %}
            cuckoo_manager.setter("{{ property.name }}", value: newValue, superclassCall: super.{{ property.name }} = newValue)
            {% else %}
            cuckoo_manager.setter("{{ property.name }}", value: newValue, superclassCall: Cuckoo.MockManager.crashOnProtocolSuperclassCall())
            {% endif %}
        }
        {% endif %}
    }
    {% endfor %}

    {% for initializer in container.initializers %}
    // {{initializer}}
    {{ initializer.accessibility }}{% if container.isImplementation %} override{% endif %}{% if initializer.@type == "ProtocolMethod" %} required{%endif%} init({{initializer.parameterSignature}}) {
        {% if container.isImplementation %}
        super.init({{initializer.call}})
        {% endif %}
    }
    {% endfor %}

    {% for method in container.methods %}
    // {{method}}
    {{ method.accessibility }}{% if container.isImplementation and method.isOverriding %} override{% endif %} func {{ method.name }}({{ method.parameterSignature }}) {{ method.returnSignature }} {
        {{ method.parameters|openNestedClosure:method.isThrowing }}
            return{% if method.isThrowing %} try{% endif %} cuckoo_manager.call{% if method.isThrowing %}Throws{% endif %}("{{method.fullyQualifiedName}}",
                parameters: ({{method.parameterNames}}),
                superclassCall:
                    {% if container.isImplementation %}
                    super.{{method.name}}({{method.call}})
                    {% else %}
                    Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                    {% endif %})
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
