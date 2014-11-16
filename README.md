# require.m

Structured tools to include a library into MATLAB loadpath

## Usage

```matlab
require libname -flag
```
To know about the possible flags see also addpath

## Installing

It's just as simple as downloading the coding and putting the folder `lib` of this project in the path.

Please consider using `addpath` and `savepath` functions and notice that the parent folder (where you will put your download) should be named `MATLAB` as described in the following section.

## Requirements

This function assumes that all your custom libs are placed under a _"MATLAB"_ named directory,
e.g. in windows `%USERPROFILE%\Documents\MATLAB`. Hereafter, this directory will be called
`MATLAB_LIB`.

The file `require.m` itself needs to be placed under `MATLAB_LIB` folder (with any deep).
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

## Stuff Doesn't Work

This work was tested and I think it's stable, but any feedback you can give me on this would be gratefully received (see section **Reporting a Bug** at [CONTRIBUTING](CONTRIBUTING.md)). Please, make yourself comfortable in contributing :blush:.

## Contributing

I love contributions! Please have a look at [CONTRIBUTING](CONTRIBUTING.md) and consider help me with the bellow stuff:

### Well-know list of TODOs

- Automatize the installation process
- Make `require` return the original path for further restoring (as `addpath`)
- Improve integration with package manager.
   - The idea is to search for a `require.lock` file (analogous to [`Gemfile.lock`](http://richonrails.com/articles/how-does-the-gemfile-lock-file-work)), ascending in the directory hierarchy (with a fallback file under `MATLAB_LIB`), in order to determine the version and location for each library.
   - Add support for jar files (using `javaaddpath`, ` javaclasspath`), defined it `require.lock`
   - This should eliminate the need for the dangerous `init.m` file

## MATLAB Package Manager

In the future, this library should work better when used together with a package manager... Each distributed library should define its dependencies in a file like [`package.json`](https://www.npmjs.org/doc/files/package.json.html) or [`Gemfile`](http://bundler.io/gemfile.html), the package manager should read this file before installing the library, solving the dependency hell and producing a `require.lock` file, that should be consumed by `require` command.
