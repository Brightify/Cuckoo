//
//  NopImplStubTemplate.swift
//  CuckooGeneratorFramework
//
//  Created by Tadeas Kriz on 11/14/17.
//

extension Templates {
    static let noImplStub = """
{{container.accessibility}} class {{ container.name }}Stub{{ container.genericParameters }}: {{ container.name }}{% if container.isImplementation %}{{ container.genericArguments }}{% endif %} {
    {% for property in container.properties %}    
    {% if property.unavailablePlatforms.count > 0 %}
    #if !os({{ property.unavailablePlatforms|join:") && !os(" }})
    {% endif %}
    {% if debug %}
    // {{property}}
    {% endif %}
    {% for attribute in property.attributes %}
    {{ attribute.text }}
    {% endfor %}
    {{ property.accessibility }}{% if container.@type == "ClassDeclaration" %} override{% endif %} var {{ property.name }}: {{ property.type }} {
        get {
            return DefaultValueRegistry.defaultValue(for: ({{property.type|genericSafe}}).self)
        }
        {% ifnot property.isReadOnly %}
        set { }
        {% endif %}
    }
    {% if property.unavailablePlatforms.count > 0 %}
    #endif
    {% endif %}
    {% endfor %}

    {% for initializer in container.initializers %}
    {% if initializer.unavailablePlatforms.count > 0 %}
    #if !os({{ initializer.unavailablePlatforms|join:") && !os(" }})
    {% endif %}
    {{ initializer.accessibility }}{% if container.@type == "ClassDeclaration" %} override{% endif %}{% if initializer.@type == "ProtocolMethod" %} required{%endif%} init({{initializer.parameterSignature}}) {
        {% if container.@type == "ClassDeclaration" %}
        super.init({{initializer.call}})
        {% endif %}
    }
    {% if initializer.unavailablePlatforms.count > 0 %}
    #endif
    {% endif %}
    {% endfor %}

    {% for method in container.methods %}
    {% if method.unavailablePlatforms.count > 0 %}
    #if !os({{ method.unavailablePlatforms|join:") && !os(" }})
    {% endif %}
    {% if debug %}
    // {{method}}
    {% endif %}
    {% for attribute in method.attributes %}
    {{ attribute.text }}
    {% endfor %}
    {{ method.accessibility }}{% if container.@type == "ClassDeclaration" and method.isOverriding %} override{% endif %} func {{ method.name|escapeReservedKeywords }}{{ method.genericParameters }}({{ method.parameterSignature }}) {{ method.returnSignature }} {{ method.whereClause }} {
        return DefaultValueRegistry.defaultValue(for: ({{method.returnType|genericSafe}}).self)
    }
    {% if method.unavailablePlatforms.count > 0 %}
    #endif
    {% endif %}
    {% endfor %}
}
"""
}
