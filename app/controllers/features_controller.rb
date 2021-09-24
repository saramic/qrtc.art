class FeaturesController < ApplicationController
  def show
  end

  def toggle
    Feature.validate_feature!(params[:name])

    feature_name = params[:name]

    session[:features] ||= {}
    session[:features][feature_name] = !session[:features][feature_name]
    redirect_to action: :show
  end
end
