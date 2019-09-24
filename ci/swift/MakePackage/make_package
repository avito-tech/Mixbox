#!/usr/bin/env python3

import jinja2
import os
import re

swift_ci_root = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")

def generate():
    generated_string = render(
        dict_to_render=get_dict_to_render()
    )
    
    with open(os.path.join(swift_ci_root, "Package.swift"), 'w') as f:
        f.write(generated_string)

def get_dict_to_render():
    targets = get_targets()
    
    dict_to_render = {
        "targets": targets,
        "executables": [target for target in targets if target.is_executable]
    }
    
    return dict_to_render

def render(dict_to_render):
    script_dir = os.path.dirname(os.path.abspath(__file__))
    template_name = "Package.swift.template"

    loader = jinja2.FileSystemLoader(script_dir)
    jinja_environment = jinja2.Environment(loader=loader)
    template = jinja_environment.get_template(template_name)

    return template.render(dict_to_render)

def get_targets():
    sources = os.path.join(swift_ci_root, "Sources")
    directory_names = [
        file_name
        for file_name in os.listdir(sources) 
            if os.path.isdir(os.path.join(sources, file_name))
    ]
    
    external_library_name_by_module_name = {
        'Dip': 'Dip',
        'Models': 'EmceeInterfaces',
        'Alamofire': 'Alamofire'
    }
    
    library_name_by_module_name = external_library_name_by_module_name.copy()
    
    for directory_name in directory_names:
        library_name_by_module_name[directory_name] = directory_name
    
    return [
        get_target(
            target_name=directory_name,
            directory=os.path.join(sources, directory_name),
            library_name_by_module_name=library_name_by_module_name
        )
        for directory_name in directory_names
    ]

def get_target(target_name, directory, library_name_by_module_name):
    imported_modules = []
    
    for root, subdirs, files in os.walk(directory):
        for file_name in files:
            if file_name.endswith(".swift"):
                path = os.path.join(root, file_name)
            
                with open(path, 'r') as f:
                    contents = f.read()
                    file_dependencies = re.findall(r'^import ([a-zA-Z0-9_]+)$', contents, flags=re.M)
                    
                    imported_modules.extend(file_dependencies)
               
    dependencies = list(sorted(set([
        library_name_by_module_name[module_name]
        for module_name in imported_modules
            if module_name in library_name_by_module_name
    ])))
        
    return Target(
        name=target_name,
        dependencies=dependencies,
        type="testTarget" if target_name.endswith("Tests") else "target",
        is_executable=target_name.endswith("Build")
    )

class Target:
    def __init__(self, name, dependencies, type, is_executable):
        self.name = name
        self.dependencies = dependencies
        self.type = type
        self.is_executable = is_executable
        
    def __repr__(self):
        return f'Target(name={self.name}, dependencies={self.dependencies}, is_executable={self.is_executable})'
        
generate()