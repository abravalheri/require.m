# require.m

Structured tools to include a library into MATLAB loadpath

## Usage

```matlab
require libname -flag
```
To know about the possible flags see also addpath

## Requirements

This function assumes that all your custom libs are placed under a _"MATLAB"_ named directory,
e.g. in windows `%USERPROFILE%\Documents\MATLAB`. Hereafter, this directory will be called
`MATLAB_LIB`.

This file itself needs to be placed under `MATLAB_LIB` folder (with any deep).
The directory name _"MATLAB"_ is **restricted** and **MUST** be used for `MATLAB_LIB`.

### Directory Structure Conventions

```
* MATLAB_LIB
|
`--* <LIB_NAME>
   |
   |-- init.m ( optional initialization file )
   |          ( automatically loaded with `require` )
   |
   |--* lib ( automatically added to path with `require` )
   |  |
   |  `- +<LIB_NAME> ( when using namespaces - **RECOMMENDED** )
   |
   |-* doc
   `-* test
```

## Fallbacks

Considering the `LIB_NAME` lib, if no `MATLAB_LIB/LIB_NAME/lib` directory were found,
the `loadpath` will be augmented with `MATLAB_LIB/LIB_NAME` itself.

## Warnings

All scripts and functions in `LIB_NAME/lib` directory become global after the `require` comand.
So, take care when writing mfiles in `LIB_NAME/lib` directory, this will polute the global scope

To namespace your functions, please write your files at `LIB_NAME/lib/+LIB_NAME` directory.

In case of nemaspaced libs, even if you call a function in `LIB_NAME/lib` directory from another
function in the same directory, you need to add the namespace explicitly. For example:
- Imagine you are writing a function: `LIB_NAME/lib/+LIB_NAME/foo.m`
- To call the function: `LIB_NAME/lib/+LIB_NAME/bar.m`, you need to write: `LIB_NAME.bar( ... )`
To call namespaced classes, functions and scripts directly you can use the `import LIB_NAME.*`
command after `require`.
