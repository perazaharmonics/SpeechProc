function [varargout] = wavefilter(wname, type)
% WAVEFILTER - Generate wavelet filter coefficients for different wavelet types.
%
% Syntax:
%   [ld, hd, lr, hr] = wavefilter(wname)
%   OR
%   [lr, hr] = wavefilter(wname, 'reconstruction')
%
% Inputs:
%   - wname: The name of the wavelet (e.g., 'db4', 'bior6.8', 'jpeg9.7').
%   - type (optional): Specify 'decomposition' or 'reconstruction'. Default is 'decomposition'.
%
% Outputs:
%   - ld, hd: Low-pass and high-pass decomposition filter coefficients.
%   - lr, hr: Low-pass and high-pass reconstruction filter coefficients.
%
% Example Usage:
%   [ld, hd, lr, hr] = wavefilter('db4');
%   OR
%   [lr, hr] = wavefilter('db4', 'reconstruction');

% Check input and output arguments
error(nargchk(1, 2, nargin));

if (nargin == 1 && nargout ~= 4) || (nargin == 2 && nargout ~= 2)
    error('Invalid number of input arguments.');
end

if nargin == 1 && ~ischar(wname)
    error('WNAME must be a string.');
end

if nargin == 2 && ~ischar(type)
    error('TYPE must be a string. ');
end

% Create filter for the selected wavelet
switch lower(wname)
    case {'haar', 'db1'}
        ld = [1 1] / sqrt(2);   hd = [-1 1] / sqrt(2);
        lr = ld;                hd = -hd;

    case 'db4'
        ld = [-1.05974017899728e-002 3.288301166698295e-002...
              3.0841381835986973e-002 -1.870348117188811e-001 ...
               -2.798376941698385e-002 6.308807679295004e-001 ...
                7.14465705525415e-001 2.3037781330885522e-001];
        t = (0:7);
        hd = ld;    hd(end:-1:1) = cos(pi*t) .* ld;
        lr = ld;    lr(end:-1:1) = ld;
        hr = cos(pi*t) .* ld;

    case 'bior6.8'
        ld = [0 1.9098821236481291e-003 -1.914286129088767e-003...
             -1.6990636398670234e-002 1.193456527972923e-002...
             4.973290349573646e-002 -7.726317316720414e-002 ...
             -9.405920349573646e-002 4.207962846098268e-002...
             8.259229974584023e-001 4.207962846098268e-002...
             -9.405920349573646e-002 4.207962846098268e-002...
             4.973290349573646e-002 -1.914286129088767e-003...
             1.9088312736481291e-003];
        hd = [0 0 0 1.442628250562444e-002 -1.4467504897901e-002...
            -7.87220010626882e-002 4.03679703033992e-002...
            4.178491091502746e-001 -7.589077294536543e-001 ...
            4.178491091502746e-001 4.03679703033992e-002...
            1.442628250562444e-002 0   0   0  0];
        t = (0:17);
        lr = cos(pi*(t+1)) .* hd;
        hr = cos(pi*t) .* ld;

    case 'jpeg9.7'
        ld = [0 0.02674875741080976 -0.01686422844287495 ...
            -0.07822326652898785    0.2668641184428723 ... 
             0.6029490182363579     0.2668641184428723 ...
             -0.07822326652898785   -0.01686422844287495 ...
             0.02674875741080976];
        hd= [0 -0.9127176311424948  0.05754352622849957 ... 
            0.5912717631142470      -1.115087052456944 ...
            0.5912717631142470      0.05754352622849957 ...
            -0.9127176311424948     0     0];
        t=(0:9);
        lr = cos(pi * (t + 1)) .* hd;
        hr = cos(pi * t) .* ld;

    otherwise
        error('Unrecognizable wavelet name (WNAME).');
end

% Output the requested filter
if (nargin == 1)
    varargout(1:4) = {ld, hd, lr, hr};
else
    switch lower(type(1))
        case 'd'
            varargout = {ld, hd};
        case 'r'
            varargout = {lr, hr};
        otherwise
            error("Unrecognizeable filter TYPE. ")
    end
end
