#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")")"

IREE_BUILD_DIR=$SCRIPT_DIR/build
IREE_BUILD_COMPILER_DIR=$IREE_BUILD_DIR/compiler
IREE_BUILD_COMPILER_BIN_DIR=$IREE_BUILD_COMPILER_DIR/install/bin
IREE_BUILD_COMPILER_LIB_DIR=$IREE_BUILD_COMPILER_DIR/install/lib

export DYLD_LIBRARY_PATH=$IREE_BUILD_COMPILER_LIB_DIR:$DYLD_LIBRARY_PATH
echo "Set DYLD_LIBRARY_PATH to $DYLD_LIBRARY_PATH"

export PATH=$IREE_BUILD_COMPILER_BIN_DIR:$PATH
echo "Set PATH to $PATH"

if iree-compile -h > /dev/null; then
    echo "iree-compile works"
else
    echo "error: iree-compile does not work"
    exit 2
fi

IREE_BUILD_COMPILER_PYTHON_BINDING_COMPILER=$IREE_BUILD_COMPILER_DIR/compiler/bindings/python
IREE_BUILD_COMPILER_PYTHON_BINDING_RUNTIME=$IREE_BUILD_COMPILER_DIR/runtime/bindings/python
export PYTHONPATH=$IREE_BUILD_COMPILER_PYTHON_BINDING_COMPILER:$IREE_BUILD_COMPILER_PYTHON_BINDING_RUNTIME:$PYTHONPATH
echo "Set PYTHONPATH to $PYTHONPATH"

IMPORT_TEST="import iree.compiler, iree.runtime"
if python3 -c "$IMPORT_TEST"; then
    echo "$IMPORT_TEST works"
else
    echo "error: $IMPORT_TEST does not work"
    exit 2
fi
