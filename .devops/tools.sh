#!/bin/bash
set -e

# Read the first argument into a variable
arg1="$1"

# Shift the arguments to remove the first one
shift

# Join the remaining arguments into a single string
arg2="$@"

if [[ $arg1 == '--convert' || $arg1 == '-c' ]]; then
    python3 ./convert-pth-to-ggml.py $arg2
elif [[ $arg1 == '--quantize' || $arg1 == '-q' ]]; then
    ./quantize $arg2
elif [[ $arg1 == '--run' || $arg1 == '-r' ]]; then
    ./main $arg2
elif [[ $arg1 == '--download' || $arg1 == '-d' ]]; then
    python3 ./download-pth.py $arg2
elif [[ $arg1 == '--all-in-one' || $arg1 == '-a' ]]; then
    echo "Downloading model '$2' in '$1' ..."
    bash ./download_models.sh

    python3 ./download-pth.py "$1" "$2"
    echo "Converting PTH to GGML..."

    modelDir="$1/$2"
    echo "Processing model '${modelDir}'..."
    modelFile="${modelDir}/ggml-model-f16.bin"
    echo "$modelFile"
    if [ -f "$modelFile" ]; then
        echo "Skip model conversion, it already exists: ${modelFile}"
    else
        echo "Converting PTH to GGML: $2 into ${modelFile}..."
        python3 convert-pth-to-ggml.py "$1/$2/" 1
    fi

    modelFile="${modelDir}/ggml-model-q4_0.bin"
    if [ -f "$modelFile" ]; then
        echo "Skip model quantization, it already exists: ${modelFile}"
    else
        echo "Converting f16 to q4_0: $i into ${modelFile}..."
        python3 quantize.py $2
    fi
else
    echo "Unknown command: $arg1"
    echo "Available commands: "
    echo "  --run (-r): Run a model previously converted into ggml"
    echo "              ex: -m /models/7B/ggml-model-q4_0.bin -p \"Building a website can be done in 10 simple steps:\" -n 512"
    echo "  --convert (-c): Convert a llama model into ggml"
    echo "              ex: \"/models/7B/\" 1"
    echo "  --quantize (-q): Optimize with quantization process ggml"
    echo "              ex: \"/models/7B/ggml-model-f16.bin\" \"/models/7B/ggml-model-q4_0.bin\" 2"
    echo "  --download (-d): Download original llama model from CDN: https://agi.gpt4.org/llama/"
    echo "              ex: \"/models/\" 7B"
    echo "  --all-in-one (-a): Execute --download, --convert & --quantize"
    echo "              ex: \"/models/\" 7B"
fi
