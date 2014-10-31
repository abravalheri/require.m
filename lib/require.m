function output = require(libname, flag)
% `require`: includes a library into your `loadpath`, following a well structured convention.
%
% # USAGE:
% ```matlab
% require libname -flag
% ```
%
% To know about the possible flags see also addpath
%
% # REQUIREMENTS:
%
% This function assumes that all your custom libs are placed under a "MATLAB" named directory,
% e.g. in windows `%USERPROFILE%\Documents\MATLAB`. Hereafter, this directory will be called
% `MATLAB_LIB`. This file itself needs to be placed under `MATLAB_LIB` folder (with any deep).
% The directory name "MATLAB" is **restricted** and **MUST** be used for `MATLAB_LIB`.
%
% ## Directory Structure Conventions
% ```
% * MATLAB_LIB
% |
% `--* <LIB_NAME>
%    |
%    |-- init.m ( optional initialization file )
%    |          ( automatically loaded with `require` )
%    |
%    |--* lib ( automatically added to path with `require` )
%    |  |
%    |  `- +<LIB_NAME> ( when using namespaces - **RECOMMENDED** )
%    |
%    |-* doc
%    `-* test
% ```
%
% # FALLBACKS
%
% Considering the `LIB_NAME` lib, if no `MATLAB_LIB/LIB_NAME/lib` directory were found,
% the `loadpath` will be augmented with `MATLAB_LIB/LIB_NAME` itself.
%
% # WARNINGS
%
% All scripts and functions in `LIB_NAME/lib` directory become global after the `require` comand.
% OBS: Take care when writing mfiles in `LIB_NAME/lib` directory, this will polute the global scope.
%
% To namespace your functions, please write your files at `LIB_NAME/lib/+LIB_NAME` directory.
%
% In case of nemaspaced libs, even if you call a function in `LIB_NAME/lib` directory from another
% function in the same directory, you need to add the namespace explicitly. For example:
% - Imagine you are writing a function: `LIB_NAME/lib/+LIB_NAME/foo.m`
% - To call the function: `LIB_NAME/lib/+LIB_NAME/bar.m`, you need to write: `LIB_NAME.bar( ... )`
%
% To call namespaced classes, functions and scripts directly you can use the `import LIB_NAME.*`
% command after `require`.
%
% See also `import`.

  %% Finding MATLAB library path
  name = '';
  pathstr = mfilename('fullpath');
  [pathstr, name] = fileparts(pathstr);

  while ~strcmpi(name, 'MATLAB')
    [pathstr, name] = fileparts(pathstr);
  end

  if length(pathstr) < 3
    error('Unknow MATLAB library path');
  end

  lib_path = fullfile(pathstr, 'MATLAB');

  %% Default library structure
  lib_root    = fullfile(lib_path, libname);
  lib_folder  = fullfile(lib_root, 'lib');
  doc_folder  = fullfile(lib_root, 'doc');

  if exist(lib_root, 'dir') == 0
    error(['No such lib: ' libname '. Make sure folder ', lib_root, ' exists.']);
  end

  if nargin < 2
    flag = '-end';
  end

  if exist(lib_folder, 'dir')
    already = strfind(path, lib_folder);
    if (isscalar(already) && already) || (ischar(already) && empty(already))
      if nargout > 0
        output = [libname ': already loaded'];
      end
      disp_doc(true);
      return
    end
    addpath_with_flag(lib_folder);

    init_file = fullfile(lib_root, 'init.m');
    if exist(init_file, 'file')
      run(init_file);
    end
  else
    already = strfind(path, lib_root);
    if (isscalar(already) && already) || (ischar(already) && empty(already))
      if nargout > 0
        output = [libname ': already loaded'];
      end
      disp_doc(true);
      return
    end
    addpath_with_flag(lib_root);
  end

  if nargout > 0
    output = [libname ': loaded'];
  end

  disp_doc(false);

  %% Auxiliar Functions
  function addpath_with_flag(dir)
    if strcmpi(flag,'-begin') || strcmpi(flag,'-end') || strcmpi(flag,'-frozen')
      addpath(dir, flag);
    else
      addpath(dir, '-end');
    end
  end

  function disp_doc(already)
    if strcmpi(flag,'-doc')
      if already
        disp([libname ': already loaded']);
      else
        disp([libname ': loaded']);
      end

      if exist(doc_folder, 'dir') && exist(fullfile(doc_folder, 'README'), 'file')
        fid = fopen(fullfile(doc_folder, 'README'));
        tline = fgets(fid);
        while ischar(tline)
          disp(tline)
          tline = fgets(fid);
        end

        fclose(fid);
      end
    end
  end
end
