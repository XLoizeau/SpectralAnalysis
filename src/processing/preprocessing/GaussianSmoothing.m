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
        function coeffs = compute_coeffs(spectralChannels, sigma, m)
            coeffs = (spectralChannels - m).^2;
            coeffs = coeffs ./ (2 * (sigma^2));
            coeffs = exp(coeffs) ;
        end

        function this = GaussianSmoothing(spectralChannels, sigma)
            % Store the parameters for use in the smooth function
            % this.windowSize = windowSize;
            this.sigma = sigma;
            this.spectralChannels = spectralChannels;
            this.coeffs = @(obj, m) compute_coeffs(obj.spectralChannels, obj.sigma, m);
        end

        function [estimationPoints, estimates] = smooth(obj, estimationPoints, intensities)
            estimationPoints = unique(estimationPoints);
            estimates = zeros(length(estimationPoints), 1);
            for i = 1 : length(estimationPoints)
                coeffs = obj.coeffs(obj, estimationPoints(i));
                estimates(i) =  dot(coeffs', intensities) ./ sum(coeffs);
            end
        end
    end
end
