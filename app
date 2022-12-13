classdef EqualizerApp_ShaposnikA < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure        matlab.ui.Figure
        Label           matlab.ui.control.Label
        gain1           matlab.ui.control.Slider
        Slider_13Label  matlab.ui.control.Label
        gain9           matlab.ui.control.Slider
        Slider_12Label  matlab.ui.control.Label
        gain10          matlab.ui.control.Slider
        Slider_11Label  matlab.ui.control.Label
        gain8           matlab.ui.control.Slider
        Slider_10Label  matlab.ui.control.Label
        gain7           matlab.ui.control.Slider
        Slider_9Label   matlab.ui.control.Label
        gain6           matlab.ui.control.Slider
        Slider_8Label   matlab.ui.control.Label
        gain5           matlab.ui.control.Slider
        Slider_7Label   matlab.ui.control.Label
        gain4           matlab.ui.control.Slider
        Slider_6Label   matlab.ui.control.Label
        gain3           matlab.ui.control.Slider
        Slider_5Label   matlab.ui.control.Label
        gain2           matlab.ui.control.Slider
        Slider_4Label   matlab.ui.control.Label
        StopButton      matlab.ui.control.Button
        PauseButton     matlab.ui.control.Button
        PlayButton      matlab.ui.control.Button
        LoadButton      matlab.ui.control.Button
        UIAxes2         matlab.ui.control.UIAxes
        UIAxes          matlab.ui.control.UIAxes
    end

    
    properties (Access = public)
        equalizer = Equalizer(64, 44100)
        deviceWriter = audioDeviceWriter('SampleRate', 44100)
        fileReader = dsp.AudioFileReader()
    end
    
    properties (Access = protected)
        filename
        stopFlag = false
    end

    methods (Access = private)

        function PlotFreqResponce(app) 
            [Hdb, w] = GetFreqResponce(app.equalizer)
            for i =1:10
                plot(app.UIAxes2, w(i, :), Hdb(i,:))
            end
        end
    end
    

    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: gain1
        function gain1ValueChanged(app, event)
            app.equalizer.gain(1) = app.gain1.Value;
            app.PlotFreqResponce();
            drawnow
            
        end

        % Value changed function: gain2
        function gain2ValueChanged(app, event)
            app.equalizer.gain(2) = app.gain2.Value;
            app.PlotFreqResponce();
            drawnow
        end

        % Value changed function: gain3
        function gain3ValueChanged(app, event)
            app.equalizer.gain(3) = app.gain3.Value;
            app.PlotFreqResponce();
            drawnow
        end

        % Value changed function: gain4
        function gain4ValueChanged(app, event)
            app.equalizer.gain(4) = app.gain4.Value;
            app.PlotFreqResponce();
            drawnow
        end

        % Value changed function: gain5
        function gain5ValueChanged(app, event)
            app.equalizer.gain(5) = app.gain5.Value;
            app.PlotFreqResponce();
            drawnow
        end

        % Value changed function: gain6
        function gain6ValueChanged(app, event)
            app.equalizer.gain(6) = app.gain6.Value;
            app.PlotFreqResponce();
            drawnow
        end

        % Value changed function: gain7
        function gain7ValueChanged(app, event)
            app.equalizer.gain(7) = app.gain7.Value;
            app.PlotFreqResponce();
            drawnow
        end

        % Value changed function: gain8
        function gain8ValueChanged(app, event)
            app.equalizer.gain(8) = app.gain8.Value;
            app.PlotFreqResponce();
            drawnow
        end

        % Value changed function: gain9
        function gain9ValueChanged(app, event)
           app.equalizer.gain(9) = app.gain9.Value;
            app.PlotFreqResponce();
            drawnow
        end

        % Value changed function: gain10
        function gain10ValueChanged(app, event)
            app.equalizer.gain(10) = app.gain10.Value;
            app.PlotFreqResponce();
            drawnow
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
            app.filename = uigetfile('*.mp3');
            app.Label.Text = app.filename;
            app.fileReader = dsp.AudioFileReader(app.filename, 'PlayCount', inf, 'SamplesPerFrame', 4096);
        end

        % Button pushed function: PlayButton
        function PlayButtonPushed(app, event)
            while ~isDone(app.fileReader)
                 audioData = app.fileReader();
                 audioDataF = app.equalizer.filtering(audioData)
                 app.deviceWriter(audioDataF)
            end

        end

        % Button pushed function: PauseButton
        function PauseButtonPushed(app, event)
            app.stopFlag = true;

        end

        % Button pushed function: StopButton
        function StopButtonPushed(app, event)
            app.stopFlag = false;

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.8667 0.7333 0.949];
            app.UIFigure.Position = [100 100 1024 768];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Spectrum')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [87 163 262 165];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'FreqResponce')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [663 162 266 166];

            % Create LoadButton
            app.LoadButton = uibutton(app.UIFigure, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [82 365 100 23];
            app.LoadButton.Text = 'Load';

            % Create PlayButton
            app.PlayButton = uibutton(app.UIFigure, 'push');
            app.PlayButton.ButtonPushedFcn = createCallbackFcn(app, @PlayButtonPushed, true);
            app.PlayButton.Position = [315 365 100 23];
            app.PlayButton.Text = 'Play';

            % Create PauseButton
            app.PauseButton = uibutton(app.UIFigure, 'push');
            app.PauseButton.ButtonPushedFcn = createCallbackFcn(app, @PauseButtonPushed, true);
            app.PauseButton.Position = [582 365 100 23];
            app.PauseButton.Text = 'Pause';

            % Create StopButton
            app.StopButton = uibutton(app.UIFigure, 'push');
            app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
            app.StopButton.Position = [840 365 100 23];
            app.StopButton.Text = 'Stop';

            % Create Slider_4Label
            app.Slider_4Label = uilabel(app.UIFigure);
            app.Slider_4Label.HorizontalAlignment = 'right';
            app.Slider_4Label.Position = [181 436 36 22];
            app.Slider_4Label.Text = 'Slider';

            % Create gain2
            app.gain2 = uislider(app.UIFigure);
            app.gain2.Limits = [-10 10];
            app.gain2.Orientation = 'vertical';
            app.gain2.ValueChangedFcn = createCallbackFcn(app, @gain2ValueChanged, true);
            app.gain2.Position = [186 466 3 221];

            % Create Slider_5Label
            app.Slider_5Label = uilabel(app.UIFigure);
            app.Slider_5Label.HorizontalAlignment = 'right';
            app.Slider_5Label.Position = [257 430 36 22];
            app.Slider_5Label.Text = 'Slider';

            % Create gain3
            app.gain3 = uislider(app.UIFigure);
            app.gain3.Limits = [-10 10];
            app.gain3.Orientation = 'vertical';
            app.gain3.ValueChangedFcn = createCallbackFcn(app, @gain3ValueChanged, true);
            app.gain3.Position = [262 460 3 221];

            % Create Slider_6Label
            app.Slider_6Label = uilabel(app.UIFigure);
            app.Slider_6Label.HorizontalAlignment = 'right';
            app.Slider_6Label.Position = [333 436 36 22];
            app.Slider_6Label.Text = 'Slider';

            % Create gain4
            app.gain4 = uislider(app.UIFigure);
            app.gain4.Limits = [-10 10];
            app.gain4.Orientation = 'vertical';
            app.gain4.ValueChangedFcn = createCallbackFcn(app, @gain4ValueChanged, true);
            app.gain4.Position = [338 466 3 221];

            % Create Slider_7Label
            app.Slider_7Label = uilabel(app.UIFigure);
            app.Slider_7Label.HorizontalAlignment = 'right';
            app.Slider_7Label.Position = [429 436 36 22];
            app.Slider_7Label.Text = 'Slider';

            % Create gain5
            app.gain5 = uislider(app.UIFigure);
            app.gain5.Limits = [-10 10];
            app.gain5.Orientation = 'vertical';
            app.gain5.ValueChangedFcn = createCallbackFcn(app, @gain5ValueChanged, true);
            app.gain5.Position = [434 466 3 221];

            % Create Slider_8Label
            app.Slider_8Label = uilabel(app.UIFigure);
            app.Slider_8Label.HorizontalAlignment = 'right';
            app.Slider_8Label.Position = [514 437 36 22];
            app.Slider_8Label.Text = 'Slider';

            % Create gain6
            app.gain6 = uislider(app.UIFigure);
            app.gain6.Limits = [-10 10];
            app.gain6.Orientation = 'vertical';
            app.gain6.ValueChangedFcn = createCallbackFcn(app, @gain6ValueChanged, true);
            app.gain6.Position = [519 467 3 221];

            % Create Slider_9Label
            app.Slider_9Label = uilabel(app.UIFigure);
            app.Slider_9Label.HorizontalAlignment = 'right';
            app.Slider_9Label.Position = [599 436 36 22];
            app.Slider_9Label.Text = 'Slider';

            % Create gain7
            app.gain7 = uislider(app.UIFigure);
            app.gain7.Limits = [-10 10];
            app.gain7.Orientation = 'vertical';
            app.gain7.ValueChangedFcn = createCallbackFcn(app, @gain7ValueChanged, true);
            app.gain7.Position = [604 466 3 221];

            % Create Slider_10Label
            app.Slider_10Label = uilabel(app.UIFigure);
            app.Slider_10Label.HorizontalAlignment = 'right';
            app.Slider_10Label.Position = [698 436 36 22];
            app.Slider_10Label.Text = 'Slider';

            % Create gain8
            app.gain8 = uislider(app.UIFigure);
            app.gain8.Limits = [-10 10];
            app.gain8.Orientation = 'vertical';
            app.gain8.ValueChangedFcn = createCallbackFcn(app, @gain8ValueChanged, true);
            app.gain8.Position = [703 466 3 221];

            % Create Slider_11Label
            app.Slider_11Label = uilabel(app.UIFigure);
            app.Slider_11Label.HorizontalAlignment = 'right';
            app.Slider_11Label.Position = [883 430 36 22];
            app.Slider_11Label.Text = 'Slider';

            % Create gain10
            app.gain10 = uislider(app.UIFigure);
            app.gain10.Limits = [-10 10];
            app.gain10.Orientation = 'vertical';
            app.gain10.ValueChangedFcn = createCallbackFcn(app, @gain10ValueChanged, true);
            app.gain10.Position = [888 460 3 221];

            % Create Slider_12Label
            app.Slider_12Label = uilabel(app.UIFigure);
            app.Slider_12Label.HorizontalAlignment = 'right';
            app.Slider_12Label.Position = [792 430 36 22];
            app.Slider_12Label.Text = 'Slider';

            % Create gain9
            app.gain9 = uislider(app.UIFigure);
            app.gain9.Limits = [-10 10];
            app.gain9.Orientation = 'vertical';
            app.gain9.ValueChangedFcn = createCallbackFcn(app, @gain9ValueChanged, true);
            app.gain9.Position = [797 460 3 221];

            % Create Slider_13Label
            app.Slider_13Label = uilabel(app.UIFigure);
            app.Slider_13Label.HorizontalAlignment = 'right';
            app.Slider_13Label.Position = [87 436 36 22];
            app.Slider_13Label.Text = 'Slider';

            % Create gain1
            app.gain1 = uislider(app.UIFigure);
            app.gain1.Limits = [-10 10];
            app.gain1.Orientation = 'vertical';
            app.gain1.ValueChangedFcn = createCallbackFcn(app, @gain1ValueChanged, true);
            app.gain1.Position = [92 466 3 221];

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.Position = [480 725 35 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = EqualizerApp_ShaposnikA

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
