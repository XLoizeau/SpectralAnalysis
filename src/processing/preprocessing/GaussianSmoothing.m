classdef GaussianSmoothing < SpectralSmoothing % TODO: Change SpectralSmoothing to appropriate parent class
    properties (Constant)
        Name = 'Gaussian'; % TODO: Provide a sensible name
        Description = '';

        % TODO: Fill in parameter definitions
        ParameterDefinitions = [ParameterDescription('Sigma', ParameterType.Double, 2)];
    end

    properties
        sigma;
        spectralChannels;
        coeffs;
    end

    methods
        function this = GaussianSmoothing(spectralChannels, sigma)
            % Store the parameters for use in the smooth function
            % this.windowSize = windowSize;
            this.sigma = sigma;
            this.spectralChannels = spectralChannels;
            this.coeffs = @(obj, m) (1 / (sqrt(2 * pi) * obj.sigma)) * exp(-(obj.spectralChannels - m).^2 / (2 * obj.sigma^2));
        end

        function [estimationPoints, estimates] = smooth(obj, estimationPoints, intensities)
        estimationPoints = unique(estimationPoints);
            estimates = zeros(length(estimationPoints), 1);
            for i = 1 : length(estimationPoints)
                coeffs = obj.coeffs(obj, estimationPoints(i));
                estimates(i) =  coeffs' * intensities;
            end
        end
    end
end
