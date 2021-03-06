class GenerateMaintenanceServicesPrediction

    def initialize(params)
        @y_data = params.values[0]
        @x_data = Array.new(params.values[0].length) { |i| i = i+1 } #independent variable created from @y_data
        @y_data.map!{|i| i.to_i}
    end

    # https://www.alpharithms.com/simple-linear-regression-modeling-502111/ --> Explains linear regression model
    def get_prediction
        #@y_data = params.permit(:values => [])
        #@x_data = Array.new(@y_data.length)
        slope = get_slope() #Returns slope (pendiente/m)
        bias = get_bias(slope) #Return bias (tendencia/b/y_intersection)

        prediction_dataset = []
        #Returns linear regression for all @x_data and 1 more (# more custom in funcition)
        prediction_dataset = get_prediction_dataset(slope, bias) 

        prediction_next_month = 0
        #Returns next prediction
        prediction_next_month = prediction_dataset.last

        datos = {
            prediction_array: prediction_dataset,
            prediction_next_month: prediction_next_month
        }

        return datos
    end

    private

    def get_slope
        slope = 0 #data_error_sum/x_stand_errors_sum

        y_data_mean = 0
        y_data_mean = @y_data.inject{ |sum, i| sum + i }.to_f / @y_data.size #Mean for @y_data

        x_data_mean = 0
        x_data_mean = @x_data.inject{ |sum, i| sum + i }.to_f / @x_data.size #Mean for @x_data

        y_error = []
        @y_data.each do |y_data|
            y_error.push << y_data - y_data_mean #errors array for @y_data
        end

        x_error = []
        for value in @x_data do
            x_error.push << value - x_data_mean #errors array for @x_data
        end

        data_single_errors = []
        y_error.zip(x_error).each do |y_value, x_value|
            data_single_errors << y_value*x_value #errors array for data
        end
        
        data_error_sum = 0
        for value in data_single_errors do
            data_error_sum = data_error_sum + value #total sum of errors array for data
        end

        x_standardized_errors = []
        for value in x_error do
            x_standardized_errors.push << value**2 #array for x_standardized_errors
        end

        x_stand_errors_sum = 0
        for value in x_standardized_errors do
            x_stand_errors_sum = x_stand_errors_sum + value #sum of x_standardized_errors
        end

        slope = data_error_sum/x_stand_errors_sum

        return slope
    end

    def get_bias(slope)
        bias = 0

        y_data_mean = 0
        y_data_mean = @y_data.inject{ |sum, i| sum + i }.to_f / @y_data.size

        x_data_mean = 0
        x_data_mean = @x_data.inject{ |sum, i| sum + i }.to_f / @x_data.size

        bias = y_data_mean - (slope*x_data_mean)

        return bias
    end

    def get_prediction_dataset(slope, bias)
        slope_values = [] #y=mx+b // slope_values = slope*@x_data[i]+bias
        @x_data << (@x_data.last + 1)
        for value in @x_data do
            slope_values << (slope*value) + bias
        end

        return(slope_values)
    end
end