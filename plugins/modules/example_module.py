#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright: (c) 2023, Your Name <yourname@proalpha.com>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

# The DOCUMENTATION variable provides metadata about the module. It is formatted in YAML.
# Ansible uses this for various purposes such as generating docs, ansible-doc command, and the Ansible Galaxy website.
DOCUMENTATION = r'''
---
module: example_module
short_description: Description of what the module does
description:
- Detailed description of what the module does. This should be a list of strings with more detailed explanation about the functionality of the module.
options:
  path:
    description:
    - The path where the file should be created. This will be used as the target for file operations in the associated PowerShell module.
    type: str
    required: yes
  content:
    description:
    - The content that should be written to the file. This will be used in the associated PowerShell module to define what to write in the file.
    type: str
    required: yes
author:
- Your Name 
'''

# The EXAMPLES variable is where you can provide examples of how to use the module.
# The string should be formatted in YAML, which will then be parsed by Ansible and shown to the user.
EXAMPLES = r'''
- name: Use example_module to write content to a file
  example_module:
    path: C:\path\to\file.txt
    content: "Hello, World!"
'''

# The RETURN variable is a string with a valid YAML object that provides a detailed description of the returned values from the module.
# Ansible includes this information in the documentation and uses it for other purposes.
RETURN = r'''
message:
    description: Message indicating whether the file was written successfully. This will be returned from the PowerShell module upon success or failure.
    returned: always
    type: str
    sample: File written successfully.
'''
