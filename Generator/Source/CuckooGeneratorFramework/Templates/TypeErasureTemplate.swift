//
//  TypeErasureTemplate.swift
//  CuckooGeneratorFramework
//
//  Created by Matyáš Kříž on 26/11/2018.
//

import Foundation

extension Templates {
    static let typeErasure = """
    {{ container.accessibility }} class \(typeErasureClassName){{ container.genericParameters }}: {{ container.name }} {
        private let reference: Any

        {% for property in container.properties %}private let _getter_storage$${{ property.name }}: () -> {{ property.type }}{% if not property.isReadOnly %}
        private let _setter_storage$${{ property.name }}: ({{ property.type }}) -> Void{% endif %}
        {{ container.accessibility }} var {{ property.name }}: {{ property.type }} {
            get { return _getter_storage$${{ property.name }}() }{% if not property.isReadOnly %}
            set { _setter_storage$${{ property.name }}(newValue) }{% endif %}
        }

        {% endfor %}
        {# For developers: The `keeping reference: Any?` is necessary because when called from the `enableDefaultImplementation(stub:)` method
        instead of `enableDefaultImplementation(mutating:)`, we need to prevent the struct getting deallocated. #}
        init<\(staticGenericParameter): {{ container.name }}>(from defaultImpl: UnsafeMutablePointer<\(staticGenericParameter)>, keeping reference: @escaping @autoclosure () -> Any?) where {{ container.genericProtocolIdentity }} {
            self.reference = reference

            {% for property in container.properties %}_getter_storage$${{ property.name }} = { defaultImpl.pointee.{{ property.name }} }
            {% if not property.isReadOnly %}_setter_storage$${{ property.name }} = { defaultImpl.pointee.{{ property.name }} = $0 }{% endif %}
            {% endfor %}
            {% for method in container.methods %}_storage${{ forloop.counter }}${{ method.name }} = defaultImpl.pointee.{{ method.name }}
            {% endfor %}
        }
        {% if container.initializers %}
        /// MARK:- ignored required initializers{% endif %}
        {% for initializer in container.initializers %}{{ container.accessibility }} required init({{ initializer.parameterSignature }}) {
            fatalError("`DefaultImplCaller` class is only used for calling default implementation and can't be initialized on its own.")
        }
        {% endfor %}

        {% for method in container.methods %}
        private let _storage${{ forloop.counter }}${{ method.name }}: ({{ method.inputTypes }}) -> {{ method.returnType }}
        {{ container.accessibility }} func {{ method.name|escapeReservedKeywords }}({{ method.parameterSignature }}) {{ method.returnSignature }} {
            return _storage${{ forloop.counter }}${{ method.name }}({{ method.parameterNames }})
        }
        {% endfor %}
    }
    """
}
