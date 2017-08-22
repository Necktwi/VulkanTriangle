#!/bin/bash

export VULKAN_SDK=/home/gowtham/Downloads/VulkanSDK
${VULKAN_SDK}/1.0.51.0/x86_64/bin/glslangValidator -V shader_base.vert
${VULKAN_SDK}/1.0.51.0/x86_64/bin/glslangValidator -V shader_base.frag
