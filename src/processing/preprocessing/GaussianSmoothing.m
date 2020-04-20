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
        function coeffs = compute_coeffs(obj, m)
            coeffs = (obj.spectralChannels - m).^2;
            coeffs = coeffs ./ (2 * (obj.sigma^2));
            coeffs = exp(-coeffs);
        end

        function this = GaussianSmoothing(spectralChannels, sigma)
            % Store the parameters for use in the smooth function
            % this.windowSize = windowSize;
            this.sigma = sigma;
            this.spectralChannels = spectralChannels;
            this.coeffs = @(obj, m) compute_coeffs(obj, m);
        end

        function [estimationPoints, estimates] = smooth(obj, estimationPoints, intensities)
            estimationPoints = unique(estimationPoints);
            estimates = zeros(1, length(estimationPoints));
            for i = 1 : length(estimationPoints)
                coeffs = obj.coeffs(obj, estimationPoints(i));
                estimates(i) = dot(coeffs', intensities) ./ sum(coeffs);
                if(isnan(estimates(i)))
                  estimates(i) = 0;
                end
            end
        end
    end
end
