function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 12-Jan-2013 22:35:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

disp('GUI has been successfully initiated. Displaying GUI now...')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Compile these once on your machine by uncommenting

% mex -O resize.cc
% mex -O reduce.cc
% mex -O shiftdt.cc
% mex -O features.cc
% mex -O fconv.cc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global TRAINING_SET_SIZE posemap model ;

TRAINING_SET_SIZE = 110;    %number of lines in the "TrainingSet.txt" file
% handleSelectedImage=0;      %handle of test-image chosen in option 2


%%%%%% Load model
% Pre-trained model with 146 parts. Works best for faces larger than 80*80
load face_p146_small.mat
disp('Model for face-detection loaded.');
% % Pre-trained model with 99 parts. Works best for faces larger than 150*150
% load face_p99.mat

% % Pre-trained model with 1050 parts. Give best performance on localization, but very slow
% load multipie_independent.mat

% 5 levels for each octave
model.interval = 5;
% set up the threshold
model.thresh = min(-0.65, model.thresh);

% define the mapping from view-specific mixture id to viewpoint
if length(model.components)==13 
    posemap = 90:-15:-90;
elseif length(model.components)==18
    posemap = [90:-15:15 0 0 0 0 0 0 -15:-15:-90];
else
    error('Can not recognize this model');
end
disp('Please use the GUI for proceeding.');

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radio_training.
function radio_training_Callback(hObject, eventdata, handles)
% hObject    handle to radio_training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_training


% --- Executes on button press in radio_diskimg.
function radio_diskimg_Callback(hObject, eventdata, handles)
% hObject    handle to radio_diskimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_diskimg


% --- Executes on button press in radio_camimg.
function radio_camimg_Callback(hObject, eventdata, handles)
% hObject    handle to radio_camimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_camimg


% --- Executes on button press in radio_recog.
function radio_recog_Callback(hObject, eventdata, handles)
% hObject    handle to radio_recog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_recog

%==========================================================================
% --- Executes on button press in button_exec.
function button_exec_Callback(hObject, eventdata, handles)
% hObject    handle to button_exec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TRAINING_SET_SIZE posemap model ;


if(get(handles.radio_training,'Value')==1)
    % Perform Singular Value Decomposition to obtain feature vectors
    % of the training set
        set(handles.text_result,'String','Reading and processing Training Set.This may take half an hour. Please be patient...');
        drawnow;
        tic;
        [U]= svdDecomp('D:\Swapnil\src\Project\CFS.txt', TRAINING_SET_SIZE,posemap,model);
        time = toc
        save('Training Set -- Singular Vector Matrix.mat','U');
        set(handles.text_result,'String',['Training Set processing was completed in ' num2str(time/60) ' minutes. The system is ready for recognizing expressions.']);
        drawnow;
end
        
if(get(handles.radio_diskimg,'Value')==1)
    % Provide a dialogbox for selecting a jpg face image
        cla(handles.axis_input);
        cla(handles.axis_features);
        set(handles.text_result,'String','Waiting for an image to be selected...');
        drawnow;
        [filename,pathname]=uigetfile( '*.jpg' , 'Select a test image');
        selectedFile = cat(2,pathname,filename);
        if isequal(filename,0);
            disp('ACTION CANCELLED');
            h = waitbar(0,'PLEASE WAIT...');
            for i=1:2450, 
                waitbar(i/100)
            end
            close(h)
            
        else
            imshow(selectedFile,'Parent',handles.axis_input);
            face_image = imread(selectedFile);
            set(handles.text_result,'String','Please wait while selected image is being processed for facial features...');
            drawnow;
            [eye_region_img  mouth_region_img] = get_regions(face_image, model, posemap);
            face_image = cat(1,eye_region_img,mouth_region_img);
            imshow(face_image,'Parent',handles.axis_features);
            [resizedInput,~,~] = jacobi_svd(double(face_image));
            resizedInput = reshape(resizedInput,65536,1);
            save('Input Image -- Feature Vector.mat','resizedInput');
            set(handles.text_result,'String','Image Processing complete.');
            drawnow;
        end
end

if(get(handles.radio_camimg,'Value')==1)
    % Take a snapshot from available video device
        cla(handles.axis_input);
        cla(handles.axis_features);
        vid = videoinput('winvideo', 1);
        set(vid, 'ReturnedColorSpace', 'RGB');
        im=0;
        for i=5:-1:1
            im = getsnapshot(vid);
            imshow(im,'Parent',handles.axis_input);
            set(handles.text_result,'String',['Capturing image in ' num2str(i)]);
        end
        set(handles.text_result,'String','Image has been captured. Please wait until it is processed..');
        drawnow;
        %imshow(im);title('Selected image:');
            face_image = im;
            [eye_region_img  mouth_region_img] = get_regions(face_image, model, posemap);
            face_image = cat(1,eye_region_img,mouth_region_img);
            imshow(face_image,'Parent',handles.axis_features);
            [resizedInput,~,~] = jacobi_svd(double(face_image));
            resizedInput = reshape(resizedInput,65536,1);
            save('Input Image -- Feature Vector.mat','resizedInput');
            set(handles.text_result,'String','Image Processing complete.');
            drawnow;
            
end

if(get(handles.radio_recog,'Value')==1)
       % Classify the selected image's facial expression
        
        load('Training Set -- Singular Vector Matrix.mat','U');
        load('Input Image -- Feature Vector.mat','resizedInput');
        set(handles.text_result,'String','Analyzing feature vectors. Please wait...');
        drawnow;
        [indx, min_distance] = closest(resizedInput, U);
        if indx >=1&&indx<=22
            Expression = 'Angry';
            else if indx >=23&&indx<=44
                Expression = 'Happy';
                else if indx >=45&&indx<=66
                    Expression = 'Surprised';
                        else if indx >=67&&indx<=88
                            Expression = 'Neutral';
                                else if indx >=89&&indx<=110
                                    Expression = 'Sad';
                                    else
                                        Expression = 'Unknown';
                                    end
                            end
                      end
                end
        end
        set(handles.text_result,'String',['The expression is ' Expression ' with Mean Squared Error ' num2str(min_distance)]);
        drawnow;
        %disp(['The expression is ', Expression]);
        %disp(['The Mean Squared Error was ',  num2str(min_distance)]);
        %disp(' ');
end

if(get(handles.radio_clear,'Value')==1)

       cla(handles.axis_input);
       cla(handles.axis_features);
       set(handles.text_result,'string','');
end

if(get(handles.radio_quit,'Value')==1)
       uiwait(msgbox('This program will now exit.','EXITING...','modal'));
        clc
        clear all
        close all
        return
end
        
% --- Executes on mouse press over axes background.
function axis_input_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axis_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
